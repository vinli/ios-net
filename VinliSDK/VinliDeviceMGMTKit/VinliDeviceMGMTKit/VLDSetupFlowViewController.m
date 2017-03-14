//
//  VLDSetupFlowViewController.m
//  VinliDeviceMGMTKit
//
//  Created by Bryan on 2/21/17.
//  Copyright © 2017 vinli. All rights reserved.
//

#import "VLDSetupFlowViewController.h"

#import <VinliSDK/VLLoginViewController.h>
#import "VLDRegisterViewController.h"
#import "VLDPinCreationViewController.h"
#import "VLDConnectMeViewController.h"
#import "VLDConnectMeViewController_ActivationCreation.h"
#import "VLDActivationCreationViewController.h"

#import "VLDFontManager.h"

#import "UIColor+VLAdditions.h"

@interface VLDSetupFlowViewController () <VLLoginViewControllerDelegate, VLDRegisterViewControllerDelegate, VLDPinCreationViewControllerDelegate, VLDActivationCreationViewControllerDelegate, VLDConnectMeViewController_ActivationCreationDelegate>

@property (strong, nonatomic) NSString *clientId;
@property (strong, nonatomic) NSString *redirectUri;

@property (strong, nonatomic) NSString *accessToken;

@end

@implementation VLDSetupFlowViewController

#pragma mark - Class Methods

- (instancetype)initWithClientId:(NSString *)clientId redirectUri:(NSString *)redirectUri
{
    if (self = [super init])
    {
        [VLDFontManager load];
        
        self.clientId = clientId;
        self.redirectUri = redirectUri;
    }
    
    return self;
}

- (instancetype)initWithAccessToken:(NSString *)accessToken
{
    if (self = [super init])
    {
        [VLDFontManager load];
        
        self.accessToken = accessToken;
    }
    
    return self;
}

#pragma mark - View Controller Lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Configure UI
    [self.navigationBar setBarTintColor:[UIColor vl_PrimaryUIElementsColor]];
    [self.navigationBar setTranslucent:NO];
    self.navigationBar.tintColor = [UIColor whiteColor];
    
    // Initial View Controller
    NSMutableArray *viewControllers = [NSMutableArray new];
    if (self.clientId.length > 0 && self.redirectUri.length > 0 && self.accessToken.length == 0) {
        VLLoginViewController *loginVC = [[VLLoginViewController alloc] initWithClientId:self.clientId redirectUri:self.redirectUri];
        [loginVC setDelegate:self];
        [viewControllers addObject:loginVC];
    }
    else
    {
        VLDRegisterViewController *registerVC = [VLDRegisterViewController initFromStoryboardWithAccessToken:self.accessToken];
        [registerVC setDelegate:self];
        [viewControllers addObject:registerVC];
    }
    
    self.viewControllers = viewControllers;
}

#pragma mark - VLLoginViewControllerDelegate

- (void)vlLoginViewController:(VLLoginViewController *)loginController didLoginWithSession:(VLSession *)session
{
    if ([self.flowDelegate respondsToSelector:@selector(deviceSetupFlowController:didSignIn:)])
    {
        [self.flowDelegate deviceSetupFlowController:self didSignIn:session.accessToken];
        
        self.accessToken = session.accessToken;
        
        VLDRegisterViewController *registerVC = [VLDRegisterViewController initFromStoryboardWithAccessToken:self.accessToken];
        [registerVC setDelegate:self];
        [self pushViewController:registerVC animated:YES];
    }
}

- (void)vlLoginViewController:(VLLoginViewController *)loginController didFailToLoginWithError:(NSError *)error
{
    if ([self.flowDelegate respondsToSelector:@selector(deviceSetupFlowController:didFailToSignIn:)])
    {
        [self.flowDelegate deviceSetupFlowController:self didFailToSignIn:error];
    }
}

#pragma mark - VLDRegisterViewController

