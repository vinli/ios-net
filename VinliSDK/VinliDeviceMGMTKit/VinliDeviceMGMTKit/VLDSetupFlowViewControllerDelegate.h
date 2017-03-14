//
//  VLDSetupFlowViewControllerDelegate.h
//  VinliDeviceMGMTKit
//
//  Created by Bryan on 2/21/17.
//  Copyright © 2017 vinli. All rights reserved.
//

#import <Foundation/Foundation.h>

//#import "VLDSetupFlowViewController.h"

@class VLDevice;
@class VLDSetupFlowViewController;
@protocol VLDSetupFlowViewControllerDelegate <NSObject>

@optional

#pragma mark - Sign In 

- (void)deviceSetupFlowController:(VLDSetupFlowViewController *)controller didSignIn:(NSString *)token;
- (void)deviceSetupFlowController:(VLDSetupFlowViewController *)controller didFailToSignIn:(NSError *)error;

#pragma mark - Device Registration

- (void)deviceSetupFlowControllerDidRegisterDevice:(VLDSetupFlowViewController *)controller;
- (void)deviceSetupFlowController:(VLDSetupFlowViewController *)controller didFailToRegisterDevice:(NSError *)error;
- (void)deviceSetupFlowControllerDidCancelRegistration:(VLDSetupFlowViewController *)controller;

#pragma mark - Pin Entry

- (void)deviceSetupFlowControllerPinEntryOnComplete:(VLDSetupFlowViewController *)controller;
- (void)deviceSetupFlowController:(VLDSetupFlowViewController *)controller pinEntryDidFail:(NSError *)error;
- (void)deviceSetupFlowControllerDidCancelPinEntry:(VLDSetupFlowViewController *)controller;

#pragma mark - Activation Creation

- (void)deviceSetupFlowControllerDidCreatePendingActivation:(VLDSetupFlowViewController *)controller;
- (void)deviceSetupFlowController:(VLDSetupFlowViewController *)controller didFailToCreatePendingActivation:(NSError *)error;

#pragma mark - Connect Me Activation

- (void)deviceSetupFlowControllerDidCompleteActivation:(VLDSetupFlowViewController *)controller;
- (void)deviceSetupFlowControllerDidFailActivation:(VLDSetupFlowViewController *)controller withError:(NSError *)error;

@end
