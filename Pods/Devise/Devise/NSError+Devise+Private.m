//
//  NSError+Devise.m
//  Devise
//
//  Created by Patryk Kaczmarek on 05.03.2015.
//  Copyright (c) 2015 Netguru Sp. z o.o. All rights reserved.
//

#import "NSError+Devise+Private.h"

@implementation NSError (Devise)

- (instancetype)investigateErrorForKey:(NSString *)key {
    
    NSData *data = self.userInfo[key];
    if (data && [data isKindOfClass:[NSData class]]) {
        
        NSError *error;
        NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
        NSString *value;
        
        if ([json[@"error"] isKindOfClass:[NSString class]]) {
            value = json[@"error"];
        } else {
            value = json[@"error"][@"message"];
        };
        
        if (!error && value) {
            [self swizzleUserInfoDictionaryByReplacingValueForKey:NSLocalizedDescriptionKey withValue:value];
        }
    }
    return self;
}

- (void)swizzleUserInfoDictionaryByReplacingValueForKey:(NSString *)key withValue:(NSString *)value {
    
    NSMutableDictionary *dictionary = [self.userInfo mutableCopy];
    dictionary[key] = value;
    [self setValue:[dictionary copy] forKey:@"userInfo"];
}

@end
