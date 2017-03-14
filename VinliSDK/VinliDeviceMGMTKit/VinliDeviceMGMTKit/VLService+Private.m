//
//  VLService+Private.m
//  VinliDeviceMGMTKit
//
//  Created by Bryan on 2/28/17.
//  Copyright © 2017 vinli. All rights reserved.
//

#import "VLService+Private.h"

#import <VinliSDK/NSHTTPURLResponse+VLAdditions.h>

NSString * const kPlatformServiceHostString = @"platform";
NSString * const kMyVinliServiceServiceHostString = @"my-vinli";
NSString * const kAuthServiceServiceHostString = @"auth";

@implementation VLService (Private)

#pragma mark - Platform Service

- (void)addDeviceWithDeviceId:(NSString *)deviceId caseId:(NSString *)caseId onSuccess:(void(^)(NSHTTPURLResponse *response))successBlock onFailure:(void(^)(NSError *error, NSHTTPURLResponse *response, NSString *bodyString))failureBlock
{
    if (self.session == nil)
    {
        return;
    }
    
    NSString *path = @"/devices";
    NSDictionary *payload = @{ @"device" : @{ @"id" : deviceId,
                                              @"casId" : caseId}};
    
    [self startWithHost:@"platform" path:path queries:nil HTTPMethod:@"POST" parameters:payload token:self.session.accessToken onSuccess:^(NSDictionary *result, NSHTTPURLResponse *response) {
        
        if (![response isSuccessfulResponse]) {
            if (failureBlock) {
                NSError *error = [NSError errorWithDomain:@"VinliSDKErrorDomain" code:response.statusCode userInfo:result];
                failureBlock(error, response, nil);
            }
            return;
        }
        
        if (successBlock) {
            successBlock(response);
        }
        
    } onFailure:^(NSError *error, NSHTTPURLResponse *response, NSString *body) {
        
        if (failureBlock) {
            failureBlock(error, response, body);
        }
        
    }];
}

#pragma mark - My Vinli Service

- (void)getExternalLinkForActivation:(NSString *)activationId pin:(NSString *)pin success:(void(^)(NSHTTPURLResponse *response))success failure:(void(^)(NSError *error, NSHTTPURLResponse *response, NSString *bodyString))failure
{
    if (self.session == nil)
    {
        return;
    }
    
    NSString *path;
    if (activationId.length > 0)
    {
        path = [NSString stringWithFormat:@"/externalLinks/activate/%@", activationId];
    }
    
    NSDictionary *params;
    if (pin.length == 4)
    {
        params = @{@"pin" : pin};
    }

    [self startWithHost:kMyVinliServiceServiceHostString path:path queries:params HTTPMethod:@"GET" parameters:nil token:self.session.accessToken onSuccess:^(NSDictionary *result, NSHTTPURLResponse *response) {
        
        if (![response isSuccessfulResponse]) {
            if (failure) {
                NSError *error = [NSError errorWithDomain:@"VinliSDKErrorDomain" code:response.statusCode userInfo:result];
                failure(error, response, nil);
            }
            return;
        }
        
        if (success) {
            success(response);
        }
        
    } onFailure:^(NSError *error, NSHTTPURLResponse *response, NSString *bodyString) {
       
        if (failure) {
            failure(error, response, bodyString);
        }
        
    }];
}

- (void)getExternalLinkForCancelWifiWithDeviceId:(NSString *)deviceId success:(void(^)(NSDictionary *externalLinkDict, NSHTTPURLResponse *response))success failure:(void(^)(NSError *error, NSHTTPURLResponse *response, NSString *bodyString))failure
{
    if (!self.session)
    {
        return;
    }
    
    NSString *path;
    if (deviceId.length > 0)
    {
        path = [NSString stringWithFormat:@"/externalLinks/delete/%@", deviceId];
    }
    
    [self startWithHost:kMyVinliServiceServiceHostString path:path queries:nil HTTPMethod:@"GET" parameters:nil token:self.session.accessToken onSuccess:^(NSDictionary *result, NSHTTPURLResponse *response) {
        
        if (![response isSuccessfulResponse]) {
            if (failure) {
                NSError *error = [NSError errorWithDomain:@"VinliSDKErrorDomain" code:response.statusCode userInfo:result];
                failure(error, response, nil);
            }
            return;
        }
        
        if (success) {
            success(result, response);
        }
        
    } onFailure:^(NSError *error, NSHTTPURLResponse *response, NSString *bodyString) {
        
        if (failure) {
            failure(error, response, bodyString);
        }
        
    }];
}

