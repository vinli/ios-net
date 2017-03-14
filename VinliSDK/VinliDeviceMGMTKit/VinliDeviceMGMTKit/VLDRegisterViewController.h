//
//  VLDRegisterViewController.h
//  VinliDeviceMGMTKit
//
//  Created by Bryan on 2/21/17.
//  Copyright © 2017 vinli. All rights reserved.
//

#import <UIKit/UIKit.h>

@class VLDevice;
@protocol VLDRegisterViewControllerDelegate <NSObject>

@optional
- (void)didRegisterDeviceWithCaseId:(NSString *)caseId;
- (void)didFailToRegisterDevice:(NSError *)error;
- (void)didCancelRegistration;

@end

@interface VLDRegisterViewController : UIViewController

@property (weak, nonatomic) id<VLDRegisterViewControllerDelegate> delegate;

#pragma - Class Methods

+ (instancetype)initFromStoryboard;
+ (instancetype)initFromStoryboardWithAccessToken:(NSString *)accessToken;

@end
