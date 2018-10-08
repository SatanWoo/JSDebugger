//
//  TestAssociateObject.m
//  JSDebuggerDemo
//
//  Created by z on 2018/10/8.
//  Copyright © 2018年 SatanWoo. All rights reserved.
//

#import "TestAssociateObject.h"
#import <objc/runtime.h>


@implementation TestAssociateObject

@end

@implementation TestAssociateObject(Associate)

- (void)setAssociateInt:(NSInteger)associateInt
{
    NSNumber *number = @(associateInt);
    objc_setAssociatedObject(self, _cmd, number, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (NSInteger)associateInt
{
    NSNumber *number = objc_getAssociatedObject(self, @selector(setAssociateInt:));
    if (![number isKindOfClass:[NSNumber class]]) {
        return NSNotFound;
    }
    return [number integerValue];
}

@end
