//
//  JDVariadicArguments.m
//  Pods
//
//  Created by z on 2018/10/4.
//
//

#import "JDVariadicArguments.h"

@interface JDVariadicArguments()
@property (nonatomic, strong) NSMutableArray *arguments;
@end

@implementation JDVariadicArguments

- (instancetype)initWithArguments:(NSArray *)arguments
{
    self = [super init];
    if (self) {
        _arguments = @[].mutableCopy;
        
        for (id obj in arguments) {
            [_arguments addObject:obj];
        }
    }
    return self;
}

- (NSArray *)flatten:(BOOL)recursive
{
    if (!recursive) return self.arguments.copy;

    NSMutableArray *result = @[].mutableCopy;
    for (id obj in self.arguments) {
        if ([obj isKindOfClass:[JDVariadicArguments class]]) {
            [result addObject:[(JDVariadicArguments *)obj flatten:recursive]];
        } else {
            [result addObject:obj];
        }
    }
    return result.copy;
}

@end
