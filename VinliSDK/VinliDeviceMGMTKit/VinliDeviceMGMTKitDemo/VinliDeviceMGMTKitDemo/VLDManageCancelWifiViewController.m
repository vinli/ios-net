//
//  VLDManageCancelWifiViewController.m
//  VinliDeviceMGMTKitDemo
//
//  Created by Bryan on 3/2/17.
//  Copyright © 2017 vinli. All rights reserved.
//

#import "VLDManageCancelWifiViewController.h"

#import "VLDDemoManager.h"
#import <VinliDeviceMGMTKit/VLDConnectMeViewController.h>
#import <VinliSDK/VLDevice.h>

@interface VLDManageCancelWifiViewController () <VLDConnectMeViewControllerDelegate>

@property (strong, nonatomic) VLDevice *device;

@end

@implementation VLDManageCancelWifiViewController

#pragma mark - Initializer

+ (instancetype)initFromStoryboardWithDevice:(VLDevice *)device
{
    VLDManageCancelWifiViewController *instance = [[UIStoryboard storyboardWithName:NSStringFromClass([VLDManageCancelWifiViewController class]) bundle:nil] instantiateViewControllerWithIdentifier:NSStringFromClass([VLDManageCancelWifiViewController class])];
    
    instance.device = device;
    
    return instance;
}

#pragma mark - View Controller Lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
}

#pragma mark - Actions

- (IBAction)manageWifiButtonAction:(id)sender
{
    VLDConnectMeViewController *connectMeViewController = [VLDConnectMeViewController initFromStoryboardWithDeviceId:self.device.deviceId accessToken:[[VLDDemoManager sharedManager] accessToken] connectMeType:ConnectMeWebViewManageWifi];
    [connectMeViewController setConnectMeDelegate:self];
    [self.navigationController pushViewController:connectMeViewController animated:YES];
}

- (IBAction)cancelWifiButtonAction:(id)sender
{
    VLDConnectMeViewController *connectMeViewController = [VLDConnectMeViewController initFromStoryboardWithDeviceId:self.device.deviceId accessToken:[[VLDDemoManager sharedManager] accessToken] connectMeType:ConnectMeWebViewCancelWifi];
    [connectMeViewController setConnectMeDelegate:self];
    [self.navigationController pushViewController:connectMeViewController animated:YES];
}

#pragma mark - VLDConnectMeViewControllerDelegate

- (void)connectMeViewControllerDidComplete:(VLDConnectMeViewController *)viewController
{
    [[NSNotificationCenter defaultCenter] postNotificationName:VLDDidCancelWifiForADeviceNotification object:nil];
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Complete" message:@"We finished activation! Continue to Manage Wifi or Cancel Wifi." preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *action = [UIAlertAction actionWithTitle:@"Continue" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        [self.navigationController popToRootViewControllerAnimated:YES];
    }];
    [alertController addAction:action];
    [viewController presentViewController:alertController animated:YES completion:nil];
}

- (void)connectMeViewController:(VLDConnectMeViewController *)viewController didFail:(NSError *)error
{
    
}

- (void)connectMeViewControllerDidCancel:(VLDConnectMeViewController *)viewController
{
    
}

@end
