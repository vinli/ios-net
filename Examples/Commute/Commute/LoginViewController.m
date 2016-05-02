//
//  LoginViewController.m
//  Commute
//
//  Created by Jai Ghanekar on 1/20/16.
//  Copyright © 2016 Vinli. All rights reserved.
//

#import "LoginViewController.h"
#import "HomeScreenViewController.h"
#import <VinliNet/VinliSDK.h>

@interface LoginViewController ()

@end

@implementation LoginViewController

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];

    
    // Do any additional setup after loading the view.
    
    
    self.loginButton.delegate = self;
    
    self.loginButton.navController = self.navigationController;
}


- (void)didButtonLogin:(VLLoginViewController *)loginViewController session:(VLSession *)session {
    //[self.navigationController dismissViewControllerAnimated:YES completion:nil];
    [self dismissViewControllerAnimated:YES completion:nil];
}





- (void)didButtonFailLogin:(VLLoginViewController *)loginViewController error:(NSError *)error {
    NSLog(@"Button failed login");
}




@end
