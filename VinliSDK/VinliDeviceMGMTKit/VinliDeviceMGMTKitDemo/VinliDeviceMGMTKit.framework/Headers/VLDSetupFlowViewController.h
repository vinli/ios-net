//
//  VLDSetupFlowViewController.h
//  VinliDeviceMGMTKit
//
//  Created by Bryan on 2/21/17.
//  Copyright © 2017 vinli. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "VLDSetupFlowViewControllerDelegate.h"

@interface VLDSetupFlowViewController : UINavigationController

@property (weak, nonatomic) id<VLDSetupFlowViewControllerDelegate> flowDelegate;

#pragma mark - Class Methods

- (instancetype)initWithClientId:(NSString *)clientId redirectUri:(NSString *)redirectUri;
- (instancetype)initWithAccessToken:(NSString *)accessToken;

@end
