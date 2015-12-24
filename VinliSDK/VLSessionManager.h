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

typedef void(^AuthenticationCompletion)(VLSession* _Nullable session, NSError* _Nullable error);

@interface VLSessionManager : NSObject

@property (strong, nonatomic) NSString *clientId;
@property (strong, nonatomic) NSString *redirectUri;

@property (readonly, strong, nonatomic) VLService *service;

@property (readonly, strong, nonatomic) NSString* accessToken;

@property (readonly, strong, nonatomic) VLSession *currentSession;

+ (instancetype)sharedManager;

- (void)handleCustomURL:(NSURL *)url;


- (void)getSessionForUserWithId:(NSString *)userId completion:(AuthenticationCompletion)onCompletion;

// Convenience method to display an AlertView with available users.
- (void)loginWithCompletion:(AuthenticationCompletion)onCompletion onCancel:(void(^)(void))onCancel;

@end
