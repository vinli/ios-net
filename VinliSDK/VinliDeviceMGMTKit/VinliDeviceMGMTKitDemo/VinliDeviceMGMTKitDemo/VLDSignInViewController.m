//
//  VLDSignInViewController.m
//  VinliDeviceMGMTKitDemo
//
//  Created by Bryan on 3/2/17.
//  Copyright © 2017 vinli. All rights reserved.
//

#import "VLDSignInViewController.h"

#import <VinliDeviceMGMTKit/VLDSetupFlowViewController.h>

#import "VLDUsersDevicesViewController.h"

#import "VLDDemoManager.h"

@interface VLDSignInViewController () <VLDSetupFlowViewControllerDelegate>

@property (strong, nonatomic) NSString *accessToken;

@end

@implementation VLDSignInViewController

#pragma mark - Initializer

+ (instancetype)initFromStoryboardWithAccessToken:(NSString *)accessToken
{
    VLDSignInViewController *instance = [[UIStoryboard storyboardWithName:NSStringFromClass([VLDSignInViewController class]) bundle:nil] instantiateViewControllerWithIdentifier:NSStringFromClass([VLDSignInViewController class])];
    
    instance.accessToken = accessToken;
    
    return instance;
}

#pragma mark - Class Methods

- (void)vl_presentModalViewController:(UIViewController *)modalViewController
{
    UIViewController* rootViewController = [UIApplication sharedApplication].windows.firstObject.rootViewController;
    if (rootViewController.presentedViewController) {
        [rootViewController.presentedViewController presentViewController:modalViewController animated:YES completion:nil];
        return;
    }
    [[UIApplication sharedApplication].windows.firstObject.rootViewController presentViewController:modalViewController animated:YES completion:nil];
}


#pragma mark - View Controller Lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
}

#pragma mark - Actions

- (IBAction)signInButtonAction:(id)sender
{
    VLDSetupFlowViewController *setUpFlowViewController = self.accessToken.length > 0 ? [[VLDSetupFlowViewController alloc] initWithAccessToken:self.accessToken] : [[VLDSetupFlowViewController alloc] initWithClientId:@"53915419-4fa9-4be2-ae55-2b22ee4c51e1" redirectUri:@"test://test"];
    [setUpFlowViewController setFlowDelegate:self];
    [setUpFlowViewController setModalPresentationStyle:UIModalPresentationCurrentContext];
    
    [self presentViewController:setUpFlowViewController animated:YES completion:nil];
}

#pragma mark - VLDSetupFlowControllerDelegate

- (void)deviceSetupFlowController:(VLDSetupFlowViewController *)controller didSignIn:(NSString *)token
{
    NSLog(@"Token: %@", token);
    [[VLDDemoManager sharedManager] setAccessToken:token];
}

- (void)deviceSetupFlowController:(VLDSetupFlowViewController *)controller didFailToSignIn:(NSError *)error
{
    NSLog(@"Error: %@", error);
}

- (void)deviceSetupFlowControllerDidRegisterDevice:(VLDSetupFlowViewController *)controller
{
    NSLog(@"BOOOOM");
}

- (void)deviceSetupFlowController:(VLDSetupFlowViewController *)controller didFailToRegisterDevice:(NSError *)error
{
    NSLog(@"Failed to register device with error: %@", error);
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:NSLocalizedString(@"Device Registration Error", @"") message:error.code == 409 ? NSLocalizedString(@"The Case ID that you have entered seems to belong to a different account. Make sure you have entered to correct Case ID.", @"") : NSLocalizedString(@"There was error in trying to add this device to your account. Make sure you have entered to correct Case ID.", @"") preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *dismissAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"Dismiss", @"") style:UIAlertActionStyleCancel handler:nil];
    [alertController addAction:dismissAction];
    [controller presentViewController:alertController animated:YES completion:nil];
}

- (void)deviceSetupFlowControllerDidCancelRegistration:(VLDSetupFlowViewController *)controller
{
    NSLog(@"Did Cancel registration");
}

- (void)deviceSetupFlowControllerPinEntryOnComplete:(VLDSetupFlowViewController *)controller
{
    NSLog(@"Pin Creation delegate method called");
}

- (void)deviceSetupFlowController:(VLDSetupFlowViewController *)controller pinEntryDidFail:(NSError *)error
{
    NSLog(@"Pin Entry did fail with error %@", error);
}

- (void)deviceSetupFlowControllerDidCancelPinEntry:(VLDSetupFlowViewController *)controller
{
    NSLog(@"Did cancel Pin entry");
}

- (void)deviceSetupFlowControllerDidCreatePendingActivation:(VLDSetupFlowViewController *)controller
{
    NSLog(@"Did create pending activation");
}

- (void)deviceSetupFlowController:(VLDSetupFlowViewController *)controller didFailToCreatePendingActivation:(NSError *)error
{
    NSLog(@"Did fail to create pending activaiton with error %@", error);
}

- (void)deviceSetupFlowControllerDidCompleteActivation:(VLDSetupFlowViewController *)controller
{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Complete" message:@"We finished activation! Continue to Manage Wifi or Cancel Wifi." preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *action = [UIAlertAction actionWithTitle:@"Continue" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [controller dismissViewControllerAnimated:YES completion:^{
            VLDUsersDevicesViewController *usersDevicesVC = [VLDUsersDevicesViewController initFromStoryboard];
            UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:usersDevicesVC];
            [[VLDDemoManager sharedManager] setAppsRootViewController:navController];
        }];

    }];
    [alertController addAction:action];
    [controller presentViewController:alertController animated:YES completion:nil];
}


@end
