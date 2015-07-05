//
//  DVSLoginViewUserDataSource+Private.m
//  Devise
//
//  Created by Wojciech Trzasko on 22.12.2014.
//  Copyright (c) 2014 Netguru Sp. z o.o. All rights reserved.
//

#import "DVSTemplatesViewsUserDelegate+Private.h"
#import "NGRValidator.h"

static NSString * const DVSUserPasswordParameter = @"password";
static NSString * const DVSUserEmailParameter = @"email";

static NSUInteger const DVSUserPasswordMinLength = 5;

@implementation DVSTemplatesViewsUserDelegate

#pragma mark - Validation for actions

- (void)userManager:(DVSUserManager *)manager didPrepareValidationRules:(NSMutableArray *)validationRules forAction:(DVSActionType)action {

    for (NGRPropertyValidator *validator in validationRules) {
        if ([validator.property isEqualToString:DVSUserEmailParameter]) {
            validator.localizedName(@"E-mail");
            
        } else if ([validator.property isEqualToString:DVSUserPasswordParameter]) {
            validator.minLength(DVSUserPasswordMinLength);
            
            switch (action) {
                case DVSActionLogin: {
                    validator.msgTooShort(NSLocalizedString(@"is wrong.", nil));
                    break;
                }
                case DVSActionRegistration: {
                    NSString *message = [NSString stringWithFormat:NSLocalizedString(@"should have at least %ld characters.", nil),  (unsigned long)DVSUserPasswordMinLength];
                    validator.msgTooShort(message);
                    break;
                }
                default:
                    break;
            }
        }
    }
}

@end
