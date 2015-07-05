//
//  DVSUserJSONSerializer+Serialize.m
//  Devise
//
//  Created by Wojciech Trzasko on 12.02.2015.
//  Copyright (c) 2015 Netguru Sp. z o.o. All rights reserved.
//

#import "DVSUserJSONSerializer+Serialize.h"
#import "DVSUser.h"

@implementation DVSUserJSONSerializer (Serialize)

#pragma mark - Public Methods

- (NSDictionary *)registerJSONDictionaryForUser:(DVSUser *)user {
    NSMutableDictionary *json = [NSMutableDictionary dictionary];
    
    if (user.email != nil) json[self.JSONKeyPathForEmail] = user.email;
    if (user.password != nil) json[self.JSONKeyPathForPassword] = user.password;
    [json addEntriesFromDictionary:[self additionalParametersForAction:DVSActionRegistration]];
    
    return [self userDeviseLikeJSONWithJSON:[json copy]];
}

- (NSDictionary *)loginJSONDictionaryForUser:(DVSUser *)user {
    NSMutableDictionary *json = [NSMutableDictionary dictionary];
    
    if (user.password != nil) json[self.JSONKeyPathForPassword] = user.password;
    if (user.email != nil) json[self.JSONKeyPathForEmail] = user.email;
    [json addEntriesFromDictionary:[self additionalParametersForAction:DVSActionLogin]];
    
    return [self userDeviseLikeJSONWithJSON:[json copy]];
}

- (NSDictionary *)remindPasswordJSONDictionaryForUser:(DVSUser *)user {
    NSMutableDictionary *json = [NSMutableDictionary dictionary];
    
    if (user.email != nil) json[self.JSONKeyPathForEmail] = user.email;
    [json addEntriesFromDictionary:[self additionalParametersForAction:DVSActionRemindPassword]];
    
    return [self userDeviseLikeJSONWithJSON:[json copy]];
}

- (NSDictionary *)changePasswordJSONDictionaryForUser:(DVSUser *)user {
    NSMutableDictionary *json = [NSMutableDictionary dictionary];
    
    if (user.password != nil) json[self.JSONKeyPathForPassword] = user.password;
    if (user.password != nil) json[self.JSONKeyPathForPasswordConfirmation] = user.password;
    [json addEntriesFromDictionary:[self additionalParametersForAction:DVSActionChangePassword]];
    
    return [self userDeviseLikeJSONWithJSON:json];
}

- (NSDictionary *)updateJSONDictionaryForUser:(DVSUser *)user {
    NSMutableDictionary *json = [NSMutableDictionary dictionary];
    
    if (user.email != nil) json[self.JSONKeyPathForEmail] = user.email;
    [json addEntriesFromDictionary:[self additionalParametersForAction:DVSActionUpdate]];
    
    return [self userDeviseLikeJSONWithJSON:json];
}

#pragma mark - Private Methods

- (NSDictionary *)additionalParametersForAction:(DVSActionType)action {
    
    if (self.dataSource && [self.dataSource respondsToSelector:@selector(additionalRequestParametersForAction:)]) {
        return [self.dataSource additionalRequestParametersForAction:action];
    }
    return nil;
}

- (NSDictionary *)userDeviseLikeJSONWithJSON:(NSDictionary *)json {
    return @{@"user" : json};
}

@end
