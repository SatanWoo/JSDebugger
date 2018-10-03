//
//  JDLog.h
//  JSDebugger
//
//  Created by z on 2018/9/21.
//  Copyright © 2018年 SatanWoo. All rights reserved.
//

#ifndef JDLog_h
#define JDLog_h

#ifdef DEBUG

#define JDLog(FORMAT, ...) fprintf(stderr,"time:%s line:%d filename:%s\tmethod:%s\n%s\n", __TIME__,__LINE__,[[[NSString stringWithUTF8String:__FILE__] lastPathComponent] UTF8String],__func__, [[NSString stringWithFormat:FORMAT, ##__VA_ARGS__] UTF8String])
#else

#define JDLog(FORMAT, ...) nil

#endif

#endif /* JDLog_h */
