//
//  JDOCTypeToJSType.m
//  JSDebugger
//
//  Created by z on 2018/9/21.
//  Copyright © 2018年 SatanWoo. All rights reserved.
//

#import "JDOCTypeToJSType.h"
#import "JDClass4JS.h"
#import "JDInstance4JS.h"
@import ObjectiveC.runtime;

static bool isBooleanClass(NSNumber *number)
{
    if (![number isKindOfClass:[NSNumber class]]) { return false; }
    return [number class] == [@(YES) class];
}

JSValueRef JDConvertNSObjectToJSValue(JSContextRef ctx, NSObject *object)
{
    if (!object) { return JSValueMakeUndefined(ctx); }
    
    Class cls = object_getClass(object);
    
    Protocol *jsExportProtocol = objc_getProtocol("JSExport");
    
    if (!class_conformsToProtocol(cls, jsExportProtocol)) {
        if ([object isKindOfClass:[NSArray class]]) {
            NSArray *array = (NSArray *)object;
            JSValueRef *values = (JSValueRef *)malloc(sizeof(JSValueRef) * array.count);
            
            for (NSUInteger i = 0; i < array.count; i++) {
                values[i] = JDConvertNSObjectToJSValue(ctx, array[i]);
            }
            
            JSObjectRef jsArray = JSObjectMakeArray(ctx, array.count, values, NULL);
            free(values);
            
            return jsArray;
        } else if ([object isKindOfClass:[NSDictionary class]]) {
            NSData *data = [NSJSONSerialization dataWithJSONObject:object options:NSJSONWritingPrettyPrinted error:nil];
            NSString *string = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
            JSStringRef stringRef = JSStringCreateWithUTF8CString(string.UTF8String);
            JSValueRef value = JSValueMakeFromJSONString(ctx, stringRef);
            JSStringRelease(stringRef);
            return value;
            
        } else if ([object isKindOfClass:[NSNumber class]]) {
            if (isBooleanClass((NSNumber *)object)) return JSValueMakeBoolean(ctx, [(NSNumber *)object boolValue]);
            return JSValueMakeNumber(ctx, [(NSNumber *)object doubleValue]);
            
        } else if ([object isKindOfClass:[NSString class]]) {
            JSStringRef string = JSStringCreateWithCFString((__bridge CFStringRef)(NSString *)object);
            JSValueRef js = JSValueMakeString(ctx, string);
            JSStringRelease(string);
            return js;
            
        } else if ([object isKindOfClass:[NSDate class]]) {
            JSValueRef argument = JSValueMakeNumber(ctx, [(NSDate *)object timeIntervalSince1970]);
            return JSObjectMakeDate(ctx, 1, &argument, 0);
            
        } else if ([object isKindOfClass:[NSNull class]]) {
            return JSValueMakeNull(ctx);
        }
    }
    
    if (class_isMetaClass(cls)) {
        return JSObjectMake(ctx, JDClass4JS(), (__bridge void *)cls);
    } else {
        return JSObjectMake(ctx, JDInstance4JS(), (__bridge void *)object);
    }
}

