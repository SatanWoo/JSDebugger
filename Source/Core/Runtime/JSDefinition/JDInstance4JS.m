//
//  JDInstance4JS.m
//  JSDebugger
//
//  Created by z on 2018/9/20.
//  Copyright © 2018年 SatanWoo. All rights reserved.
//

#import "JDInstance4JS.h"
#import "JDMethod4JS.h"
#import "JDFormatJSFunction.h"
#import "JDProperty.h"
#import "JDPropertyCache.h"
#import "JDJSTypeToOCType.h"
#import "JDOCTypeToJSType.h"
#import "JDFFIContext.h"
#import "JDMethodBridge.h"
@import ObjectiveC.runtime;

#define JDCache \
        cache()

#define JDPrepareProperties \
        JDPropertiesInClass *propertiesInClass = [JDCache propertiesForClass:[instance class]]; \
        if (!propertiesInClass) { \
            propertiesInClass = [[JDPropertiesInClass alloc] initWithClass:[instance class]]; \
            [JDCache addProperty:propertiesInClass forClass:[instance class]]; \
        } \

static JDPropertyCache *cache(void)
{
    static JDPropertyCache *_cache = nil;
    if (!_cache) {
        _cache = [[JDPropertyCache alloc] init];
    }
    return _cache;
}

static JSValueRef JDInstanceGetProperty(JSContextRef ctx, JSObjectRef object, JSStringRef propertyName, JSValueRef *exception) {
    CFStringRef ref = JSStringCopyCFString(kCFAllocatorDefault, propertyName);
    NSString *ocPropertyName = (__bridge_transfer NSString *)ref;
    
    // @SatanWoo: Search Property First => Method IMP
    id instance = (__bridge id)(JSObjectGetPrivate(object));
    if (!instance) return JSValueMakeUndefined(ctx);
    
    // @SatanWoo: Try regard it as property getter call directly
    SEL sel_data = NSSelectorFromString(JDFormatJSFunction(ocPropertyName));
    
    // @SatanWoo: Give control back to Method4JS
    Method m = class_getInstanceMethod([instance class], sel_data);
    if (!m) return JSValueMakeUndefined(ctx);
    
    return JSObjectMake(ctx, JDMethod4JS(), (void *)sel_data);
}

static bool JDInstanceSetProperty(JSContextRef ctx, JSObjectRef object, JSStringRef propertyName, JSValueRef value, JSValueRef* exception)
{
    CFStringRef ref = JSStringCopyCFString(kCFAllocatorDefault, propertyName);
    NSString *ocPropertyName = (__bridge_transfer NSString *)ref;
    
    id instance = (__bridge id)(JSObjectGetPrivate(object));
    if (!instance) { return true; }
    
    // @SatanWoo: Fall to normal setter case
    NSString *setterName = [NSString stringWithFormat:@"set%@%@:",
     [ocPropertyName substringToIndex:1].uppercaseString,
     [ocPropertyName substringFromIndex:1]];
    
    SEL sel = NSSelectorFromString(setterName);
    IMP imp = class_getMethodImplementation([instance class], sel);
    NSMethodSignature *methodSignature = [instance methodSignatureForSelector:sel];
    
    if (!methodSignature) return false;
    
    JDMethodBridge *methodBridge = [[JDMethodBridge alloc] initWithSignature:methodSignature
                                                                    selector:sel
                                                                     instace:instance
                                                                         imp:imp];
    JSValueRef *arguments = (JSValueRef *)malloc(sizeof(JSValueRef) * 1);
    arguments[0] = value;
    JDCallFunction(ctx, methodBridge, 1, arguments);
    free(arguments);
    
    return false;
}

JSClassRef JDInstance4JS(void)
{
    static dispatch_once_t onceToken;
    static JSClassRef instanceRef = nil;
    dispatch_once(&onceToken, ^{
        JSClassDefinition instanceDefinition;
        instanceDefinition = kJSClassDefinitionEmpty;
        instanceDefinition.className = "JDInstance4JS";
        instanceDefinition.getProperty = &JDInstanceGetProperty;
        instanceDefinition.setProperty = &JDInstanceSetProperty;
        instanceRef = JSClassCreate(&instanceDefinition);
    });
    return instanceRef;
}
