//
//  DVSHTTPClient.h
//
//  Copyright (c) 2014 Netguru Sp. z o.o. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol DVSHTTPClientDelegate;
@class DVSConfiguration;

/**
 *  The completion block of all http requests.
 *
 *  @param responseObject The response object of the request, if any.
 *  @param error          An error that occurred, if any.
 */
typedef void (^DVSHTTPClientCompletionBlock)(id responseObject, NSError *error);

/**
 *  The DVSHTTPClient class provides a network abstraction layer.
 */
@interface DVSHTTPClient : NSObject

/**
 *  The HTTPClient's delegate object.
 */
@property (weak, nonatomic) id<DVSHTTPClientDelegate> delegate;

/**
*  The configuration object used to negotiate various settings.
*/
@property (strong, nonatomic) DVSConfiguration *configuration;

/**
 *  Creates and returns an initialized instance of the http client.
 *
 *  @param configuration The configuration object to be used.
 *
 *  @return Instance of DVSHTTPClient class
 */
- (instancetype)initWithConfiguration:(DVSConfiguration *)configuration;

/**
 *  Performs a GET request for a given path. The completion block's object is a deserialized response JSON.
 *
 *  @param path       The relative path of the request.
 *  @param parameters The parameters to be included in the request.
 *  @param block      The completion block executed when the request finishes.
 */
- (void)GET:(NSString *)path parameters:(NSDictionary *)parameters completion:(DVSHTTPClientCompletionBlock)block;

/**
 *  Performs a POST request for a given path. The completion block's object is a deserialized response JSON.
 *
 *  @param path       The relative path of the request.
 *  @param parameters The parameters to be included in the request.
 *  @param block      The completion block executed when the request finishes.
 */
- (void)POST:(NSString *)path parameters:(NSDictionary *)parameters completion:(DVSHTTPClientCompletionBlock)block;

/**
 *  Performs a PUT request for a given path. The completion block's object is a deserialized response JSON.
 *
 *  @param path       The relative path of the request.
 *  @param parameters The parameters to be included in the request.
 *  @param block      The completion block executed when the request finishes.
 */
- (void)PUT:(NSString *)path parameters:(NSDictionary *)parameters completion:(DVSHTTPClientCompletionBlock)block;

/**
 *  Performs a DELETE request for a given path. The completion block's object is a deserialized response JSON.
 *
 *  @param path       The relative path of the request.
 *  @param parameters The parameters to be included in the request.
 *  @param block      The completion block executed when the request finishes.
 */
- (void)DELETE:(NSString *)path parameters:(NSDictionary *)parameters completion:(DVSHTTPClientCompletionBlock)block;

/**
 *  Sets the value for the HTTP header field. If nil, removes the existing value for that header.
 *
 *  @param value The value set as default for the specified header (if any).
 *  @param field The HTTP header to set a default value for.
 */
- (void)setValue:(NSString *)value forHTTPHeaderField:(NSString *)field;

/**
 *  Cancels and invalidates all requests.
 */
- (void)cancelAllRequests;

@end

@protocol DVSHTTPClientDelegate <NSObject>

/**
 *  Asks delegate for email used in authorization header.
 */
- (NSString *)emailForAuthorizationHeaderInHTTPClient:(DVSHTTPClient *)client;

@end
