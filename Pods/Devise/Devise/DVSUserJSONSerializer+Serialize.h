//
//  DVSUserJSONSerializer+Serialize.h
//  Devise
//
//  Created by Wojciech Trzasko on 12.02.2015.
//  Copyright (c) 2015 Netguru Sp. z o.o. All rights reserved.
//

#import "DVSUserJSONSerializer.h"

@interface DVSUserJSONSerializer (Serialize)

/**
 *  Generates and return NSDictionary representing JSON for registering user
 *  @param user The user object to be registered
 *  @return Instance of NSDictionary
 */
- (NSDictionary *)registerJSONDictionaryForUser:(DVSUser *)user;

/**
 *  Generates and return NSDictionary representing JSON for loging in user
 *  @param user The user object to be logged in
 *  @return Instance of NSDictionary
 */
- (NSDictionary *)loginJSONDictionaryForUser:(DVSUser *)user;

/**
 *  Generates and return NSDictionary representing JSON for reminding user's password
 *  @param user The user object which password will be reminded
 *  @return Instance of NSDictionary
 */
- (NSDictionary *)remindPasswordJSONDictionaryForUser:(DVSUser *)user;

/**
 *  Generates and return NSDictionary representing JSON for changing user's password
 *  @param user The user object which password will be changed
 *  @return Instance of NSDictionary
 */
- (NSDictionary *)changePasswordJSONDictionaryForUser:(DVSUser *)user;

/**
 *  Generates and return NSDictionary representing JSON for updating user data
 *  @param user The user object which will be updated
 *  @return Instance of NSDictionary
 */
- (NSDictionary *)updateJSONDictionaryForUser:(DVSUser *)user;

@end
