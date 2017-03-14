//
//  VLDDemoManager.m
//  VinliDeviceMGMTKitDemo
//
//  Created by Bryan on 3/2/17.
//  Copyright © 2017 vinli. All rights reserved.
//

#import "VLDDemoManager.h"

#import "VLDSignInViewController.h"
#import "VLDUsersDevicesViewController.h"

#import <VinliSDK/VLService.h>

NSString * const kAccessTokenIdentifier = @"kAccessTokenIdentifier";
NSString * const kDeviceIdIdentifier = @"kDeviceIdIdentifier";

NSString * const VLDDidCancelWifiForADeviceNotification = @"VLDDidCancelWifiForADeviceNotification";

@implementation VLDDemoManager

#pragma mark - Class Methods

+ (instancetype)sharedManager
{
    static VLDDemoManager *sharedMyManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedMyManager = [[VLDDemoManager alloc] init];
        
        sharedMyManager.accessToken = [[NSUserDefaults standardUserDefaults] objectForKey:kAccessTokenIdentifier];
        
    });
    return sharedMyManager;
}

- (void)setAppsRootViewController:(UIViewController *)viewController
{
    [UIView transitionWithView:self.window
                      duration:0.5
                       options:UIViewAnimationOptionTransitionCrossDissolve
                    animations:^{ self.window.rootViewController = viewController; }
                    completion:nil];
}

- (void)getDevicesOnCompletion:(void(^)(VLDevicePager *pager, NSError *error))completion
{
    if (self.accessToken.length == 0)
    {
        if (completion) {
            completion(nil, nil);
        }
        return;
    }
    
    VLService *service = [[VLService alloc] initWithAccessToken:self.accessToken];
    [service getDevicesOnSuccess:^(VLDevicePager *devicePager, NSHTTPURLResponse *response) {
        if (completion) {
            completion(devicePager, nil);
        }
    } onFailure:^(NSError *error, NSHTTPURLResponse *response, NSString *bodyString) {
        if (completion) {
            completion(nil, error);
        }
    }];
}

#pragma mark - Setters and Getters

- (void)setWindow:(UIWindow *)window
{
    _window = window;
    
    if (self.accessToken.length > 0)
    {
        VLDUsersDevicesViewController *usersDevicesVC = [VLDUsersDevicesViewController initFromStoryboard];
        UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:usersDevicesVC];
        [self.window setRootViewController:navController];
        return;
    }
    VLDSignInViewController *signInViewController = [VLDSignInViewController initFromStoryboardWithAccessToken:self.accessToken.length > 0 ? self.accessToken : nil];
    
    [self.window setRootViewController:signInViewController];
}

- (void)setAccessToken:(NSString *)accessToken
{
    _accessToken = accessToken;
    
    [[NSUserDefaults standardUserDefaults] setObject:accessToken forKey:kAccessTokenIdentifier];
}

@end
