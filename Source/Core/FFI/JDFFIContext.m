//
//  JDFFIContext.m
//  JSDebugger
//
//  Created by z on 2018/9/21.
//  Copyright © 2018年 SatanWoo. All rights reserved.
//

#import "JDFFIContext.h"
#import "JDEncoding.h"
#import "JDClass4JS.h"
#import "JDInstance4JS.h"
#import "JDMethod4JS.h"
#import "JDMethodBridge.h"
#import "JDJSTypeToOCType.h"
#import "JDStruct.h"
#import "JDNSStringFromJSString.h"
#import "NSDictionary+JSConvert.h"
#import "ffi.h"
@import ObjectiveC.runtime;

static ffi_type *JDConvertEncodingToFFI(JDEncoding encoding)
{
    switch (encoding) {
        case JDEncodingVoid:
            return &ffi_type_void;
        case JDEncodingBool:
            return &ffi_type_uint8;
        case JDEncodingInt8:
            return &ffi_type_sint8;
        case JDEncodingUInt8:
            return &ffi_type_uint8;
        case JDEncodingInt16:
            return &ffi_type_sint16;
        case JDEncodingUInt16:
            return &ffi_type_uint16;
        case JDEncodingInt32:
            return &ffi_type_sint32;
        case JDEncodingUInt32:
            return &ffi_type_uint32;
        case JDEncodingInt64:
            return &ffi_type_sint64;
        case JDEncodingUInt64:
            return &ffi_type_uint64;
        case JDEncodingFloat:
            return &ffi_type_float;
        case JDEncodingDouble:
        case JDEncodingLongDouble:
            return &ffi_type_double;
        case JDEncodingClass:
        case JDEncodingSEL:
        case JDEncodingBlock:
        case JDEncodingObject:
        case JDEncodingCString:
        case JDEncodingPointer:
            return &ffi_type_pointer;
        default:
            return NULL;
    }
}

static ffi_type *JDConvertStructToFFI(NSString *structName)
{
    NSDictionary *info = [JDStruct structDefintion:structName];
    if (!info) { return NULL; }
    
    NSArray *defs = info[@"def"];
    if (!defs || ![defs isKindOfClass:[NSArray class]]) return NULL;
    
    ffi_type *type = malloc(sizeof(ffi_type));
    type->alignment = 0;
    type->size = 0;
    type->type = FFI_TYPE_STRUCT;
    
    NSUInteger subTypeCount = defs.count;
    ffi_type **sub_types = malloc(sizeof(ffi_type *) * (subTypeCount + 1));
    for (NSUInteger i=0; i<subTypeCount; i++) {
        NSDictionary *defType = defs[i];
        NSString *typeName = defType[@"type"];
        
        if ([typeName containsString:@"{"] && [typeName containsString:@"}"]) {
            // struct
            typeName = [typeName stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"{}"]];
            sub_types[i] = JDConvertStructToFFI(typeName);
        } else {
            sub_types[i] = JDConvertEncodingToFFI(JDGetEncoding([typeName cStringUsingEncoding:NSASCIIStringEncoding]));
        }
        
        type->size += sub_types[i]->size;
    }
    
    sub_types[subTypeCount] = NULL;
    type->elements = sub_types;
    return type;
}

