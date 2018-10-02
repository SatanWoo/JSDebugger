//
//  JDStruct.h
//  JSDebugger
//
//  Created by z on 2018/9/22.
//  Copyright © 2018年 SatanWoo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <JavaScriptCore/JavaScriptCore.h>


FOUNDATION_EXTERN NSString *JDGetStructName(const char *c);

@interface JDStruct : NSObject

+ (void)define:(NSDictionary *)structDef name:(NSString *)structName;
+ (NSDictionary *)structDefintion:(NSString *)structName;

+ (void)setupDefaultStruct;

@end
