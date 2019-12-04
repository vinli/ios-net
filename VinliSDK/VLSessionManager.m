//
//  VLSessionManager.m
//  test3
//
//  Created by Andrew Wells on 8/4/15.
//  Copyright (c) 2015 Andrew Wells. All rights reserved.
//

#import "VLSessionManager.h"
#import <UIKit/UIKit.h>
#import "VinliSDK.h"


static NSString * VLSessionManagerHostDemo = @"-demo.vin.li";
static NSString * VLSessionManagerHostDev = @"-dev.vin.li";

static NSString * VLSessionManagerCachedSessionsKey = @"VLSessionManagerCachedSessionsKey";

static NSString *VLSessionManagerCachedAccessTokenKey = @"VLSessionManagerCachedAccessTokenKey";

static AuthenticationCompletion authCompletionBlock;
static void (^cancelBlock)(void);
static UINavigationController *navigationController;

@interface VLSessionManager ()

@property (copy, nonatomic) AuthenticationCompletion authenticationCompletionBlock;

@property (strong, nonatomic) VLService* service;
@property (strong, nonatomic) VLSession* currentSession;

@end

@implementation VLSessionManager

#pragma mark - Accessors and Mutators

- (VLService *)service
{
    if (!_service)
    {
        _service = [[VLService alloc] init];
#if VLSESSIONMANAGER_USE_DEV_HOST
        _service.host = VLSessionManagerHostDev;
#endif
    }
    return _service;
}

- (VLSession *)currentSession
{
    return _service.session;
}

#pragma mark - Initialization

+ (id)sharedManager {
    static VLSessionManager *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[self alloc] init];
    });
    return instance;
}

#pragma mark - New Login Methods

+ (VLSession *) currentSession{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *accessToken = [defaults stringForKey:VLSessionManagerCachedAccessTokenKey];
    return (accessToken == nil) ? nil : [[VLSession alloc] initWithAccessToken:accessToken];
}

+ (BOOL) loggedIn{
    return ([VLSessionManager currentSession] != nil);
}

+ (void) logOut{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:nil forKey:VLSessionManagerCachedAccessTokenKey];
    [defaults synchronize];
}

+ (void) cancelLogin{
    [[[[[UIApplication sharedApplication] delegate] window] rootViewController] dismissViewControllerAnimated:YES completion:^{
        navigationController = nil;
        if (cancelBlock) {
            cancelBlock();
        }
    }];
}

@end
