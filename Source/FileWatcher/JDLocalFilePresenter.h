//
//  JSLocalFilePresenter.h
//  Pods
//
//  Created by z on 2018/11/4.
//
//

#import <Foundation/Foundation.h>

@class JDLocalFilePresenter;

@protocol JDLocalFilePresenterDelegate<NSObject>
- (void)fileDidChangeAtURL:(NSURL *)URL inPresenter:(JDLocalFilePresenter *)presenter;
@end

@interface JDLocalFilePresenter : NSObject<NSFilePresenter>
@property (nonatomic, weak) id <JDLocalFilePresenterDelegate> delegate;
- (instancetype)initWithFile:(NSString *)localJSPath;
@end
