//
//  JDNSStringFromJSString.m
//  JSDebugger
//
//  Created by z on 2018/9/21.
//  Copyright © 2018年 SatanWoo. All rights reserved.
//

#import "JDNSStringFromJSString.h"

NSString *JDCreateNSStringFromJSString(JSContextRef ctx, JSStringRef value)
{
    CFStringRef ref = JSStringCopyCFString(kCFAllocatorDefault, (JSStringRef)value);
    NSString *string = (__bridge_transfer NSString *)ref;
    return string;
}
