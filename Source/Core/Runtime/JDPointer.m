//
//  JDPointer.m
//  JSDebugger
//
//  Created by z on 2018/9/23.
//  Copyright © 2018年 SatanWoo. All rights reserved.
//

#import "JDPointer.h"

@interface JDPointer()

@property (nonatomic) void *pointer;

@end

@implementation JDPointer

- (instancetype)initWithPointer:(void *)pointer
{
    self = [super init];
    if (self) {
        _pointer = pointer;
    }
    return self;
}

- (const void *)pointer
{
    return (const void *)_pointer;
}

@end
