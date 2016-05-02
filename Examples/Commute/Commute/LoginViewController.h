//
//  LoginViewController.h
//  Commute
//
//  Created by Jai Ghanekar on 1/20/16.
//  Copyright © 2016 Vinli. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <VinliNet/VinliSDK.h>

@interface LoginViewController : UIViewController<VLLoginButtonDelegate>
@property (strong, nonatomic) IBOutlet VLLoginButton *loginButton;


- (void)didButtonLogin:(VLLoginViewController *)loginViewController session:(VLSession *)session;
- (void)didButtonFailLogin:(VLLoginViewController *)loginViewController error:(NSError *)error;
@end
