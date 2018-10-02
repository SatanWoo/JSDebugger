//
//  JDPropertyCache.m
//  JSDebugger
//
//  Created by z on 2018/9/23.
//  Copyright © 2018年 SatanWoo. All rights reserved.
//

#import "JDPropertyCache.h"
#import "JDProperty.h"

const NSUInteger JDDefaultPropertyCacheCapacity = 20;

@interface JDPropertyCache()
@property (nonatomic, strong) NSMapTable *clsToProperties;
@end

@implementation JDPropertyCache

- (instancetype)init
{
    return [self initWithCapacity:JDDefaultPropertyCacheCapacity];
}

- (instancetype)initWithCapacity:(NSInteger)capacity
{
    self = [super init];
    if (self) {
        _clsToProperties = [[NSMapTable alloc] initWithKeyOptions:NSPointerFunctionsWeakMemory
                                                     valueOptions:NSPointerFunctionsStrongMemory capacity:capacity];
    }
    return self;
}

#pragma mark - Public API
- (void)addProperty:(JDPropertiesInClass *)pic forClass:(Class)cls
{
    if (!pic) return;
    [self.clsToProperties setObject:pic forKey:cls];
}

- (JDPropertiesInClass *)propertiesForClass:(Class)cls
{
    return [self.clsToProperties objectForKey:cls];
}

@end
