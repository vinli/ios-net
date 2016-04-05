//
//  VLLoginButton.h
//  VinliSDK
//
//  Created by Tommy Brown on 6/10/15.
//  Copyright (c) 2015 Vinli. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "VLLoginViewController.h"

@protocol VLLoginButtonDelegate;
@protocol VLLogoutButtonDelegate;



@interface VLLoginButton : UIButton <VLLoginViewControllerDelegate>


@property (nonatomic, weak ) id<VLLoginButtonDelegate> delegate; //this will pass the delegate to the loginViewController

@property VLLoginViewController *loginViewController;
- (id) init;
- (id) initWithCoder:(NSCoder *)aDecoder;
- (id) initWithFrame:(CGRect)frame;




- (void) vlLoginViewController:(VLLoginViewController *)loginController didLoginWithSession:(VLSession *) session;
- (void) vlLoginViewController:(VLLoginViewController *)loginController didFailToLoginWithError:(NSError *) error;

@end


@protocol VLLoginButtonDelegate <NSObject>


- (void)didButtonLogout;
- (void)didButtonFailToLogout:(NSError *)error;

@required
- (void)didButtonLogin:(VLLoginViewController *)loginViewController session:(VLSession *)session;
- (void)didButtonFailLogin:(VLLoginViewController *)loginViewController error:(NSError *)error;

@end


