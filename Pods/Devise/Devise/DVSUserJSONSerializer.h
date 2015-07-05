//
//  DVSUserJSONSerializer.h
//  Devise
//
//  Created by Wojciech Trzasko on 12.02.2015.
//  Copyright (c) 2015 Netguru Sp. z o.o. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DVSTypedefs.h"

@protocol DVSUserJSONSerializerDataSource;

@interface DVSUserJSONSerializer : NSObject

/**
 *  The server-side parameter name for email (default: email).
 */
@property (strong, nonatomic) NSString *JSONKeyPathForEmail;

/**
 *  The server-side parameter name for password (default: password).
 */
@property (strong, nonatomic) NSString *JSONKeyPathForPassword;

/**
 *  The server-side parameter name for password confirmation (default: passwordConfirmation).
 */
@property (strong, nonatomic) NSString *JSONKeyPathForPasswordConfirmation;

/**
 *  The server-side authentication token name (default: authenticationToken).
 */
@property (strong, nonatomic) NSString *JSONKeyPathForAuthenticationToken;

/**
 *  The serializer's delegate object. Use it to expand serializer possibilities.
 */
@property (weak, nonatomic) id<DVSUserJSONSerializerDataSource> dataSource;

@end

@protocol DVSUserJSONSerializerDataSource <NSObject>

@optional
/**
 *  Allows delegate to provide own request parameters (as dictionary) for specified action.
 *
 *  @param action The action for which given parameters will be added.
 */
- (NSDictionary *)additionalRequestParametersForAction:(DVSActionType)action;

@end
