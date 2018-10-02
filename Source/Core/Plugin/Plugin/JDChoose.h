//
//  JDChoose.h
//  JSDebugger
//
//  Created by z on 2018/9/20.
//  Copyright © 2018年 SatanWoo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JDFunctionPlugin.h"

@interface JDChoose : NSObject<JDFunctionPlugin>
+ (NSArray *)choose:(Class)aClass;
@end
