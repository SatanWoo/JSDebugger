//
//  JDProperty.m
//  JSDebugger
//
//  Created by z on 2018/9/23.
//  Copyright © 2018年 SatanWoo. All rights reserved.
//

#import "JDProperty.h"

@interface JDProperty()
@property (nonatomic, readwrite) BOOL readonly;
@property (nonatomic, readwrite) JDEncoding encoding;
@property (nonatomic, copy, readwrite) NSString *setterName;
@property (nonatomic, copy, readwrite) NSString *getterName;
@property (nonatomic, copy, readwrite) NSString *propertyName;
@end

@implementation JDProperty

- (instancetype)initWithProperty:(objc_property_t)property
{
    if (!property) return nil;
    const char *name = property_getName(property);
    
    if (!name) return nil;

    self = [super init];
    if (self) {
        _propertyName = [NSString stringWithUTF8String:name];
        _getterName = _propertyName.copy;
        _setterName = [NSString stringWithFormat:@"set%@%@:",
                       [_propertyName substringToIndex:1].uppercaseString,
                       [_propertyName substringFromIndex:1]];
        
        [self buildProperty:property];
    }
    return self;
}

- (void)buildProperty:(objc_property_t)property
{
    unsigned int attrCount;
    objc_property_attribute_t *attrs = property_copyAttributeList(property, &attrCount);
    for (unsigned int i = 0; i < attrCount; i++) {
        switch (attrs[i].name[0]) {
            case 'T': { // Type encoding
                if (attrs[i].value) {
                    self.encoding = JDGetEncoding(attrs[i].value);
                }
                break;
            }
                
            case 'R': {
                self.readonly = YES;
                break;
            }
                
            case 'G': {
                if (attrs[i].value) {
                    self.getterName = [NSString stringWithUTF8String:attrs[i].value];
                }
                break;
            }
                
            case 'S': {
                if (attrs[i].value) {
                    self.setterName = [NSString stringWithUTF8String:attrs[i].value];
                }
                break;
            }
                
            default: break;
        }
    }
    
    if (attrs) {
        free(attrs);
        attrs = NULL;
    }
}

- (NSString *)description
{
    return [NSString stringWithFormat:@"%@ - %@ - %@ - %d", self.propertyName, self.setterName, self.getterName, self.readonly];
}
@end

#pragma mark - JDPropertiesInClass

@interface JDPropertiesInClass()
@property (nonatomic, strong) NSArray<JDProperty *> *properties;
@end

@implementation JDPropertiesInClass

- (instancetype)initWithClass:(Class)cls
{
    if (!cls) return nil;
    
    self = [super init];
    if (self) {
        NSMutableArray *temp = @[].mutableCopy;
        
        unsigned int propertyCount = 0;
        objc_property_t *properties = class_copyPropertyList(cls, &propertyCount);
        if (properties) {
            for (unsigned int i = 0; i < propertyCount; i++) {
                JDProperty *property = [[JDProperty alloc] initWithProperty:properties[i]];
                if (property) [temp addObject:property];
            }
            free(properties);
        }
        _properties = temp.copy;
    }

    return self;
}

- (NSString *)description
{
    NSMutableString *descr = [[NSMutableString alloc] init];
    
    for (JDProperty *property in self.properties) {
        [descr appendString:[property description]];
        [descr appendString:@"\n"];
    }
    return descr.copy;
}

@end
