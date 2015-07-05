//
//  NSURL+Devise.m
//  Devise
//
//  Copyright (c) 2014 Netguru Sp. z o.o. All rights reserved.
//

#import "NSURL+Devise+Private.h"

@implementation NSURL (Devise)

- (BOOL)dvs_hasValidSyntax {
    return (self.scheme && self.host);
}

@end
