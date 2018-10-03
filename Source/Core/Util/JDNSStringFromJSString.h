//
//  JDNSStringFromJSString.h
//  JSDebugger
//
//  Created by z on 2018/9/21.
//  Copyright © 2018年 SatanWoo. All rights reserved.
//

@import JavaScriptCore;

FOUNDATION_EXTERN NSString *JDCreateNSStringFromJSString(JSContextRef ctx, JSStringRef value);