- (void)didRegisterDeviceWithCaseId:(NSString *)caseId
{
    if ([self.flowDelegate respondsToSelector:@selector(deviceSetupFlowControllerDidRegisterDevice:)])
    {
        [self.flowDelegate deviceSetupFlowControllerDidRegisterDevice:self];
        
        VLDPinCreationViewController *pinCreationVC = [VLDPinCreationViewController initFromStoryboardWithAccessToken:self.accessToken andCaseId:caseId];
        [pinCreationVC setDelegate:self];
        [self pushViewController:pinCreationVC animated:YES];
    }
}

- (void)didFailToRegisterDevice:(NSError *)error
{
    if ([self.flowDelegate respondsToSelector:@selector(deviceSetupFlowController:didFailToRegisterDevice:)])
    {
        [self.flowDelegate deviceSetupFlowController:self didFailToRegisterDevice:error];
    }
}

- (void)didCancelRegistration
{
    if ([self.flowDelegate respondsToSelector:@selector(deviceSetupFlowControllerDidCancelRegistration:)])
    {
        [self.flowDelegate deviceSetupFlowControllerDidCancelRegistration:self];
    }
}

#pragma mark - VLDPinCreationViewController

- (void)pinEntryWasSuccessfulWithPin:(NSString *)pin andCaseId:(NSString *)caseId
{
    if ([self.flowDelegate respondsToSelector:@selector(deviceSetupFlowControllerPinEntryOnComplete:)])
    {
        [self.flowDelegate deviceSetupFlowControllerPinEntryOnComplete:self];
        VLDActivationCreationViewController *activationCreationVC = [VLDActivationCreationViewController initFromStoryboardWithAccessToken:self.accessToken caseId:caseId andPin:pin];
        [activationCreationVC setDelegate:self];
        [self pushViewController:activationCreationVC animated:YES];
    }
}

- (void)pinEntryDidFail:(NSError *)error
{
    if ([self.flowDelegate respondsToSelector:@selector(deviceSetupFlowController:pinEntryDidFail:)])
    {
        [self.flowDelegate deviceSetupFlowController:self pinEntryDidFail:error];
    }
}

- (void)didCancelPinEntry
{
    if ([self.flowDelegate respondsToSelector:@selector(deviceSetupFlowControllerDidCancelPinEntry:)])
    {
        [self.flowDelegate deviceSetupFlowControllerDidCancelPinEntry:self];
    }
}

#pragma mark - VLDActivationCreationViewController

- (void)didCreateActivationWithURL:(NSURL *)activationURL
{
    if ([self.flowDelegate respondsToSelector:@selector(deviceSetupFlowControllerDidCreatePendingActivation:)])
    {
        [self.flowDelegate deviceSetupFlowControllerDidCreatePendingActivation:self];
        VLDConnectMeViewController *connectMeActivationVC = [VLDConnectMeViewController initFromStoryboardWithActivationURL:activationURL];
        [connectMeActivationVC setActivationCompletionDelegate:self];
        [self pushViewController:connectMeActivationVC animated:YES];
    }
}

- (void)didFailToCreateActivationWithError:(NSError *)error
{
    if ([self.flowDelegate respondsToSelector:@selector(deviceSetupFlowController:didFailToCreatePendingActivation:)])
    {
        [self.flowDelegate deviceSetupFlowController:self didFailToCreatePendingActivation:error];
    }
}

#pragma mark - VLDConnectMeViewController 

- (void)connectMeViewControllerDidCompleteActivation:(VLDConnectMeViewController *)viewController
{
    if ([self.flowDelegate respondsToSelector:@selector(deviceSetupFlowControllerDidCompleteActivation:)])
    {
        [self.flowDelegate deviceSetupFlowControllerDidCompleteActivation:self];
    }
}

- (void)connectMeViewController:(VLDConnectMeViewController *)viewController didFailActivationWithError:(NSError *)error
{
    if ([self.flowDelegate respondsToSelector:@selector(deviceSetupFlowControllerDidFailActivation:withError:)])
    {
        [self.flowDelegate deviceSetupFlowControllerDidFailActivation:self withError:error];
    }
}

@end
