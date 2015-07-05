//
//  NSObject+Devise.m
//  Devise
//
//  Created by Patryk Kaczmarek on 15.12.2014.
//  Copyright (c) 2014 Netguru Sp. z o.o. All rights reserved.
//

#import "NSObject+Devise+Private.h"
#import <objc/runtime.h>

@implementation NSObject (Devise)

- (NSArray *)dvs_runtimePropertiesOfClass:(Class)aClass {
    
    uint count;
    objc_property_t *properties = class_copyPropertyList(aClass, &count);
    NSMutableArray *propertyArray = [NSMutableArray arrayWithCapacity:count];
    
    for (uint i = 0; i < count ; i++) {
        const char *propertyName = property_getName(properties[i]);
        [propertyArray addObject:[NSString stringWithCString:propertyName encoding:NSUTF8StringEncoding]];
    }
    free(properties);
    return propertyArray;
}

- (NSArray *)dvs_propertiesOfClass:(Class)aClass {
    
    NSMutableArray *array = [[self dvs_runtimePropertiesOfClass:aClass] mutableCopy];
    
    if (aClass.superclass != [NSObject class]) {
        [array addObjectsFromArray:[self dvs_propertiesOfClass:aClass.superclass]];
    }
    return [array copy];
}

- (NSArray *)dvs_properties {
    return [self dvs_propertiesOfClass:[self class]];
}

- (Class)dvs_classOfPropertyNamed:(NSString *)propertyName {

    Class propertyClass = nil;
    objc_property_t property = class_getProperty([self class], [propertyName UTF8String]);
    NSString *propertyAttributes = [NSString stringWithCString:property_getAttributes(property) encoding:NSUTF8StringEncoding];
    NSArray *splitPropertyAttributes = [propertyAttributes componentsSeparatedByString:@","];
    if (splitPropertyAttributes.count > 0) {
        NSString *encodeType = splitPropertyAttributes[0];
        NSArray *splitEncodeType = [encodeType componentsSeparatedByString:@"\""];
        NSString *className = splitEncodeType[1];
        propertyClass = NSClassFromString(className);
    }
    return propertyClass;
}

@end
