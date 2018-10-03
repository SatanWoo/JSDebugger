//
//  JDIntrospect.m
//  JSDebugger
//
//  Created by z on 2018/9/21.
//  Copyright © 2018年 SatanWoo. All rights reserved.
//

#import "JDIntrospect.h"

#import "JDOCTypeToJSType.h"
#import "JDLog.h"
#import "NSObject+JDRuntimeIntrospection.h"
#import <objc/runtime.h>
#import <JavaScriptCore/JavaScriptCore.h>

static JSValueRef introspect(JSContextRef ctx, JSObjectRef function, JSObjectRef thisObject, size_t argumentCount, const JSValueRef arguments[], JSValueRef *exception)
{
    if (argumentCount != 1) {
        JDLog(@"introspect() takes a class argument");
        return NULL;
    }
    
    JSValueRef value = arguments[0];
    JSObjectRef objectRef = const_cast<JSObjectRef>(value);
    id obj = (__bridge id)(JSObjectGetPrivate(objectRef));
    if (!obj) return JSObjectMakeArray(ctx, 0, NULL, exception);
    
    NSArray *result = [JDIntrospect introspect:obj];
    return JDConvertNSObjectToJSValue(ctx, result);
}


@implementation JDIntrospect

JD_REGISTER_PLUGIN(&introspect, "introspect");

+ (NSArray *)introspect:(id)_obj
{
    NSArray *result = [_obj jd_logAllProperties];
    return  result;
}

@end



