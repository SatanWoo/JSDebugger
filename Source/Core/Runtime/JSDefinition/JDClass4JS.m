//
//  JDClass4JS.m
//  JSDebugger
//
//  Created by z on 2018/9/20.
//  Copyright © 2018年 SatanWoo. All rights reserved.
//

#import "JDClass4JS.h"
#import "JDMethod4JS.h"
#import "JDFormatJSFunction.h"
#import "JDClass4JS.h"
#import <objc/runtime.h>

static JSValueRef JDClassGetProperty(JSContextRef ctx, JSObjectRef object, JSStringRef propertyName, JSValueRef *exception) {
    CFStringRef ref = JSStringCopyCFString(kCFAllocatorDefault, propertyName);
    NSString *property = (__bridge NSString *)ref;
    
    id ocClass = (__bridge Class)(JSObjectGetPrivate(object));
    if (!ocClass) {
        CFRelease(ref);
        return JSValueMakeUndefined(ctx);
    }
    
    SEL sel = NSSelectorFromString(JDFormatJSFunction(property));
    if (!sel) {
        CFRelease(ref);
        return JSValueMakeUndefined(ctx);
    }
    
    return JSObjectMake(ctx, JDMethod4JS(), (void *)sel);
}

JSClassRef JDClass4JS()
{
    static dispatch_once_t onceToken;
    static JSClassRef classRef = nil;
    dispatch_once(&onceToken, ^{
        JSClassDefinition classDefinition;
        classDefinition = kJSClassDefinitionEmpty;
        classDefinition.className = "JDClass";
        classDefinition.getProperty = &JDClassGetProperty;
        classRef = JSClassCreate(&classDefinition);
    });
    return classRef;
}


