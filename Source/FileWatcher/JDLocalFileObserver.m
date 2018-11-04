//
//  WZLocalFileObserver.m
//  WZDB
//
//  Created by z on 2018/1/6.
//  Copyright © 2018年 SatanWoo. All rights reserved.
//

#import "JDLocalFileObserver.h"
#import "JDLocalFilePresenter.h"

@interface JDLocalFileObserver() <JDLocalFilePresenterDelegate>

@property (nonatomic, copy) JDFileChangeBlock changeBlock;
@property (nonatomic, copy) NSString *filePath;
@property (nonatomic, strong) JDLocalFilePresenter *presenter;

@end

@implementation JDLocalFileObserver

- (instancetype)initWithFilePath:(NSString *)filePath changeBlock:(JDFileChangeBlock)change
{
    self = [super init];
    if (self) {
        _filePath = [filePath copy];
        _changeBlock = [change copy];
        
        _presenter = [[JDLocalFilePresenter alloc] initWithFile:_filePath];
        _presenter.delegate = self;
    }
    return self;
}

- (void)start
{
    [NSFileCoordinator addFilePresenter:self.presenter];
}

- (void)stop
{
    [NSFileCoordinator removeFilePresenter:self.presenter];
}

#pragma mark - JDLocalFilePresenterDelegate
- (void)fileDidChangeAtURL:(NSURL *)URL inPresenter:(JDLocalFilePresenter *)presenter
{
    if (self.changeBlock) self.changeBlock();
}

@end
