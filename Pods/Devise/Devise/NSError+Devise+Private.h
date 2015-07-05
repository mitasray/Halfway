//
//  NSError+Devise.h
//  Devise
//
//  Created by Patryk Kaczmarek on 05.03.2015.
//  Copyright (c) 2015 Netguru Sp. z o.o. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSError (Devise)

- (instancetype)investigateErrorForKey:(NSString *)key;

@end
