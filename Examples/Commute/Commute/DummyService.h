//
//  DummyService.h
//  Commute
//
//  Created by Jai Ghanekar on 4/28/16.
//  Copyright © 2016 Vinli. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <VinliNet/VinliSDK.h>




@interface DummyService : NSObject
+ (void)dummyOnSuccess:(void (^)(NSDictionary *dummy, NSHTTPURLResponse *response))onSuccessBlock onFailure:(void (^)(NSError *error, NSHTTPURLResponse *response, NSString *bodyString))onFailureBlock;
+ (NSString *)currentRouteId;
+ (NSString *)currentVin;

+ (void)createDummyWithName:(NSString *)name onSuccess:(void (^)(NSDictionary *dummy, NSHTTPURLResponse *response))onSuccessBlock onFailure:(void (^)(NSError *error, NSHTTPURLResponse *response, NSString *bodyString))onFailureBlock;
+ (void)getAllDummyDevicesOnSuccess:(void (^)(NSDictionary *dummies, NSHTTPURLResponse *response))onSuccessBlock onFailure:(void (^)(NSError *error, NSHTTPURLResponse *response, NSString *bodyString))onFailureBlock;
+ (void)getAllDummyRoutesOnSuccess:(void (^)(NSDictionary *routes, NSHTTPURLResponse *response))onSuccessBlock onFailure:(void (^)(NSError *error, NSHTTPURLResponse *response, NSString *bodyString))onFailureBlock;
+ (void)createRunForDummyWithId:(NSString *)dummyId vin:(NSString *)vinNumber routeId:(NSString *)routeId onSuccess:(void (^)(NSDictionary *run, NSHTTPURLResponse *response))onSuccessBlock
                       onFailure:(void (^)(NSError *error, NSHTTPURLResponse *response, NSString *bodyString))onFailureBlock;
+ (void)getCurrentRunForDummy:(NSString *)dummyId onSuccess:(void (^)(NSDictionary *run, NSHTTPURLResponse *response))onSuccessBlock
                    onFailure:(void (^)(NSError *error, NSHTTPURLResponse *response, NSString *bodyString))onFailureBlock;
+ (void)deleteRunForDummyWithId:(NSString *)dummyId vin:(NSString *)vinNumber routeId:(NSString *)routeId onSuccess:(void (^)(NSHTTPURLResponse *response))onSuccessBlock
                      onFailure:(void (^)(NSError *error, NSHTTPURLResponse *response, NSString *bodyString))onFailureBlock;
+ (void)deleteDummyWithId:(NSString *)dummyId onSuccess:(void (^)(NSHTTPURLResponse *response))onSuccessBlock onFailure:(void (^)(NSError *error, NSHTTPURLResponse *response, NSString *bodyString))onFailureBlock;

//+ (void)registerDummyWithDeviceId:(NSString *)deviceId;

@end
