//
//  VLDConnectMeViewControllerDelegate.h
//  VinliDeviceMGMTKit
//
//  Created by Bryan on 2/28/17.
//  Copyright © 2017 vinli. All rights reserved.
//

#import <Foundation/Foundation.h>

@class VLDConnectMeViewController;
@protocol VLDConnectMeViewControllerDelegate <NSObject>

@optional
- (void)connectMeViewControllerDidComplete:(VLDConnectMeViewController *)viewController;
- (void)connectMeViewControllerDidCancel:(VLDConnectMeViewController *)viewController;
- (void)connectMeViewController:(VLDConnectMeViewController *)viewController didFail:(NSError *)error;

@end
