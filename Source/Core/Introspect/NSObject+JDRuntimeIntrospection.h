//
//  NSObject+JDRuntimeIntrospection.h
//  JSDebugger
//
//  Created by JunyiXie on 2/10/2018.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSObject (JDRuntimeIntrospection)

- (NSArray<NSString *> *)jd_logAllProperties;

@end

NS_ASSUME_NONNULL_END
