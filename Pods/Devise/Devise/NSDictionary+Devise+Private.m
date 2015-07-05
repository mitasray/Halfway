//
//  NSDictionary+Devise+Private.m
//  Devise
//
//  Created by Patryk Kaczmarek on 08.12.2014.
//  Copyright (c) 2014 Netguru Sp. z o.o. All rights reserved.
//

#import "NSDictionary+Devise+Private.h"

@implementation NSDictionary (Devise)

- (NSString *)dvs_stringValueForKey:(id)key {
    id obj = [self objectForKey:key];
    
    if ([obj isKindOfClass:[NSString class]]) {
        return obj;
    } else if ([obj isKindOfClass:[NSNumber class]]) {
        return [obj stringValue];
    } else {
        return [obj description];
    }
}

@end
