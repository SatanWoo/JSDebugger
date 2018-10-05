//
//  JDJSTypeToOCType.m
//  JSDebugger
//
//  Created by z on 2018/9/21.
//  Copyright © 2018年 SatanWoo. All rights reserved.
//

#import "JDJSTypeToOCType.h"
#import "JDNSStringFromJSString.h"
#import "JDClass4JS.h"
#import "JDInstance4JS.h"
#import "JDMethod4JS.h"
#import "JDPointer.h"

id JDConvertJSValueToNSObject(JSContextRef ctx, JSValueRef value)
{
    JSType type = JSValueGetType(ctx, value);
    
    switch(type) {
        case kJSTypeString:{
            JSStringRef s = JSValueToStringCopy(ctx, value, NULL);
            NSString *str = JDCreateNSStringFromJSString(ctx, s);
            JSStringRelease(s);
            return str;
        }
        case kJSTypeBoolean: { return [NSNumber numberWithBool:JSValueToBoolean(ctx, value)]; }
        case kJSTypeNumber: { return [NSNumber numberWithDouble:JSValueToNumber(ctx, value, NULL)]; }
        case kJSTypeNull: { return [NSNull null]; }
        case kJSTypeUndefined: { return nil; }
        case kJSTypeObject:  break; 
    }
    
    if (type == kJSTypeObject) {
        
        if (JSValueIsDate(ctx, value)) {
            double val = JSValueToNumber(ctx, value, NULL);
            NSDate *date = [NSDate dateWithTimeIntervalSince1970:val / 1000.0f];
            return date;
            
        } else if (JSValueIsArray(ctx, value)) {
            JSStringRef lengthName = JSStringCreateWithUTF8CString("length");
            int count = JSValueToNumber(ctx, JSObjectGetProperty(ctx, (JSObjectRef)value, lengthName, NULL), NULL);
            JSStringRelease(lengthName);
            
            NSMutableArray *array = [NSMutableArray arrayWithCapacity:count];
            for( int i = 0; i < count; i++ ) {
                NSObject *obj = JDConvertJSValueToNSObject(ctx, JSObjectGetPropertyAtIndex(ctx, (JSObjectRef)value, i, NULL));
                array[i] = obj ?: [NSNull null];
            }
            
            return array.copy;
        }
        
        else {
            // @SatanWoo First Check Is Self-Defined Class
            if (JSValueIsObjectOfClass(ctx, value, JDClass4JS())) {
                Class cls = (__bridge Class)JSObjectGetPrivate((JSObjectRef)value);
                return cls;
            } else if (JSValueIsObjectOfClass(ctx, value, JDInstance4JS())) {
                id instance = (__bridge id)JSObjectGetPrivate((JSObjectRef)value);
                return instance;
            } else if (JSValueIsObjectOfClass(ctx, value, JDMethod4JS())) {
                SEL sel = (SEL)JSObjectGetPrivate((JSObjectRef)value);
                return [NSValue valueWithPointer:sel];
            }
            
            
            // @SatanWoo Then regard it as plain object and convert it to NSDictionary
            JSPropertyNameArrayRef properties = JSObjectCopyPropertyNames(ctx, (JSObjectRef)value);
            size_t count = JSPropertyNameArrayGetCount(properties);
            
            NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithCapacity:count];
            for( size_t i = 0; i < count; i++ ) {
                JSStringRef jsName = JSPropertyNameArrayGetNameAtIndex(properties, i);
                NSObject *obj = JDConvertJSValueToNSObject(ctx, JSObjectGetProperty(ctx, (JSObjectRef)value, jsName, NULL));
                
                NSString *name = JDCreateNSStringFromJSString(ctx, jsName);
                dict[name] = obj ? obj : NSNull.null;
            }
            
            JSPropertyNameArrayRelease(properties);
            return dict;
        }
    }
    
    return nil;
}
