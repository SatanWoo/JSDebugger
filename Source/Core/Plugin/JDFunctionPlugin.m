//
//  JDFunctionPlugin.m
//  JSDebugger
//
//  Created by z on 2018/9/21.
//  Copyright © 2018年 SatanWoo. All rights reserved.
//

#import "JDFunctionPlugin.h"

void JDRegisterPlugin(Class pluginClass)
{
    [[JDFunctionPluginManager pluginManager] addPlugin:[[pluginClass alloc] init]];
}

@interface JDFunctionPluginManager()

@property (nonatomic, strong) NSMutableArray *plugins;

@end

@implementation JDFunctionPluginManager

+ (JDFunctionPluginManager *)pluginManager
{
    static dispatch_once_t onceToken;
    static JDFunctionPluginManager *_pluginManager;
    dispatch_once(&onceToken, ^{
        _pluginManager = [[JDFunctionPluginManager alloc] init];
    });
    return _pluginManager;
}

- (void)addPlugin:(id<JDFunctionPlugin>)plugin
{
    NSParameterAssert(plugin);
    if (!plugin)  { return; }
    if (![plugin conformsToProtocol:NSProtocolFromString(@"JDFunctionPlugin")])  { return; }
    
    [self.plugins addObject:plugin];
}

- (void)registerPluginsIntoContext:(JSContextRef)ctx
{
    NSCParameterAssert(ctx);
    if (ctx == NULL) {
        return;
    }
    
    JSObjectRef global = JSContextGetGlobalObject(ctx);
    
    for (id<JDFunctionPlugin> plugin in self.plugins) {
        if ([plugin respondsToSelector:@selector(function)] &&
            [plugin respondsToSelector:@selector(key)]) {
            
            JSStringRef functionJSName = JSStringCreateWithUTF8CString([plugin key].UTF8String);
            JSObjectSetProperty(ctx,
                                global,
                                functionJSName,
                                JSObjectMakeFunctionWithCallback(ctx, functionJSName, [plugin function]),
                                kJSPropertyAttributeDontEnum | kJSPropertyAttributeDontDelete, NULL);
            JSStringRelease(functionJSName);
        }
    }
}

#pragma mark - Getter
- (NSMutableArray *)plugins
{
    if (!_plugins) {
        _plugins = @[].mutableCopy;
    }
    return _plugins;
}

@end
