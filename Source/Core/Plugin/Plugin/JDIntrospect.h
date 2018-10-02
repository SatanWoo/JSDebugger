//
//  JDIntrospect.h
//  JSDebugger
//
//  Created by z on 2018/9/21.
//  Copyright © 2018年 SatanWoo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JDFunctionPlugin.h"

@interface JDIntrospect : NSObject<JDFunctionPlugin>
+ (NSArray *)introspect:(id)_obj;
@end
