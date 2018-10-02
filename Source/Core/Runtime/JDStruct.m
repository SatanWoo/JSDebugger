//
//  JDStruct.m
//  JSDebugger
//
//  Created by z on 2018/9/22.
//  Copyright © 2018年 SatanWoo. All rights reserved.
//

#import "JDStruct.h"

static NSMutableDictionary *structInfo = nil;

NSString *JDGetStructName(const char *c)
{
    NSString *typeEncodeString = [NSString stringWithUTF8String:c];
    
    NSArray *array = [typeEncodeString componentsSeparatedByString:@"="];
    NSString *typeString = array[0];
    int firstValidIndex = 0;
    for (int i = 0; i< typeString.length; i++) {
        char c = [typeString characterAtIndex:i];
        if (c == '{' || c=='_') {
            firstValidIndex++;
        }else {
            break;
        }
    }
    return [typeString substringFromIndex:firstValidIndex];
}

@implementation JDStruct

+ (void)initialize
{
    if ([self class] == [JDStruct class]) {
        structInfo = @{}.mutableCopy;
    }
}

+ (void)define:(NSDictionary *)structDef name:(NSString *)structName
{
    if (!structDef || structName.length <= 0) return;
    [structInfo setObject:structDef forKey:structName];
}

+ (NSDictionary *)structDefintion:(NSString *)structName
{
    return structInfo[structName];
}

+ (void)setupDefaultStruct
{
    [self define:@{@"def":@[
                                 @{@"type":@"{CGPoint}", @"keyword":@"origin"},
                                 @{@"type":@"{CGSize}", @"keyword":@"size"}
                                 ]}
            name:@"CGRect"];
    
    [self define:@{@"def":
                             @[@{@"type":@"F", @"keyword":@"x"},
                               @{@"type":@"F", @"keyword":@"y"}
                               ]}
            name:@"CGPoint"];
    
    [self define:@{@"def":
                             @[@{@"type":@"F", @"keyword":@"width"},
                               @{@"type":@"F", @"keyword":@"height"}
                               ]}
            name:@"CGSize"];
}

@end
