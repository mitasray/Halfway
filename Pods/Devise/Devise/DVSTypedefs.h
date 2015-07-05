//
//  DVSTypedefs.h
//
//  Copyright (c) 2014 Netguru Sp. z o.o. All rights reserved.
//

#import <Foundation/Foundation.h>

@class DVSUser;

typedef void (^DVSErrorBlock)(NSError *error);
typedef void (^DVSUserBlock)(DVSUser *user);
typedef void (^DVSVoidBlock)(void);
typedef void (^DVSDictionaryBlock)(NSDictionary *dictionary);

typedef NS_ENUM(NSInteger, DVSActionType) {
    DVSActionLogin,
    DVSActionRegistration,
    DVSActionRemindPassword,
    DVSActionChangePassword,
    DVSActionUpdate
};
