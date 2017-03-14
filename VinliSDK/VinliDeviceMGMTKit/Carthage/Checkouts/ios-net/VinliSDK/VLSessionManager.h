//
//  VLSessionManager.h
//  test3
//
//  Created by Andrew Wells on 8/4/15.
//  Copyright (c) 2015 Andrew Wells. All rights reserved.
//

#import <Foundation/Foundation.h>

#define VLSESSIONMANAGER_USE_DEV_HOST                       0

@class VLUser;
@class VLSession;
@class VLService;

//check these nullablity specifiers 

typedef void(^AuthenticationCompletion)(VLSession* _Nullable session, NSError* _Nullable error);

@interface VLSessionManager : NSObject

@property (strong, nonatomic) NSString* _Nonnull clientId;
@property (strong, nonatomic) NSString* _Nonnull redirectUri;

@property (readonly, strong, nonatomic) VLService* _Nonnull service;

@property (readonly, strong, nonatomic) NSString* _Nonnull accessToken;

@property (readonly, strong, nonatomic) VLSession* _Nonnull currentSession;

+ (instancetype _Nonnull)sharedManager;

+ (VLSession * _Nullable) currentSession;
+ (BOOL) loggedIn;
+ (void) loginWithClientId:(NSString * _Nonnull)clientId redirectUri:(NSString * _Nonnull)redirectUri completion:(AuthenticationCompletion _Nonnull)onCompletion onCancel:(nullable void(^)(void))onCancel;
+ (void) logOut;

@end
