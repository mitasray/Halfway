//
//  DVSUser.m
//  
//  Copyright (c) 2014 Netguru Sp. z o.o. All rights reserved.
//

#import "DVSUser.h"

@interface DVSUser ()

@property (strong, nonatomic, readwrite) NSString *identifier;
@property (strong, nonatomic, readwrite) NSString *sessionToken;

@end

@implementation DVSUser

#pragma mark - Object lifecycle

- (NSString *)description {
    return [NSString stringWithFormat:@"<%@: %p, id: %@, sessionToken: %@, email: %@>", NSStringFromClass([self class]), self, self.identifier, self.sessionToken, self.email];
}

#pragma mark - Equality

- (BOOL)isEqual:(id)object {
    if (self == object) return YES;
    if (![object isKindOfClass:[self class]]) return NO;
    
    DVSUser *user = (DVSUser *)object;
    
    BOOL haveEqualId = [self isProperty:self.identifier equalTo:user.identifier];
    BOOL haveEqualEmail = [self isProperty:self.email equalTo:user.email];
    BOOL haveEqualSessionToken = [self isProperty:self.sessionToken equalTo:user.sessionToken];
    
    return haveEqualId && haveEqualEmail && haveEqualSessionToken;
}

- (BOOL)isProperty:(NSObject *)ownedProperty equalTo:(NSObject *)property {
    return [ownedProperty isEqual:property] || (!ownedProperty && !property);
}

- (NSUInteger)hash {
    return [self.identifier hash] ^ [self.email hash] ^ [self.sessionToken hash];
}

@end
