//
//  JDProperty.h
//  JSDebugger
//
//  Created by z on 2018/9/23.
//  Copyright © 2018年 SatanWoo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <objc/runtime.h>
#import "JDEncoding.h"

@interface JDProperty : NSObject

@property (nonatomic, readonly) BOOL readonly;
@property (nonatomic, readonly) JDEncoding encoding;

@property (nonatomic, copy, readonly) NSString *setterName;
@property (nonatomic, copy, readonly) NSString *getterName;
@property (nonatomic, copy, readonly) NSString *propertyName;

- (instancetype)init NS_UNAVAILABLE;
- (instancetype)initWithProperty:(objc_property_t)property;

@end


@interface JDPropertiesInClass : NSObject

- (instancetype)init NS_UNAVAILABLE;
- (instancetype)initWithClass:(Class)cls;

- (NSArray<JDProperty *> *)properties;

@end
