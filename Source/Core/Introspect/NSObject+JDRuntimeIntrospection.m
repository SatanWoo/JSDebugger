//
//  NSObject+JDRuntimeIntrospection.m
//  JSDebugger
//
//  Created by JunyiXie on 2/10/2018.
//

#import "NSObject+JDRuntimeIntrospection.h"
#import <objc/runtime.h>
#import "JDEncoding.h"

@implementation NSObject (JDRuntimeIntrospection)

- (NSArray *)logAllProperties
{
  NSMutableArray *result = @[].mutableCopy;
  unsigned int count;
  Ivar *ivars = class_copyIvarList([self class], &count);
  for (unsigned int i = 0; i < count; i++) {
    Ivar ivar = ivars[i];
    
    const char *name = ivar_getName(ivar);
    const char *type = ivar_getTypeEncoding(ivar);
    ptrdiff_t offset = ivar_getOffset(ivar);
    
    if (strncmp(type, @encode(char), 1) == 0) {
      char value = *(char *)((uintptr_t)self + offset);
      [result addObject: [NSString stringWithFormat:@"%s = %c", name, value]];
    }
    else if (strncmp(type, @encode(int), 1) == 0) {
      int value = *(int *)((uintptr_t)self + offset);
      [result addObject: [NSString stringWithFormat:@"%s = %d", name, value]];
    }
    else if (strncmp(type, @encode(short), 1) == 0) {
      short value = *(short *)((uintptr_t)self + offset);
      [result addObject: [NSString stringWithFormat:@"%s = %hd", name, value]];
    }
    else if (strncmp(type, @encode(long), 1) == 0) {
      long value = *(long *)((uintptr_t)self + offset);
      [result addObject: [NSString stringWithFormat:@"%s = %ld", name, value]];
    }
    else if (strncmp(type, @encode(long long), 1) == 0) {
      long long value = *(long long *)((uintptr_t)self + offset);
      [result addObject: [NSString stringWithFormat:@"%s = %lld", name, value]];
    }
    else if (strncmp(type, @encode(unsigned char), 1) == 0) {
      unsigned char value = *(unsigned char *)((uintptr_t)self + offset);
      [result addObject: [NSString stringWithFormat:@"%s = %c", name, value]];
    }
    else if (strncmp(type, @encode(unsigned int), 1) == 0) {
      unsigned int value = *(unsigned int *)((uintptr_t)self + offset);
      [result addObject: [NSString stringWithFormat:@"%s = %u", name, value]];
    }
    else if (strncmp(type, @encode(unsigned short), 1) == 0) {
      unsigned short value = *(unsigned short *)((uintptr_t)self + offset);
      [result addObject: [NSString stringWithFormat:@"%s = %hu", name, value]];
    }
    else if (strncmp(type, @encode(unsigned long), 1) == 0) {
      unsigned long value = *(unsigned long *)((uintptr_t)self + offset);
      [result addObject: [NSString stringWithFormat:@"%s = %lu", name, value]];
    }
    else if (strncmp(type, @encode(unsigned long long), 1) == 0) {
      unsigned long long value = *(unsigned long long *)((uintptr_t)self + offset);
      [result addObject: [NSString stringWithFormat:@"%s = %llu", name, value]];
    }
    else if (strncmp(type, @encode(float), 1) == 0) {
      float value = *(float *)((uintptr_t)self + offset);
      [result addObject: [NSString stringWithFormat:@"%s = %f", name, value]];
    }
    else if (strncmp(type, @encode(double), 1) == 0) {
      double value = *(double *)((uintptr_t)self + offset);
      [result addObject: [NSString stringWithFormat:@"%s = %e", name, value]];
    }
    else if (strncmp(type, @encode(bool), 1) == 0) {
      bool value = *(bool *)((uintptr_t)self + offset);
      [result addObject: [NSString stringWithFormat:@"%s = %d", name, value]];
    }
    else if (strncmp(type, @encode(char *), 1) == 0) {
      char * value = *(char * *)((uintptr_t)self + offset);
      [result addObject: [NSString stringWithFormat:@"%s = %s", name, value]];
    }
    else if (strncmp(type, @encode(id), 1) == 0) {
      id value = object_getIvar(self, ivar);
      [result addObject: [NSString stringWithFormat:@"%s = %@", name, value]];
    }
    else if (strncmp(type, @encode(Class), 1) == 0) {
      id value = object_getIvar(self, ivar);
      [result addObject: [NSString stringWithFormat:@"%s = %@", name, value]];
    }
    // todo
    // SEL
    // struct
    // array
    // union
    // bit
    // field of num bits
    // pointer to type
  }
  free(ivars);
  return [result copy];
}

@end



