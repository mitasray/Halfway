//
//  DVSOAuthJSONParameters.m
//  Devise
//
//  Created by Pawel Bialecki on 04.03.2015.
//  Copyright (c) 2015 Netguru Sp. z o.o. All rights reserved.
//

#import "DVSOAuthJSONParameters.h"

@implementation DVSOAuthJSONParameters

+ (NSDictionary *)dictionaryForParametersWithProvider:(DVSOAuthProvider)provider oAuthToken:(NSString *)oAuthToken userID:(NSString *)userID userEmail:(NSString *)email {
    
    NSAssert(oAuthToken != nil, @"Token can not be nil!");
    NSAssert(userID != nil, @"User ID can not be nil!");
    NSAssert(email != nil, @"Email can not be nil!");
    
    NSString *providerName = nil;
    
    switch (provider) {
        case DVSOAuthProviderFacebook:
            providerName = @"facebook";
            break;
        case DVSOAuthProviderGoogle:
            providerName = @"google";
            break;
        default:
            NSAssert(true, @"Proper provider is needed!");
            break;
    }
    
    NSDictionary *parameters = @{
         @"provider" : providerName,
         @"oauth_token" : oAuthToken,
         @"uid" : userID,
         @"email" : email
    };
    
    return @{@"user" : parameters};
}

@end
