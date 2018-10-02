//
//  WZLocalFileObserver.h
//  WZDB
//
//  Created by z on 2018/1/6.
//  Copyright © 2018年 SatanWoo. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN
typedef void (^JDFileChangeBlock)();

@interface JDLocalFileObserver : NSObject

- (instancetype)initWithFilePath:(NSString *)filePath
                     changeBlock:(nullable JDFileChangeBlock)change;

- (void)start;
- (void)stop;

@end
NS_ASSUME_NONNULL_END
