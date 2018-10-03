//
//  JDPropertyCache.h
//  JSDebugger
//
//  Created by z on 2018/9/23.
//  Copyright © 2018年 SatanWoo. All rights reserved.
//

@import Foundation;

@class JDPropertiesInClass;

NS_ASSUME_NONNULL_BEGIN

@interface JDPropertyCache : NSObject

- (instancetype)initWithCapacity:(NSInteger)capacity;

- (void)addProperty:(JDPropertiesInClass *)pic forClass:(Class)cls;
- (JDPropertiesInClass *)propertiesForClass:(Class)cls;

@end

NS_ASSUME_NONNULL_END
