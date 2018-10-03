//
//  JDMethod4JS.m
//  JSDebugger
//
//  Created by z on 2018/9/20.
//  Copyright © 2018年 SatanWoo. All rights reserved.
//

#import "JDMethod4JS.h"
#import "JDClass4JS.h"
#import "JDInstance4JS.h"
#import "JDMethodBridge.h"
#import "JDFFIContext.h"
#import "JDPointer.h"
@import ObjectiveC.runtime;

static JSValueRef JDMethodCallAsFunction(JSContextRef ctx, JSObjectRef function, JSObjectRef thisObject, size_t argumentCount, const JSValueRef arguments[], JSValueRef *exception)
{
    SEL sel = JSObjectGetPrivate(function);
    
    Class toSearchClass = nil;
    id candidate = nil;
    
    if (JSValueIsObjectOfClass(ctx, thisObject, JDClass4JS())) {
        Class cls = (__bridge Class)JSObjectGetPrivate(thisObject);
        if (!cls) { return JSValueMakeUndefined(ctx); }
        
        toSearchClass = object_getClass(cls);
        candidate = cls;
    } else if (JSValueIsObjectOfClass(ctx, thisObject, JDInstance4JS())) {
        id instance = (__bridge id)(JSObjectGetPrivate(thisObject));
        if (!instance) { return JSValueMakeUndefined(ctx); }
        
        toSearchClass = [instance class];
        candidate = instance;
    }
    
    if (!toSearchClass) { return JSValueMakeUndefined(ctx); }
    
    Method m = class_getInstanceMethod(toSearchClass, sel);
    if (!m) { return JSValueMakeUndefined(ctx); }
    
    IMP imp = method_getImplementation(m);
    
    NSMethodSignature *methodSignature = [candidate methodSignatureForSelector:sel];
    JDMethodBridge *methodBridge = [[JDMethodBridge alloc] initWithSignature:methodSignature
                                                                    selector:sel
                                                                     instace:candidate
                                                                         imp:imp];
    return JDCallFunction(ctx, methodBridge, argumentCount, arguments);
}

JSClassRef JDMethod4JS()
{
    static dispatch_once_t onceToken;
    static JSClassRef methodRef = nil;
    dispatch_once(&onceToken, ^{
        JSClassDefinition methodDefinition;
        methodDefinition = kJSClassDefinitionEmpty;
        methodDefinition.className = "JDClass";
        methodDefinition.callAsFunction = &JDMethodCallAsFunction;
        methodRef = JSClassCreate(&methodDefinition);
    });
    return methodRef;
}
