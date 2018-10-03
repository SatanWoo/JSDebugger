//
//  JDFunctionPlugin.h
//  JSDebugger
//
//  Created by z on 2018/9/21.
//  Copyright © 2018年 SatanWoo. All rights reserved.
//

#import <JavaScriptCore/JavaScriptCore.h>

#define JD_REGISTER_PLUGIN(IMP, NAME) \
FOUNDATION_EXTERN void JDRegisterPlugin(Class pluginClass); \
+ (void)load {JDRegisterPlugin(self);} \
- (NSString *)key {return @NAME;} \
- (JSObjectCallAsFunctionCallback)function {return IMP;}

NS_ASSUME_NONNULL_BEGIN

@protocol JDFunctionPlugin <NSObject>

@required
- (JSObjectCallAsFunctionCallback)function;
- (NSString *)key;

@end

@interface JDFunctionPluginManager : NSObject

+ (JDFunctionPluginManager *)pluginManager;

- (void)addPlugin:(id<JDFunctionPlugin>)plugin;
- (void)registerPluginsIntoContext:(JSContextRef)ctx;

@end

NS_ASSUME_NONNULL_END
