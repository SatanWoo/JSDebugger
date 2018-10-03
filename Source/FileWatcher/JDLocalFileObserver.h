//
//  WZLocalFileObserver.h
//  WZDB
//
//  Created by z on 2018/1/6.
//  Copyright © 2018年 SatanWoo. All rights reserved.
//

@import Foundation;

NS_ASSUME_NONNULL_BEGIN

typedef void (^JDFileChangeBlock)(void);

@interface JDLocalFileObserver : NSObject

- (instancetype)initWithFilePath:(NSString *)filePath
                     changeBlock:(nullable JDFileChangeBlock)change NS_DESIGNATED_INITIALIZER;

- (void)start;
- (void)stop;

- (instancetype)init NS_UNAVAILABLE;
+ (instancetype)new NS_UNAVAILABLE;

@end

NS_ASSUME_NONNULL_END
