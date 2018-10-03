//
//  JDVariadicArguments.h
//  Pods
//
//  Created by z on 2018/10/4.
//
//

#import <Foundation/Foundation.h>

@interface JDVariadicArguments : NSObject

- (instancetype)initWithArguments:(NSArray *)arguments;
- (NSArray *)flatten:(BOOL)recursive;

@end
