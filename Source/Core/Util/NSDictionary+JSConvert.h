//
//  NSDictionary+GeoConvert.h
//  WZDB
//
//  Created by z on 2018/3/29.
//  Copyright © 2018年 SatanWoo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreGraphics/CoreGraphics.h>

// Not Fully Supported
// Only CGRect, CGPoint, CGSize are convertiable temporarily

@interface NSDictionary (JSConvert)

- (CGRect)rectValue;
- (BOOL)convertToRect:(CGRect *)rect;
- (BOOL)canConvertToRect;

- (CGPoint)pointValue;
- (BOOL)convertToPoint:(CGPoint *)point;
- (BOOL)canConvertToPoint;

- (CGSize)sizeValue;
- (BOOL)convertToSize:(CGSize *)size;
- (BOOL)canConvertToSize;

@end
