//
//  DVSAccountStore.m
//  Devise
//
//  Created by Pawel Bialecki on 09.03.2015.
//  Copyright (c) 2015 Netguru Sp. z o.o. All rights reserved.
//

#import "DVSFacebookAccountStore.h"

@interface DVSFacebookAccountStore ()

@property (strong, nonatomic) NSDictionary *options;

@end

@implementation DVSFacebookAccountStore

- (instancetype)initWithAppID:(NSString *)appID permissions:(NSArray *)permissions {
    if (self = [super init]) {
        
        NSAssert(appID != nil, @"Facebook appID can not be nil!");
        NSAssert(permissions != nil, @"Facebook permissions can not be nil!");
        
        _options = @{
          ACFacebookAppIdKey : appID,
          ACFacebookPermissionsKey : permissions,
          ACFacebookAudienceKey : ACFacebookAudienceOnlyMe
        };
    }
    
    return self;
}

- (void)requestAccessWithCompletion:(DVSAccountStoreBlock)completion {
    
    if (completion == NULL) return;
    
    [self requestAccessToAccountsWithType:[self accountType] options:self.options completion:^(BOOL granted, NSError *error) {
        if (granted) {
            [self renewCredentialsWithCompletion:completion];
        } else {
            completion(nil, error);
        }
    }];
}

- (void)renewCredentialsWithCompletion:(DVSAccountStoreBlock)completion {
    
    if (completion == NULL) return;
    
    [self renewCredentialsForAccount:[self account] completion:^(ACAccountCredentialRenewResult renewResult, NSError *error) {
        if (renewResult == ACAccountCredentialRenewResultRenewed) {
            completion([self account], error);
        } else {
            completion(nil, error);
        }
    }];
}

- (ACAccount *)account {
    NSArray *accounts = [self accountsWithAccountType:[self accountType]];
    NSAssert([accounts count] > 0, @"At least one Facebook account should exist!");
    return [accounts lastObject];
}

- (ACAccountType *)accountType {
    return [self accountTypeWithAccountTypeIdentifier:ACAccountTypeIdentifierFacebook];
}

@end