- (void)getExternalLinkForWifiManagementWithDeviceId:(NSString *)deviceId success:(void(^)(NSDictionary *externalLinkDict, NSHTTPURLResponse *response))success failure:(void(^)(NSError *error, NSHTTPURLResponse *response, NSString *bodyString))failure
{
    if (!self.session)
    {
        return;
    }
    
    NSString *path;
    if (deviceId.length > 0)
    {
        path = [NSString stringWithFormat:@"/externalLinks/manageWifi/%@", deviceId];
    }
    
    [self startWithHost:kMyVinliServiceServiceHostString path:path queries:nil HTTPMethod:@"GET" parameters:nil token:self.session.accessToken onSuccess:^(NSDictionary *result, NSHTTPURLResponse *response) {
        
        if (![response isSuccessfulResponse]) {
            if (failure) {
                NSError *error = [NSError errorWithDomain:@"VinliSDKErrorDomain" code:response.statusCode userInfo:result];
                failure(error, response, nil);
            }
            return;
        }
        
        if (success) {
            success(result, response);
        }
        
    } onFailure:^(NSError *error, NSHTTPURLResponse *response, NSString *bodyString) {
        
        if (failure) {
            failure(error, response, bodyString);
        }
        
    }];
}

#pragma mark - Auth Service

- (void)activateDeviceWithCaseId:(NSString *)caseId pin:(NSString *)pin success:(void(^)(NSDictionary *activationDict, NSHTTPURLResponse *response))success failure:(void(^)(NSError *error, NSHTTPURLResponse *response, NSString *bodyString))failure 
{
    if (!self.session)
    {
        return;
    }
    
    NSString* path = [NSString stringWithFormat:@"/cases/%@/activations", caseId];
    NSDictionary* activation = @{ @"pin": pin };
    
    [self startWithHost:kAuthServiceServiceHostString path:path queries:nil HTTPMethod:@"POST" parameters:@{ @"activation": activation } token:self.session.accessToken onSuccess:^(NSDictionary *result, NSHTTPURLResponse *response) {
        
        if (![response isSuccessfulResponse]) {
            if (failure) {
                NSError *error = [NSError errorWithDomain:@"VinliSDKErrorDomain" code:response.statusCode userInfo:result];
                failure(error, response, nil);
            }
            return;
        }
        
        if (success) {
            success(result, response);
        }
        
    } onFailure:^(NSError *error, NSHTTPURLResponse *response, NSString *body) {
        
        if (failure) {
            failure(error, response, body);
        }
        
    }];
}

- (void)checkToSeeIfDeviceIsClaimedByCaseId:(NSString *)caseId success:(void(^)(NSDictionary *claimedDict, NSHTTPURLResponse *response))success failure:(void(^)(NSError *error, NSHTTPURLResponse *response, NSString *bodyString))failure
{
    if (caseId.length == 0)
    {
        return;
    }
    
    NSString *path = [NSString stringWithFormat:@"/cases/%@/claimed", [caseId uppercaseString]];
    
    [self startWithHost:kAuthServiceServiceHostString path:path queries:nil HTTPMethod:@"GET" parameters:nil token:self.session.accessToken onSuccess:^(NSDictionary *result, NSHTTPURLResponse *response) {
        
        if (![response isSuccessfulResponse]) {
            if (failure) {
                NSError *error = [NSError errorWithDomain:@"VinliSDKErrorDomain" code:response.statusCode userInfo:result];
                failure(error, response, nil);
            }
            return;
        }
        
        if (success) {
            success(result, response);
        }
        
    } onFailure:^(NSError *error, NSHTTPURLResponse *response, NSString *body) {
        
        if (failure) {
            failure(error, response, body);
        }
        
    }];
}

@end
