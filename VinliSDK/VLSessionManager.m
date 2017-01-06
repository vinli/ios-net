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

@interface VLSessionManager () <VLLoginViewControllerDelegate>

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

+ (void) loginWithClientId:(NSString *)clientId redirectUri:(NSString *)redirectUri completion:(AuthenticationCompletion)onCompletion onCancel:(void (^)(void))onCancel{
    
    authCompletionBlock = onCompletion;
    cancelBlock = onCancel;
    
    VLLoginViewController *loginVC = [[VLLoginViewController alloc] initWithClientId:clientId redirectUri:redirectUri];
    loginVC.delegate = self;
    loginVC.title = @"Login With Vinli";
    navigationController = [[UINavigationController alloc] initWithRootViewController:loginVC];
    loginVC.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Cancel" style:UIBarButtonItemStylePlain target:[VLSessionManager class] action:@selector(cancelLogin)];
    navigationController.navigationBar.barTintColor = [UIColor colorWithRed:36.0f/255.0f green:167.0f/255.0f blue:223.0f/255.0f alpha:1];
    navigationController.navigationBar.tintColor = [UIColor whiteColor];
    navigationController.navigationBar.translucent = NO;
    navigationController.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName : [UIColor whiteColor]};
    [[[[[UIApplication sharedApplication] delegate] window] rootViewController] presentViewController:navigationController animated:YES completion:nil];
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

#pragma mark - VLLoginViewControllerDelegate

+ (void) vlLoginViewController:(VLLoginViewController *)loginController didLoginWithSession:(VLSession *)session{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:session.accessToken forKey:VLSessionManagerCachedAccessTokenKey];
    [defaults synchronize];
    navigationController = nil;
    authCompletionBlock(session, nil);
}

+ (void) vlLoginViewController:(VLLoginViewController *)loginController didFailToLoginWithError:(NSError *)error{
    navigationController = nil;
    authCompletionBlock(nil, error);
}

@end
