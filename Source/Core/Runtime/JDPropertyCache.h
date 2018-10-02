//
//  JDPropertyCache.h
//  JSDebugger
//
//  Created by z on 2018/9/23.
//  Copyright © 2018年 SatanWoo. All rights reserved.
//

#import <Foundation/Foundation.h>

@class JDPropertiesInClass;

@interface JDPropertyCache : NSObject

- (instancetype)init;
- (instancetype)initWithCapacity:(NSInteger)capacity;

- (void)addProperty:(JDPropertiesInClass *)pic forClass:(Class)cls;
- (JDPropertiesInClass *)propertiesForClass:(Class)cls;

@end
