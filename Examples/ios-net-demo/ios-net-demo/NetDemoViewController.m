//
//  ViewController.m
//  ios-net-demo
//
//  Created by Tommy Brown on 4/26/16.
//  Copyright © 2016 Vinli. All rights reserved.
//

#import "NetDemoViewController.h"

#define ACCESS_TOKEN_KEY @"net_demo_access_token"

#define USER_SECTION 0
#define DEVICE_SECTION 1

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

#pragma mark - UITableViewDataSource

- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    int numRows = 0;
    switch(section){
        case USER_SECTION:
            numRows = 1;
            break;
        case DEVICE_SECTION:
            numRows = 2;
            break;
    }
    return numRows;
}

- (NSString *) tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    NSString *title = @"";
    switch(section){
        case USER_SECTION:
            title = @"User";
            break;
        case DEVICE_SECTION:
            title = @"Devices";
            break;
    }
    return title;
}

- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:nil];
    return cell;
}

#pragma mark - UITableViewDelegate

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
