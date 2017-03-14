//
//  VLDDemoManager.h
//  VinliDeviceMGMTKitDemo
//
//  Created by Bryan on 3/2/17.
//  Copyright © 2017 vinli. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <UIKit/UIWindow.h>

extern NSString * const VLDDidCancelWifiForADeviceNotification;

@class VLDevicePager;
@interface VLDDemoManager : NSObject

@property (strong, nonatomic) NSString *accessToken;
@property (strong, nonatomic) NSString *deviceId;

@property (strong, nonatomic) UIWindow *window;

#pragma mark - Class Methods

+ (instancetype)sharedManager;

- (void)setAppsRootViewController:(UIViewController *)viewController;

- (void)getDevicesOnCompletion:(void(^)(VLDevicePager *pager, NSError *error))completion;

@end
