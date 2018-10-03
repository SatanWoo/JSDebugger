//
//  WZLocalFileObserver.m
//  WZDB
//
//  Created by z on 2018/1/6.
//  Copyright © 2018年 SatanWoo. All rights reserved.
//

#import "JDLocalFileObserver.h"

@interface JDLocalFileObserver()

@property (nonatomic, copy) JDFileChangeBlock changeBlock;
@property (nonatomic, copy) NSString *filePath;

@property (nonatomic, strong) dispatch_source_t fileSource;
@property (nonatomic) int fileHandle;
@end

@implementation JDLocalFileObserver

- (instancetype)initWithFilePath:(NSString *)filePath changeBlock:(JDFileChangeBlock)change
{
    self = [super init];
    if (self) {
        _filePath = [filePath copy];
        _changeBlock = [change copy];
    }
    return self;
}

- (void)start
{
    if (self.fileSource) { return; }
    
    self.fileHandle = open([self.filePath fileSystemRepresentation], O_EVTONLY);
    if (self.fileHandle < 0) {
        NSException *exception = [NSException exceptionWithName:@"JDFileLoadFailed"
                                                         reason:@"[JSDebugger]::File Handle Cannot Be Created"
                                                       userInfo:@{@"filePath": self.filePath ?: @""}];
        
        [exception raise];
    }
    
    self.fileSource = dispatch_source_create(DISPATCH_SOURCE_TYPE_VNODE,
                                             self.fileHandle,
                                             DISPATCH_VNODE_WRITE,
                                             DISPATCH_TARGET_QUEUE_DEFAULT);
    
    dispatch_source_set_event_handler(self.fileSource, ^() {
        unsigned long const type = dispatch_source_get_data(self.fileSource);
        switch (type) {
            default:
            {
                if (self.changeBlock) self.changeBlock();
                break;
            }
        }
    });
    
    dispatch_source_set_cancel_handler(self.fileSource, ^{
        close(self.fileHandle);
    });
    
    dispatch_resume(self.fileSource);
}

- (void)stop
{
    if (!self.fileSource) { return; }
    
    dispatch_cancel(self.fileSource);
    self.fileSource = nil;
}

@end
