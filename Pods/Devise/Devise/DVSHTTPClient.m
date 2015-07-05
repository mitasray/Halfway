//
//  DVSHTTPClient.m
//  
//  Copyright (c) 2014 Netguru Sp. z o.o. All rights reserved.
//

#import "AFNetworking/AFNetworking.h"

#import "DVSHTTPClient.h"
#import "DVSConfiguration.h"
#import "NSError+Devise+Private.h"

typedef void (^DVSHTTPClientRetriableBlock)(DVSHTTPClientCompletionBlock block);

@interface DVSHTTPClient ()

@property (strong, nonatomic) AFHTTPSessionManager *sessionManager;

@end

#pragma mark -

@implementation DVSHTTPClient

#pragma mark - Object lifecycle

- (instancetype)initWithConfiguration:(DVSConfiguration *)configuration {
    self = [super init];
    if (self == nil) return nil;

    _configuration = configuration;
    self.sessionManager = [[AFHTTPSessionManager alloc] initWithBaseURL:nil];

    AFJSONRequestSerializer *requestSerializer = [AFJSONRequestSerializer serializer];
    [requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    self.sessionManager.requestSerializer = requestSerializer;
    self.sessionManager.responseSerializer = [AFJSONResponseSerializer serializer];

    return self;
}

- (instancetype)init {
    return [self initWithConfiguration:nil];
}

- (void)dealloc {
    [self cancelAllRequests];
}

#pragma mark - Request management

- (void)GET:(NSString *)path parameters:(NSDictionary *)parameters completion:(DVSHTTPClientCompletionBlock)completion {
    [self executeRetriableBlock:^(DVSHTTPClientCompletionBlock retry) {
        NSAssert(self.configuration.baseURL != nil, @"Server base URL cannot be nil.");
        NSString *actualPath = [self absoluteURLStringForPath:path];
        [self.sessionManager GET:actualPath parameters:parameters success:^(NSURLSessionDataTask *task, id responseObject) {
            if (retry != NULL) retry(responseObject, nil);
        } failure:^(NSURLSessionDataTask *task, NSError *error) {
            if (retry != NULL) retry(nil, [error investigateErrorForKey:AFNetworkingOperationFailingURLResponseDataErrorKey]);
        }];
    } completion:completion];
}

- (void)POST:(NSString *)path parameters:(NSDictionary *)parameters completion:(DVSHTTPClientCompletionBlock)completion {
    [self executeRetriableBlock:^(DVSHTTPClientCompletionBlock retry) {
        NSAssert(self.configuration.baseURL != nil, @"Server base URL cannot be nil.");
        NSString *actualPath = [self absoluteURLStringForPath:path];
        [self.sessionManager POST:actualPath parameters:parameters success:^(NSURLSessionDataTask *task, id responseObject) {
            if (retry != NULL) retry(responseObject, nil);
        } failure:^(NSURLSessionDataTask *task, NSError *error) {
            if (retry != NULL) retry(nil, [error investigateErrorForKey:AFNetworkingOperationFailingURLResponseDataErrorKey]);
        }];
    } completion:completion];
}

- (void)PUT:(NSString *)path parameters:(NSDictionary *)parameters completion:(DVSHTTPClientCompletionBlock)completion {
    [self executeRetriableBlock:^(DVSHTTPClientCompletionBlock retry) {
        NSAssert(self.configuration.baseURL != nil, @"Server base URL cannot be nil.");
        NSString *actualPath = [self absoluteURLStringForPath:path];
        [self.sessionManager PUT:actualPath parameters:parameters success:^(NSURLSessionDataTask *task, id responseObject) {
            if (retry != NULL) retry(responseObject, nil);
        } failure:^(NSURLSessionDataTask *task, NSError *error) {
            if (retry != NULL) retry(nil, [error investigateErrorForKey:AFNetworkingOperationFailingURLResponseDataErrorKey]);
        }];
    } completion:completion];
}

- (void)DELETE:(NSString *)path parameters:(NSDictionary *)parameters completion:(DVSHTTPClientCompletionBlock)completion {
    [self executeRetriableBlock:^(DVSHTTPClientCompletionBlock retry) {
        NSAssert(self.configuration.baseURL != nil, @"Server base URL cannot be nil.");
        NSString *actualPath = [self absoluteURLStringForPath:path];
        [self.sessionManager DELETE:actualPath parameters:parameters success:^(NSURLSessionDataTask *task, id responseObject) {
            if (retry != NULL) retry(responseObject, nil);
        } failure:^(NSURLSessionDataTask *task, NSError *error) {
            if (retry != NULL) retry(nil, [error investigateErrorForKey:AFNetworkingOperationFailingURLResponseDataErrorKey]);
        }];
    } completion:completion];
}

- (void)cancelAllRequests {
    for (NSURLSessionTask *task in self.sessionManager.tasks) {
        [task cancel];
    }
}

#pragma mark - Headers

- (void)setValue:(NSString *)value forHTTPHeaderField:(NSString *)field {
    [self.sessionManager.requestSerializer setValue:value forHTTPHeaderField:field];
}

#pragma mark - Helpers

- (NSString *)absoluteURLStringForPath:(NSString *)path {
    return [self.configuration.baseURL URLByAppendingPathComponent:path].absoluteString;
}

- (void)executeRetriableBlock:(DVSHTTPClientRetriableBlock)retriable completion:(DVSHTTPClientCompletionBlock)completion {
    static NSUInteger retriesCounter = 0;
    retriable(^(id responseObject, NSError *error) {
        if (error == nil || retriesCounter == self.configuration.numberOfRetries) {
            if (completion != NULL) completion(responseObject, error);
            retriesCounter = 0;
        } else {
            retriesCounter++;
            NSTimeInterval waitDuration = self.configuration.retryThresholdDuration;
            dispatch_time_t gcdDuration = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(waitDuration * NSEC_PER_SEC));
            __weak typeof(self) weakSelf = self;
            dispatch_after(gcdDuration, dispatch_get_main_queue(), ^{
                [weakSelf executeRetriableBlock:retriable completion:completion];
            });
        }
    });
}

@end
