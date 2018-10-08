//
//  TestAssociateObject.h
//  JSDebuggerDemo
//
//  Created by z on 2018/10/8.
//  Copyright © 2018年 SatanWoo. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TestAssociateObject : NSObject

@end

@interface TestAssociateObject(Associate)
@property (nonatomic) NSInteger associateInt;
@end
