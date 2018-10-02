//
//  JDFormatJSFunction.m
//  JSDebugger
//
//  Created by z on 2018/9/21.
//  Copyright © 2018年 SatanWoo. All rights reserved.
//

#import "JDFormatJSFunction.h"

NSString *JDFormatJSFunction(NSString *JSFunctionName)
{
    NSArray *components = [JSFunctionName componentsSeparatedByString:@"_"];
    
    NSMutableString *actualMethodName = [[NSMutableString alloc] init];
    for (NSString *temp in components) {
        if (temp.length > 0) {
            [actualMethodName appendString:temp];
            [actualMethodName appendString:@":"];
        }
    }
    
    NSString *formattedName = actualMethodName.copy;
    if (components.count <= 1) {
        formattedName = [actualMethodName stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@":"]];
    }
    
    return formattedName;
}
