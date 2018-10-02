//
//  JDMethodBridge.m
//  JSDebugger
//
//  Created by z on 2018/9/21.
//  Copyright © 2018年 SatanWoo. All rights reserved.
//

#import "JDMethodBridge.h"
#import "JDEncoding.h"
#import "JDStruct.h"

@implementation JDParameter
@end

#pragma mark - JDMethodBridge

@interface JDMethodBridge()

@property (nonatomic, readwrite, strong) JDParameter *returnType;
@property (nonatomic, readwrite, copy) NSArray<JDParameter *> *argumentsType;
@property (nonatomic, readwrite, weak) id instance;
@property (nonatomic, readwrite) IMP imp;
@property (nonatomic, readwrite) SEL selector;

@end

@implementation JDMethodBridge

- (instancetype)initWithSignature:(NSMethodSignature *)signature selector:(SEL)selector instace:(id)ins imp:(IMP)imp
{
    NSAssert(signature, @"[JSDebugger]::JDMethodBridge Cannot Be Initialized With NULL Signature Parameter");
    
    self = [super init];
    if (self) {
        _instance = ins;
        _imp = imp;
        _selector = selector;
        [self buildEncoding:signature];
    }
    return self;
}

#pragma mark - Private
- (void)buildEncoding:(NSMethodSignature *)signature
{
    NSUInteger numberOfArguments = signature.numberOfArguments;
    NSMutableArray *argumentsList = [[NSMutableArray alloc] init];
    
    for (NSUInteger i = 0; i < numberOfArguments; i++) {
        @autoreleasepool {
            const char *argumentType = [signature getArgumentTypeAtIndex:i];
            JDEncoding encoding = JDGetEncoding(argumentType);
            
            JDParameter *p = [JDParameter new];
            if (encoding == JDEncodingStruct) {
                NSString *structName = JDGetStructName(argumentType);
                p.paramterName = structName;
            }
            
            p.encoding = encoding;
            [argumentsList addObject:p];
        }
    }
    
    self.argumentsType = argumentsList.copy;
    
    const char *returnType = [signature methodReturnType];
    JDEncoding returnEncoding = JDGetEncoding(returnType);
    JDParameter *returnP = [JDParameter new];
    returnP.encoding = returnEncoding;
    
    if (returnEncoding == JDEncodingStruct) {
        returnP.paramterName = JDGetStructName(returnType);
    }
    
    self.returnType = returnP;
}


@end
