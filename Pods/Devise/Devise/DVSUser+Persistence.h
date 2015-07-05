//
//  DVSUser+Persistence.h
//  
//  Copyright (c) 2014 Netguru Sp. z o.o. All rights reserved.
//

#import "DVSUser.h"

@interface DVSUser (DVSLocalPersistence) <NSSecureCoding>

@end

@protocol DVSUserPersisting <NSObject>

@optional
/**
 *  List of property which will be stored locally. Pass names as strings.
 */
- (NSArray *)propertiesToPersistByName;

@end
