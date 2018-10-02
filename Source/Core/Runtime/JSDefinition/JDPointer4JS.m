//
//  JDPointer4JS.m
//  JSDebugger
//
//  Created by z on 2018/10/1.
//  Copyright © 2018年 SatanWoo. All rights reserved.
//

#import "JDPointer4JS.h"

JSClassRef JDPointer4JS()
{
    static dispatch_once_t onceToken;
    static JSClassRef pointerRef = nil;
    dispatch_once(&onceToken, ^{
        JSClassDefinition pointerDefinition;
        pointerDefinition = kJSClassDefinitionEmpty;
        pointerDefinition.className = "JDPointer";
        //pointerDefinition.callAsFunction = &JDMethodCallAsFunction;
        pointerRef = JSClassCreate(&pointerDefinition);
    });
    return pointerRef;
}
