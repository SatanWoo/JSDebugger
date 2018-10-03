//
//  NSDictionary+GeoConvert.h
//  WZDB
//
//  Created by z on 2018/3/29.
//  Copyright © 2018年 SatanWoo. All rights reserved.
//

@import Foundation;

// Not Fully Supported
// Only CGRect, CGPoint, CGSize are convertiable temporarily
NS_ASSUME_NONNULL_BEGIN

@interface NSDictionary (JSConvert)

- (CGRect)jd_rectValue;
- (BOOL)jd_convertToRect:(CGRect *)rect;
- (BOOL)jd_canConvertToRect;

- (CGPoint)jd_pointValue;
- (BOOL)jd_convertToPoint:(CGPoint *)point;
- (BOOL)jd_canConvertToPoint;

- (CGSize)jd_sizeValue;
- (BOOL)jd_convertToSize:(CGSize *)size;
- (BOOL)jd_canConvertToSize;

@end

NS_ASSUME_NONNULL_END
