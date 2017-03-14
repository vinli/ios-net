//
//  VLDConnectMeViewController_ActivationCreation.h
//  VinliDeviceMGMTKit
//
//  Created by Bryan on 3/1/17.
//  Copyright © 2017 vinli. All rights reserved.
//

#import "VLDConnectMeViewController.h"

@protocol VLDConnectMeViewController_ActivationCreationDelegate <NSObject>

@optional
- (void)connectMeViewControllerDidCompleteActivation:(VLDConnectMeViewController *)viewController;
- (void)connectMeViewControllerDidCancelActivation:(VLDConnectMeViewController *)viewController;
- (void)connectMeViewController:(VLDConnectMeViewController *)viewController didFailActivationWithError:(NSError *)error;

@end

@interface VLDConnectMeViewController ()

@property (weak, nonatomic) id<VLDConnectMeViewController_ActivationCreationDelegate> activationCompletionDelegate;

+ (instancetype)initFromStoryboardWithActivationURL:(NSURL *)activationURL;

@end
