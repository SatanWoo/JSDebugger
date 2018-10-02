//
//  JDPointer.h
//  JSDebugger
//
//  Created by z on 2018/9/23.
//  Copyright © 2018年 SatanWoo. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JDPointer : NSObject

- (instancetype)init NS_UNAVAILABLE;
- (instancetype)initWithPointer:(void *)pointer;

- (const void *)pointer;

@end
