//
//  JDEncoding.m
//  JSDebugger
//
//  Created by z on 2018/9/22.
//  Copyright © 2018年 SatanWoo. All rights reserved.
//

#import "JDEncoding.h"
#import "JDStruct.h"

JDEncoding JDGetEncoding(const char *c)
{
    assert(c);
    
    unsigned long len = strlen(c);
    if (len == 0) return JDEncodingUnknown;
    
    switch (*c) {
        case 'v': return JDEncodingVoid;
        case 'B': return JDEncodingBool;
        case 'c': return JDEncodingInt8;
        case 'C': return JDEncodingUInt8;
        case 's': return JDEncodingInt16;
        case 'S': return JDEncodingUInt16;
        case 'i': return JDEncodingInt32;
        case 'I': return JDEncodingUInt32;
        case 'l': return JDEncodingInt32;
        case 'L': return JDEncodingUInt32;
        case 'q': return JDEncodingInt64;
        case 'Q': return JDEncodingUInt64;
        case 'f': return JDEncodingFloat;
        case 'F':
#if CGFLOAT_IS_DOUBLE
            return JDEncodingDouble;
#else
            return JDEncodingFloat;
#endif
        case 'd': return JDEncodingDouble;
        case 'D': return JDEncodingLongDouble;
        case '#': return JDEncodingClass;
        case ':': return JDEncodingSEL;
        case '*': return JDEncodingCString;
        case '^': return JDEncodingPointer;
        case '[': return JDEncodingCArray;
        case '(': return JDEncodingUnion;
        case '{': return JDEncodingStruct;
        case '@': {
            if (len == 2 && *(c + 1) == '?')
                return JDEncodingBlock;
            else
                return JDEncodingObject;
        }
        default: return JDEncodingUnknown;
    }
}

static size_t JDSizeOfStruct(NSString *structName)
{
    NSDictionary *definition = [JDStruct structDefintion:structName];
    if (!definition) { return 0; }
    
    size_t size = 0;
    
    for (NSDictionary *info in definition[@"def"]) {
        NSString *type = info[@"type"];
        JDEncoding encoding = JDGetEncoding(type.UTF8String);
        if (encoding == JDEncodingStruct) {
            size += JDSizeOfStruct([type stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"{}"]]);
        } else {
            size += JDSizeOfEncoding(encoding, nil);
        }
    }
    
    return size;
}

size_t JDSizeOfEncoding(JDEncoding encoding, NSString *structName)
{
#define JDSize(encoding, type) \
    case encoding: \
    { \
        return sizeof(type);\
    }

    switch (encoding) {
        JDSize(JDEncodingVoid, void);
        JDSize(JDEncodingInt8, int8_t);
        JDSize(JDEncodingUInt8, uint8_t);
        JDSize(JDEncodingInt16, int16_t);
        JDSize(JDEncodingUInt16, uint16_t);
        JDSize(JDEncodingInt32, int32_t);
        JDSize(JDEncodingUInt32, uint32_t);
        JDSize(JDEncodingInt64, int64_t);
        JDSize(JDEncodingUInt64, uint64_t);
        JDSize(JDEncodingBool, bool);
        JDSize(JDEncodingFloat, float);
        JDSize(JDEncodingDouble, double);
        JDSize(JDEncodingLongDouble, long double);
        JDSize(JDEncodingCString, char *);
        JDSize(JDEncodingPointer, void *);
        JDSize(JDEncodingObject, void *);
        JDSize(JDEncodingSEL, void *);
        JDSize(JDEncodingClass, void *);
            
        case JDEncodingStruct:
        {
            return JDSizeOfStruct(structName);
        }
        default:
            // @SatanWoo: C Struct cannot hold other types
            assert(false);
            return 0;
    }
}