static void JDSetJSValueToAddress(JDEncoding encoding, JSContextRef ctx,  JSValueRef value, void *dst)
{
    
#define JDSetFallBackToNULL \
        *(void **)dst = (__bridge void *)[NSNull null];
    
    if (JSValueIsNull(ctx, value)) {
        JDSetFallBackToNULL;
    } else if (JSValueIsNumber(ctx, value)) {
        double val = JSValueToNumber(ctx, value, NULL);
        if (encoding == JDEncodingFloat) {
            *(float *)dst = (float)val;
        } else if (encoding == JDEncodingDouble || encoding == JDEncodingLongDouble) {
            *(double *)dst = (double)val;
        } else if (encoding == JDEncodingInt8) {
            *(int8_t *)dst = (int8_t)val;
        } else if (encoding == JDEncodingUInt8) {
            *(uint8_t *)dst = (uint8_t)val;
        } else if (encoding == JDEncodingInt16) {
            *(int16_t *)dst = (int16_t)val;
        } else if (encoding == JDEncodingUInt16) {
            *(uint16_t *)dst = (uint16_t)val;
        } else if (encoding == JDEncodingInt32) {
            *(int32_t *)dst = (int32_t)val;
        } else if (encoding == JDEncodingUInt32) {
            *(uint32_t *)dst = (uint32_t)val;
        } else if (encoding == JDEncodingInt64) {
            *(int64_t *)dst = (int64_t)val;
        } else if (encoding == JDEncodingUInt64) {
            *(uint64_t *)dst = (uint64_t)val;
        } else if (encoding == JDEncodingObject) {
            NSNumber *number = JDConvertJSValueToNSObject(ctx, value);
            if (number) {
                *(void **)dst = (__bridge_retained void*)number;
            } else {
                JDSetFallBackToNULL;
            }
        }
    } else if (JSValueIsDate(ctx, value)) {
        NSDate *date = JDConvertJSValueToNSObject(ctx, value);
        if (date) {
            *(void **)dst = (__bridge_retained void *)date;
        } else {
            JDSetFallBackToNULL;
        }
    } else if (JSValueIsString(ctx, value)) {
        NSString *str = JDConvertJSValueToNSObject(ctx, value);
        if (str) {
            *(void **)dst = (__bridge_retained void*)str;
        } else {
            JDSetFallBackToNULL;
        }
        
    } else if (JSValueIsArray(ctx, value)) {
        NSArray *array = JDConvertJSValueToNSObject(ctx, value);
        if (array) {
            *(void **)dst = (__bridge_retained void*)array;
        } else {
            JDSetFallBackToNULL;
        }
        
    } else if (JSValueIsObject(ctx, value)) {
        // @SatanWoo: Check Our Own Wrapper Object
        if (JSValueIsObjectOfClass(ctx, value, JDClass4JS())) {
            Class cls = (__bridge Class)(JSObjectGetPrivate((JSObjectRef)value));
            *(Class *)dst = cls;
        } else if (JSValueIsObjectOfClass(ctx, value, JDInstance4JS())) {
            id instance = (__bridge id)JSObjectGetPrivate((JSObjectRef)value);
            *(void **)dst = (__bridge void *)instance;
        } else if (JSValueIsObjectOfClass(ctx, value, JDMethod4JS())) {
            SEL sel = (SEL)JSObjectGetPrivate((JSObjectRef)value);
            *(SEL *)dst = sel;
        } else {
            // plain object
            NSDictionary *dict = JDConvertJSValueToNSObject(ctx, value);
            if (!dict) {
                JDSetFallBackToNULL;
                return;
            }
            
            BOOL ret = [dict jd_canConvertToRect];
            if (ret) {
                CGRect rect = [dict jd_rectValue];
                *(CGFloat *)dst = rect.origin.x;
                *(CGFloat *)((uintptr_t)dst + sizeof(CGFloat)) = rect.origin.y;
                *(CGFloat *)((uintptr_t)dst + 2 * sizeof(CGFloat)) = rect.size.width;
                *(CGFloat *)((uintptr_t)dst + 3 * sizeof(CGFloat)) = rect.size.height;
                return;
            }
            
            ret = [dict jd_canConvertToPoint];
            if (ret) {
                CGPoint point = [dict jd_pointValue];
                *(CGFloat *)dst = point.x;
                *(CGFloat *)((uintptr_t)dst + sizeof(CGFloat)) = point.y;
                return;
            }
            
            ret = [dict jd_canConvertToSize];
            if (ret) {
                CGSize size = [dict jd_sizeValue];
                *(CGFloat *)dst = size.width;
                *(CGFloat *)((uintptr_t)dst + sizeof(CGFloat)) = size.height;
                return;
            }
            
            *(void **)dst = (__bridge_retained void*)[dict copy];
        }
    }
}

