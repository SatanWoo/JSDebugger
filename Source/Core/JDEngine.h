//
//  JDEngine.h
//  JSDebugger
//
//  Created by z on 2018/9/20.
//  Copyright © 2018年 SatanWoo. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JDEngine : NSObject

+ (JDEngine *)engine;

- (void)start;

- (void)evaluateScript:(NSString *)scriptContent;
- (void)evaluateScriptAtPath:(NSString *)path;

@end
