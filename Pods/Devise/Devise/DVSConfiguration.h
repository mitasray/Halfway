//
//  DVSConfiguration.h
//
//  Copyright (c) 2014 Netguru Sp. z o.o. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 *  Logging mode of the framework.
 */
typedef NS_ENUM(NSInteger, DVSLoggingMode) {

    /**
     *  Don't log anything, ignore all messages.
     */
    DVSLoggingModeNone,

    /**
     *  Print all messages using NSLog.
     */
    DVSLoggingModeWarning,

    /**
     *  Abort the code with the message.
     */
    DVSLoggingModeAssert,
};

/**
 *  The main configuration object of Devise.
 */
@interface DVSConfiguration : NSObject

/**
 *  The root URL of the server backend.
 */
@property (copy, nonatomic) NSURL *serverURL;

/**
 *  The base URL of the server backend, which includes api and resource paths.
 */
@property (strong, nonatomic, readonly) NSURL *baseURL;

/**
 *  The keychain service name for local users persistence.
 */
@property (copy, nonatomic) NSString *keychainServiceName;

/**
 *  The server-side api version (default: 1). IMPORTANT: Set to 0 if the backend does not implement versioning.
 */
@property (assign, nonatomic) NSUInteger apiVersion;

/**
 *  The server-side resource name (default: users).
 */
@property (copy, nonatomic) NSString *resourceName;

/**
 *  ID of the Facebook app associated with this iOS app.
 */
@property (copy, nonatomic) NSString *facebookAppID;

/**
 *  ID of the Google app associated with this iOS app.
 */
@property (copy, nonatomic) NSString *googleClientID;

/**
 *  The logging level of the framework (default: DVSLoggingModeNone).
 */
@property (assign, nonatomic) DVSLoggingMode loggingMode;

/**
 *  The number of retries in case of connection issues (default: 0).
 */
@property (assign, nonatomic) NSUInteger numberOfRetries;

/**
 *  The duration (in seconds) after which a next retry happens (default: 0).
 */
@property (assign, nonatomic) NSTimeInterval retryThresholdDuration;

/**
 *  Returns a shared instance of the configuration object.
 *
 *  Devise uses AFNetworking under the hood. If activity indicator should be
 *  managed automatically enable `AFNetworkActivityIndicatorManager` 
 *  in `AppDelegate application:didFinishLaunchingWithOptions:`
 */
+ (instancetype)sharedConfiguration;

/**
 *  Creates and returns an instance of configuration object.
 *
 *  @param serverURL The root URL of the server backend.
 *  @return Instance of DVSConfiguration.
 */
- (instancetype)initWithServerURL:(NSURL *)serverURL NS_DESIGNATED_INITIALIZER;

/**
 *  Logs a message with the level specified by the \c logLevel property.
 *
 *  @param message The message to log.
 */
- (void)logMessage:(NSString *)message;

@end