static NSDictionary *JDBuildDictFromStruct(NSString *structName, void *src)
{
    NSDictionary *defintion = [JDStruct structDefintion:structName];
    if (!defintion) return nil;
    
    NSMutableDictionary *result = @{}.mutableCopy;
    size_t offset = 0;
    
    for (NSDictionary *info in defintion[@"def"]) {
        @autoreleasepool {
            NSString *keyword = info[@"keyword"];
            NSString *type = info[@"type"];
            JDEncoding encoding = JDGetEncoding(type.UTF8String);
            if (encoding == JDEncodingStruct) {
                NSDictionary *subResult = JDBuildDictFromStruct([type stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"{}"]], src + offset);
                if (subResult) {
                    [result setObject:subResult forKey:keyword];
                }
                offset += JDSizeOfEncoding(encoding, [type stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"{}"]]);
            } else {
                size_t size = JDSizeOfEncoding(encoding, nil);
                void *temp = malloc(sizeof(size));
                memcpy(temp, src + offset, size);
                
                if (encoding == JDEncodingCString || encoding == JDEncodingPointer) {
                    NSValue *v = [NSValue valueWithBytes:temp objCType:""];
                    [result setObject:v forKey:keyword];
                    offset += sizeof(void *);
                } else {
                    
#define JDSetValueToDict(encoding, cast) \
case encoding: \
{\
num = @(*(cast *)temp); \
offset += sizeof(cast); \
break;\
} \

                    NSNumber *num;
                    switch (encoding) {
                            JDSetValueToDict(JDEncodingInt8, int8_t);
                            JDSetValueToDict(JDEncodingUInt8, uint8_t);
                            JDSetValueToDict(JDEncodingInt16, int16_t);
                            JDSetValueToDict(JDEncodingUInt16, uint16_t);
                            JDSetValueToDict(JDEncodingInt32, int32_t);
                            JDSetValueToDict(JDEncodingUInt32, uint32_t);
                            JDSetValueToDict(JDEncodingInt64, int64_t);
                            JDSetValueToDict(JDEncodingUInt64, uint64_t);
                            JDSetValueToDict(JDEncodingFloat, float);
                            JDSetValueToDict(JDEncodingDouble, double);
                            JDSetValueToDict(JDEncodingLongDouble, double);
                        default:
                            break;
                    }
                    
                    if (!num) assert(false);
                    [result setObject:num forKey:keyword];
                }
                free(temp);
            }
        }
    }
    
    return result;
}

static JSValueRef JDFillStructFromAddress(JSContextRef ctx, NSString *structName, void *src)
{
    NSDictionary *result = JDBuildDictFromStruct(structName, src);
    if (!result) return JSValueMakeUndefined(ctx);
    
    NSData *data = [NSJSONSerialization dataWithJSONObject:result options:NSJSONWritingPrettyPrinted error:nil];
    NSString *string = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    JSStringRef stringRef = JSStringCreateWithUTF8CString(string.UTF8String);
    JSValueRef value = JSValueMakeFromJSONString(ctx, stringRef);
    JSStringRelease(stringRef);
    return value;
}


static JSValueRef JDFillJSValueFromAddress(JSContextRef ctx, JDParameter *parameter, void *src)
{
    switch (parameter.encoding) {
#define JD_FFI_RETURN_CASE(_typeString, _type)\
case _typeString:{\
_type v = *(_type *)src;\
return JSValueMakeNumber(ctx, v); \
}
            
            JD_FFI_RETURN_CASE(JDEncodingInt8, int8_t);
            JD_FFI_RETURN_CASE(JDEncodingUInt8, uint8_t);
            JD_FFI_RETURN_CASE(JDEncodingInt16, int16_t);
            JD_FFI_RETURN_CASE(JDEncodingUInt16, uint16_t);
            JD_FFI_RETURN_CASE(JDEncodingInt32, int32_t);
            JD_FFI_RETURN_CASE(JDEncodingUInt32, uint32_t);
            JD_FFI_RETURN_CASE(JDEncodingInt64, int64_t);
            JD_FFI_RETURN_CASE(JDEncodingUInt64, uint64_t);
            
        case JDEncodingVoid:
            return JSValueMakeUndefined(ctx);
        case JDEncodingObject:
        {
            id obj = (__bridge id)(*(void**)src);
            if (class_isMetaClass([obj class])) {
                return JSObjectMake(ctx, JDClass4JS(), (__bridge void *)obj);
            } else {
                return JSObjectMake(ctx, JDInstance4JS(), (__bridge void *)obj);
            }
        }
            
        case JDEncodingClass:
        {
            Class obj = *(Class *)src;
            return JSObjectMake(ctx, JDClass4JS(), (__bridge void *)obj);
        }
            
        case JDEncodingSEL:
        {
            SEL sel = *(SEL *)src;
            return JSObjectMake(ctx, JDMethod4JS(), (void *)sel);
        }
        
        case JDEncodingStruct:
        {
            return JDFillStructFromAddress(ctx, parameter.paramterName, src);
        }
            
        case JDEncodingBlock:
            // @SatanWoo:Block Has Not Been Supported Yet
            return JSValueMakeNull(ctx);
        default:
            return JSValueMakeUndefined(ctx);
    }
}

