//
//  NSDictionary+GeoConvert.m
//  WZDB
//
//  Created by z on 2018/3/29.
//  Copyright © 2018年 SatanWoo. All rights reserved.
//

#import "NSDictionary+JSConvert.h"

@implementation NSDictionary (JSConvert)

#if CGFLOAT_IS_DOUBLE
#define CGFloatValue doubleValue
#else
#define CGFloatValue floatValue
#endif

#pragma mark - CGRect
- (CGRect)rectValue
{
    assert([self.allKeys containsObject:@"origin"]);
    assert([self.allKeys containsObject:@"size"]);
    
    CGRect rect;
    
    rect.origin.x = [self[@"origin"][@"x"] CGFloatValue];
    rect.origin.y = [self[@"origin"][@"y"] CGFloatValue];
    
    rect.size.width = [self[@"size"][@"width"] CGFloatValue];
    rect.size.height = [self[@"size"][@"height"] CGFloatValue];
    
    return rect;
}

- (BOOL)convertToRect:(CGRect *)rect
{
    if (rect == NULL) return NO;
    if (![self.allKeys containsObject:@"origin"]) return NO;
    if (![self.allKeys containsObject:@"size"]) return NO;
    
    CGRect value = [self rectValue];
    rect->origin = value.origin;
    rect->size = value.size;
    
    return YES;
}

- (BOOL)canConvertToRect
{
    CGRect rect;
    return [self convertToRect:&rect];
}

#pragma mark - CGPoint
- (CGPoint)pointValue
{
    assert([self.allKeys containsObject:@"x"]);
    assert([self.allKeys containsObject:@"y"]);
    
    CGPoint p;
    p.x = [self[@"x"] CGFloatValue];
    p.y = [self[@"y"] CGFloatValue];
    
    return p;
}

- (BOOL)convertToPoint:(CGPoint *)point
{
    if (point == NULL) return NO;
    if (![self.allKeys containsObject:@"x"]) return NO;
    if (![self.allKeys containsObject:@"y"]) return NO;
    
    CGPoint p = [self pointValue];
    
    point->x = p.x;
    point->y = p.y;
    
    return YES;
}

- (BOOL)canConvertToPoint
{
    CGPoint point;
    return [self convertToPoint:&point];
}

#pragma mark - CGSize
- (CGSize)sizeValue
{
    assert([self.allKeys containsObject:@"width"]);
    assert([self.allKeys containsObject:@"height"]);

    CGSize size;
    size.width = [self[@"width"] CGFloatValue];
    size.height = [self[@"height"] CGFloatValue];
    
    return size;
}

- (BOOL)convertToSize:(CGSize *)size
{
    if (size == NULL) return NO;
    if (![self.allKeys containsObject:@"width"]) return NO;
    if (![self.allKeys containsObject:@"height"]) return NO;
    
    size->width = [self[@"width"] CGFloatValue];
    size->height = [self[@"height"] CGFloatValue];
    return YES;
}

- (BOOL)canConvertToSize
{
    CGSize size;
    return [self convertToSize:&size];
}

@end
