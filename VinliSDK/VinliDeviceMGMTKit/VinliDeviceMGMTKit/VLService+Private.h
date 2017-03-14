//
//  VLService+Private.h
//  VinliDeviceMGMTKit
//
//  Created by Bryan on 2/28/17.
//  Copyright © 2017 vinli. All rights reserved.
//

#import <VinliSDK/VLService.h>

#define weakify(var) __weak typeof(var) VNLWeak_##var = var;

#define strongify(var) \
_Pragma("clang diagnostic push") \
_Pragma("clang diagnostic ignored \"-Wshadow\"") \
__strong typeof(var) var = VNLWeak_##var; \
_Pragma("clang diagnostic pop")

@interface VLService (Private)

#pragma mark - Platform Service

- (void)addDeviceWithDeviceId:(NSString *)deviceId caseId:(NSString *)caseId onSuccess:(void(^)(NSHTTPURLResponse *response))successBlock onFailure:(void(^)(NSError *error, NSHTTPURLResponse *response, NSString *bodyString))failureBlock;

#pragma mark - My Vinli Service

- (void)getExternalLinkForActivation:(NSString *)activationId pin:(NSString *)pin success:(void(^)(NSHTTPURLResponse *response))success failure:(void(^)(NSError *error, NSHTTPURLResponse *response, NSString *bodyString))failure;

- (void)getExternalLinkForCancelWifiWithDeviceId:(NSString *)deviceId success:(void(^)(NSDictionary *externalLinkDict, NSHTTPURLResponse *response))success failure:(void(^)(NSError *error, NSHTTPURLResponse *response, NSString *bodyString))failure;

- (void)getExternalLinkForWifiManagementWithDeviceId:(NSString *)deviceId success:(void(^)(NSDictionary *externalLinkDict, NSHTTPURLResponse *response))success failure:(void(^)(NSError *error, NSHTTPURLResponse *response, NSString *bodyString))failure;

#pragma mark - Auth Service

- (void)activateDeviceWithCaseId:(NSString *)caseId pin:(NSString *)pin success:(void(^)(NSDictionary *activationDict, NSHTTPURLResponse *response))success failure:(void(^)(NSError *error, NSHTTPURLResponse *response, NSString *bodyString))failure;
- (void)checkToSeeIfDeviceIsClaimedByCaseId:(NSString *)caseId success:(void(^)(NSDictionary *claimedDict, NSHTTPURLResponse *response))success failure:(void(^)(NSError *error, NSHTTPURLResponse *response, NSString *bodyString))failure;

@end