static bool JDFunctionCallPreCheck(JSContextRef ctx, JDMethodBridge *methodBridge, size_t argumentCount, const JSValueRef arguments[])
{
    for (int i = 0; i < argumentCount; i++) {
        JDParameter *p = [methodBridge.argumentsType objectAtIndex:i + 2];
        JSValueRef value = arguments[i];
        
        if (p.encoding != JDEncodingVoid && JSValueIsUndefined(ctx, value)) {
            return false;
        }
    }
    return true;
}

JSValueRef JDCallFunction(JSContextRef ctx, JDMethodBridge *methodBridge,
                          size_t argumentCount, const JSValueRef arguments[])
{
    if (!JDFunctionCallPreCheck(ctx, methodBridge, argumentCount, arguments)) {
        return JSValueMakeUndefined(ctx);
    }
    
    assert(methodBridge.argumentsType.count == argumentCount + 2);
    
    size_t argCount = argumentCount + 2;
    
    ffi_type **ffiArgTypes = alloca(sizeof(ffi_type *) * argCount);
    void **ffiArgs = alloca(sizeof(void *) * argCount);
    
    ffiArgTypes[0] = &ffi_type_pointer;
    
    id instance = methodBridge.instance;
    ffiArgs[0] = &instance;
    
    ffiArgTypes[1] = &ffi_type_pointer;
    SEL selector = methodBridge.selector;
    ffiArgs[1] = &selector;
    
    for (int i = 0; i < argumentCount; i++) {
        @autoreleasepool {
            JDParameter *p = [methodBridge.argumentsType objectAtIndex:i + 2];
            ffi_type *ffiType;
            
            if (p.encoding == JDEncodingStruct) {
                ffiType = JDConvertStructToFFI(p.paramterName);
            } else {
                ffiType = JDConvertEncodingToFFI(p.encoding);
            }
            
            ffiArgTypes[i + 2] = ffiType;
            void *ffiArgPtr = alloca(ffiType->size);
            JDSetJSValueToAddress(p.encoding, ctx, arguments[i], ffiArgPtr);
            ffiArgs[i + 2] = ffiArgPtr;
        }
    }
    
    ffi_type *returnType;
    if (methodBridge.returnType.encoding == JDEncodingStruct) {
        returnType = JDConvertStructToFFI(methodBridge.returnType.paramterName);
    } else {
        returnType = JDConvertEncodingToFFI(methodBridge.returnType.encoding);
    }
    
    ffi_cif cif;
    ffi_status ffiPrepStatus = ffi_prep_cif_var(&cif, FFI_DEFAULT_ABI, (unsigned int)0, (unsigned int)argCount, returnType, ffiArgTypes);
    
    if (ffiPrepStatus == FFI_OK) {
        void *returnPtr = NULL;
        if (returnType->size) {
            returnPtr = alloca(returnType->size);
        }
        ffi_call(&cif, methodBridge.imp, returnPtr, ffiArgs);
        
        if (returnType->size) {
            return JDFillJSValueFromAddress(ctx, methodBridge.returnType, returnPtr);
        } else {
            return JSValueMakeUndefined(ctx);
        }
    }
    
    return JSValueMakeUndefined(ctx);
}
