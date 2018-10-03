//
//  NSDictionary+GeoConvert.m
//  WZDB
//
//  Created by z on 2018/3/29.
//  Copyright © 2018年 SatanWoo. All rights reserved.
//

#import "NSDictionary+JSConvert.h"

#if CGFLOAT_IS_DOUBLE

#define CGFloatValue doubleValue

#else

#define CGFloatValue floatValue

#endif

@implementation NSDictionary (JSConvert)

#pragma mark - CGRect

- (CGRect)jd_rectValue
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

- (BOOL)jd_convertToRect:(CGRect *)rect
{
    if (rect == NULL) { return NO; }
    if (![self.allKeys containsObject:@"origin"]) { return NO; }
    if (![self.allKeys containsObject:@"size"]) { return NO; }
    
    CGRect value = [self jd_rectValue];
    rect->origin = value.origin;
    rect->size = value.size;
    
    return YES;
}

- (BOOL)jd_canConvertToRect
{
    CGRect rect;
    return [self jd_convertToRect:&rect];
}

#pragma mark - CGPoint

- (CGPoint)jd_pointValue
{
    assert([self.allKeys containsObject:@"x"]);
    assert([self.allKeys containsObject:@"y"]);
    
    CGPoint p;
    p.x = [self[@"x"] CGFloatValue];
    p.y = [self[@"y"] CGFloatValue];
    
    return p;
}

- (BOOL)jd_convertToPoint:(CGPoint *)point
{
    if (point == NULL) { return NO; }
    if (![self.allKeys containsObject:@"x"]) { return NO; }
    if (![self.allKeys containsObject:@"y"]) { return NO; }
    
    CGPoint p = [self jd_pointValue];
    
    point->x = p.x;
    point->y = p.y;
    
    return YES;
}

- (BOOL)jd_canConvertToPoint
{
    CGPoint point;
    return [self jd_convertToPoint:&point];
}

#pragma mark - CGSize

- (CGSize)jd_sizeValue
{
    assert([self.allKeys containsObject:@"width"]);
    assert([self.allKeys containsObject:@"height"]);

    CGSize size;
    size.width = [self[@"width"] CGFloatValue];
    size.height = [self[@"height"] CGFloatValue];
    
    return size;
}

- (BOOL)jd_convertToSize:(CGSize *)size
{
    if (size == NULL) return NO;
    if (![self.allKeys containsObject:@"width"]) { return NO; }
    if (![self.allKeys containsObject:@"height"]) { return NO; }
    
    size->width = [self[@"width"] CGFloatValue];
    size->height = [self[@"height"] CGFloatValue];
    return YES;
}

- (BOOL)jd_canConvertToSize
{
    CGSize size;
    return [self jd_convertToSize:&size];
}

@end
