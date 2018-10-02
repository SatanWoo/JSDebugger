//
//  JDMethodBridge.h
//  JSDebugger
//
//  Created by z on 2018/9/21.
//  Copyright © 2018年 SatanWoo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JDEncoding.h"

@interface JDParameter : NSObject
@property (nonatomic) JDEncoding encoding;
@property (nonatomic) NSString *paramterName;

@end

@interface JDMethodBridge : NSObject

@property (nonatomic, readonly, strong) JDParameter *returnType;
@property (nonatomic, readonly, copy) NSArray<JDParameter *> *argumentsType;
@property (nonatomic, readonly, weak) id instance;
@property (nonatomic, readonly) SEL selector;
@property (nonatomic, readonly) IMP imp;

- (instancetype)init NS_UNAVAILABLE;

- (instancetype)initWithSignature:(NSMethodSignature *)signature
                         selector:(SEL)selector
                          instace:(id)ins
                              imp:(IMP)imp;

@end
