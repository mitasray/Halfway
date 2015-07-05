//
//  NSObject+Devise+Private.h
//  Devise
//
//  Created by Patryk Kaczmarek on 15.12.2014.
//  Copyright (c) 2014 Netguru Sp. z o.o. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSObject (Devise)

- (NSArray *)dvs_properties;
- (Class)dvs_classOfPropertyNamed:(NSString *)propertyName;

@end
