//
//  JDProperty.h
//  JSDebugger
//
//  Created by z on 2018/9/23.
//  Copyright © 2018年 SatanWoo. All rights reserved.
//

@import ObjectiveC.runtime;
#import "JDEncoding.h"

NS_ASSUME_NONNULL_BEGIN

@interface JDProperty : NSObject

@property (nonatomic, readonly) BOOL readonly;
@property (nonatomic, readonly) JDEncoding encoding;

@property (nonatomic, copy, readonly) NSString *setterName;
@property (nonatomic, copy, readonly) NSString *getterName;
@property (nonatomic, copy, readonly) NSString *propertyName;

- (instancetype)init NS_UNAVAILABLE;
+ (instancetype)new NS_UNAVAILABLE;
- (nullable instancetype)initWithProperty:(objc_property_t)property NS_DESIGNATED_INITIALIZER;

@end

@interface JDPropertiesInClass : NSObject

- (instancetype)init NS_UNAVAILABLE;
+ (instancetype)new NS_UNAVAILABLE;
- (nullable instancetype)initWithClass:(Class)cls;

- (NSArray<JDProperty *> *)properties;

@end

NS_ASSUME_NONNULL_END
