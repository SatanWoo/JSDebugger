//
//  JDEnginePrivate.h
//  JSDebugger
//
//  Created by z on 2018/9/20.
//  Copyright © 2018年 SatanWoo. All rights reserved.
//

#ifndef JDEnginePrivate_h
#define JDEnginePrivate_h

#import "JDEngine.h"

@import JavaScriptCore;

@interface JDEngine()

@property (nonatomic, strong) JSContext *context;

@end


#endif /* JDEnginePrivate_h */
