//
//  JSLocalFilePresenter.m
//  Pods
//
//  Created by z on 2018/11/4.
//
//

#import "JDLocalFilePresenter.h"

@interface JDLocalFilePresenter()
@property (nonatomic, copy) NSString *filePath;
@end

@implementation JDLocalFilePresenter

- (instancetype)initWithFile:(NSString *)localJSPath
{
    self = [super init];
    if (self) {
        _filePath = [localJSPath stringByResolvingSymlinksInPath];
    }
    return self;
}

#pragma mark - NSFilePresenter
- (NSURL *)presentedItemURL
{
    return [NSURL fileURLWithPath:self.filePath];
}

- (NSOperationQueue *)presentedItemOperationQueue
{
    return [NSOperationQueue mainQueue];
}

- (void)presentedItemDidChange
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(fileDidChangeAtURL:inPresenter:)]) {
        [self.delegate fileDidChangeAtURL:[self presentedItemURL] inPresenter:self];
    }
}

@end
