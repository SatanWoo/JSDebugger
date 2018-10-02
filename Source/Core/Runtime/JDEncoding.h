//
//  JDEncoding.h
//  JSDebugger
//
//  Created by z on 2018/9/21.
//  Copyright © 2018年 SatanWoo. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSUInteger) {
    JDEncodingVoid = 0,
    JDEncodingBool,
    JDEncodingInt8,
    JDEncodingUInt8,
    JDEncodingInt16,
    JDEncodingUInt16,
    JDEncodingInt32,
    JDEncodingUInt32,
    JDEncodingInt64,
    JDEncodingUInt64,
    JDEncodingFloat,
    JDEncodingDouble,
    JDEncodingLongDouble,
    JDEncodingClass,
    JDEncodingSEL,
    JDEncodingCString,
    JDEncodingPointer,
    JDEncodingCArray,
    JDEncodingUnion,
    JDEncodingStruct,
    JDEncodingBlock,
    JDEncodingObject,
    JDEncodingUnknown
} JDEncoding;

FOUNDATION_EXTERN JDEncoding JDGetEncoding(const char *c);

FOUNDATION_EXTERN size_t JDSizeOfEncoding(JDEncoding encoding, NSString *structName);
