//
//  JDEngine.m
//  JSDebugger
//
//  Created by z on 2018/9/20.
//  Copyright © 2018年 SatanWoo. All rights reserved.
//

#import "JDEngine.h"
#import "JDEnginePrivate.h"
#import "JDStruct.h"
#import "JDClass4JS.h"
#import "JDNSStringFromJSString.h"
#import "JDFunctionPlugin.h"
#import "JDLog.h"

static JSValueRef JDGlobalGetProperty(JSContextRef ctx, JSObjectRef object,
                                      JSStringRef propertyName, JSValueRef *exception)
{
    NSString *className = JDCreateNSStringFromJSString(ctx, propertyName);
    Class cls = NSClassFromString(className);
    if (!cls) return NULL; // @important: to search in the super chain
    
    return JSObjectMake(ctx, JDClass4JS(), (__bridge void *)cls);
}

@interface JDEngine()
@property (nonatomic) JSClassRef globalObject;
@property (nonatomic) JSGlobalContextRef ctxRef;
@end

@implementation JDEngine

+ (JDEngine *)engine
{
    static dispatch_once_t onceToken;
    static JDEngine *_engine;
    dispatch_once(&onceToken, ^{
        _engine = [[JDEngine alloc] init];
    });
    return _engine;
}

#pragma mark - Private
- (instancetype)init
{
    self = [super init];
    if (self) {
        JSClassDefinition globalDefinition;
        
        globalDefinition = kJSClassDefinitionEmpty;
        globalDefinition.className = "JDGlobal";
        globalDefinition.getProperty = &JDGlobalGetProperty;
        
        _globalObject = JSClassCreate(&globalDefinition);
        _ctxRef = JSGlobalContextCreate(_globalObject);
        
        _context = [JSContext contextWithJSGlobalContextRef:_ctxRef];
    }
    return self;
}

- (void)dealloc
{
    JSGlobalContextRelease(_ctxRef);
    _ctxRef = NULL;
    
    JSClassRelease(_globalObject);
    _globalObject = NULL;
}

- (void)start
{
    [[JDFunctionPluginManager pluginManager] registerPluginsIntoContext:_ctxRef];
    
    [JDStruct setupDefaultStruct];
    
    [self.context setExceptionHandler:^(JSContext *context, JSValue *exception){
        JDLog(@"exception is %@", exception);
    }];
}

#pragma mark - Public API
- (void)evaluateScript:(NSString *)scriptContent
{
    if (scriptContent.length <= 0) return;
    [self.context evaluateScript:scriptContent];
}

- (void)evaluateScriptAtPath:(NSString *)path
{
    if (path.length <= 0) return;
    
    BOOL isDir = NO;
    BOOL isExist = [[NSFileManager defaultManager] fileExistsAtPath:path isDirectory:&isDir];
    
    if (!isExist || isDir) return;
    
    NSString *content = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:nil];
    [self evaluateScript:content];
}

@end
