//
//  VLDConnectMeViewController.h
//  VinliDeviceMGMTKit
//
//  Created by Bryan on 2/28/17.
//  Copyright © 2017 vinli. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "VLDConnectMeViewControllerDelegate.h"

typedef NS_ENUM(NSInteger, ConnectMeWebViewType)
{
    ConnectMeWebViewActivateWifi,
    ConnectMeWebViewManageWifi,
    ConnectMeWebViewCancelWifi
};

@interface VLDConnectMeViewController : UIViewController

@property (assign, readonly, nonatomic) ConnectMeWebViewType type;
@property (weak, nonatomic) id<VLDConnectMeViewControllerDelegate> connectMeDelegate;

+ (instancetype)initFromStoryboardWithDeviceId:(NSString *)deviceId accessToken:(NSString *)accessToken connectMeType:(ConnectMeWebViewType)type;

@end
