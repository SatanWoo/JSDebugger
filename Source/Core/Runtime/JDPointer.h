//
//  JDPointer.h
//  JSDebugger
//
//  Created by z on 2018/9/23.
//  Copyright © 2018年 SatanWoo. All rights reserved.
//

@import Foundation;

NS_ASSUME_NONNULL_BEGIN

@interface JDPointer : NSObject

- (instancetype)init NS_UNAVAILABLE;
+ (instancetype)new NS_UNAVAILABLE;

- (instancetype)initWithPointer:(void *)pointer NS_DESIGNATED_INITIALIZER;

- (void *)pointerValue;
- (const void *)constPointerValue;

@end

NS_ASSUME_NONNULL_END;
