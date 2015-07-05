//
//  DVSFieldsUtils+Private.m
//  Devise
//
//  Created by Wojciech Trzasko on 30.12.2014.
//  Copyright (c) 2014 Netguru Sp. z o.o. All rights reserved.
//

#import "DVSFieldsUtils+Private.h"

@implementation DVSFieldsUtils

+ (BOOL)shouldShow:(NSUInteger)option basedOn:(NSUInteger)value {
    return (value & option) == option;
}

@end
