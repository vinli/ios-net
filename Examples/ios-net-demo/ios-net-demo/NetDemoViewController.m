//
//  ViewController.m
//  ios-net-demo
//
//  Created by Tommy Brown on 4/26/16.
//  Copyright © 2016 Vinli. All rights reserved.
//

#import "NetDemoViewController.h"

#define ACCESS_TOKEN_KEY @"net_demo_access_token"

@interface NetDemoViewController ()

@end

@implementation NetDemoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void) viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
    NSString *accessToken = [self accessToken];
    if(accessToken != nil){
        self.vlService = [[VLService alloc] initWithSession:[[VLSession alloc] initWithAccessToken:accessToken]];
    }else{
        [self beginLoginFlow];
    }
}

- (NSString *) accessToken{
    return [[NSUserDefaults standardUserDefaults] objectForKey:ACCESS_TOKEN_KEY];
}

- (void) beginLoginFlow{
    [self clearCookies];
    VLLoginViewController *loginViewController = [[VLLoginViewController alloc] init];
    loginViewController.clientId = CLIENT_ID;
    loginViewController.redirectUri = REDIRECT_URI;
    loginViewController.delegate = self;
    [self presentViewController:loginViewController animated:YES completion:nil];
}

- (void) loggedInWithSession:(VLSession *)session{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setObject:session.accessToken forKey:ACCESS_TOKEN_KEY];
    [userDefaults synchronize];
}

#pragma mark - Actions

- (IBAction) refreshButtonPressed:(id)sender{
    
}

- (IBAction) logoutButtonPressed:(id)sender{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setObject:nil forKey:ACCESS_TOKEN_KEY];
    [userDefaults synchronize];
    
    self.vlService = nil;
    [self beginLoginFlow];
}

#pragma mark - VLLoginViewControllerDelegate

- (void)vlLoginViewController:(VLLoginViewController *)loginController didLoginWithSession:(VLSession *)session{
    [self loggedInWithSession:session];
}

- (void)vlLoginViewController:(VLLoginViewController *)loginController didFailToLoginWithError:(NSError *)error{
    NSLog(@"Failed to login, %@", error);
}

#pragma mark - Misc

- (void) clearCookies{
    [[NSURLCache sharedURLCache] removeAllCachedResponses];
    for (NSHTTPCookie *cookie in [[NSHTTPCookieStorage sharedHTTPCookieStorage] cookies]) {
        [[NSHTTPCookieStorage sharedHTTPCookieStorage] deleteCookie:cookie];
    }
}

@end
