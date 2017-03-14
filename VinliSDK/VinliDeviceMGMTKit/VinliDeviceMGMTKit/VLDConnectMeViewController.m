//
//  VLDConnectMeViewController.m
//  VinliDeviceMGMTKit
//
//  Created by Bryan on 2/28/17.
//  Copyright © 2017 vinli. All rights reserved.
//

#import "VLDConnectMeViewController.h"
#import "VLDConnectMeViewController_ActivationCreation.h"

#import "VLService+Private.h"

#import "UIViewController+VLStyleAdditions.h"

NSString * const kMyVinliURLString = @"my.vin.li";
NSString * const kMyVinliSetupCompleteURLString = @"setup-complete";

@interface VLDConnectMeViewController () <UIWebViewDelegate>

@property (weak, nonatomic) IBOutlet UIWebView *webView;

@property (assign, readwrite, nonatomic) ConnectMeWebViewType type;

@property (strong, nonatomic) NSString *accessToken;
@property (strong, nonatomic) NSString *deviceId;
@property (strong, nonatomic) VLService *service;

@property (strong, nonatomic) NSURL *connectMeURL;

@end

@implementation VLDConnectMeViewController

#pragma mark - Class Methods

+ (instancetype)initFromStoryboardWithActivationURL:(NSURL *)activationURL
{
    VLDConnectMeViewController *instance = [[UIStoryboard storyboardWithName:@"VLDConnectMeViewController" bundle:[NSBundle bundleForClass:[VLDConnectMeViewController class]]] instantiateViewControllerWithIdentifier:NSStringFromClass([VLDConnectMeViewController class])];
        
    instance.type = ConnectMeWebViewActivateWifi;
    instance.connectMeURL = activationURL;
    
    return instance;
}

+ (instancetype)initFromStoryboardWithDeviceId:(NSString *)deviceId accessToken:(NSString *)accessToken connectMeType:(ConnectMeWebViewType)type
{
    VLDConnectMeViewController *instance = [[UIStoryboard storyboardWithName:@"VLDConnectMeViewController" bundle:[NSBundle bundleForClass:[VLDConnectMeViewController class]]] instantiateViewControllerWithIdentifier:NSStringFromClass([VLDConnectMeViewController class])];
    
    instance.accessToken = accessToken;
    instance.service = [[VLService alloc] initWithAccessToken:instance.accessToken];
    
    instance.deviceId = deviceId;
    instance.type = type;
    
    return instance;
}

#pragma mark - View Controller Lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    NSString *title = nil;
    switch (self.type) {
        case ConnectMeWebViewActivateWifi:
        {
            title = NSLocalizedString(@"ACTIVATE WIFI", @"");
            break;
        }
        case ConnectMeWebViewManageWifi:
        {
            title = NSLocalizedString(@"MANAGE WIFI", @"");
            break;
        }
        case ConnectMeWebViewCancelWifi:
        {
            title = NSLocalizedString(@"CANCEL WIFI", @"");
            break;
        }
        default:
            break;
    }
    
    [self setTitleText:title];
    
    [self.webView setDelegate:self];
    
    if (self.connectMeURL && self.type == ConnectMeWebViewActivateWifi) {
        [self.webView loadRequest:[NSURLRequest requestWithURL:self.connectMeURL]];
    }
    else
    {
        switch (self.type) {
            case ConnectMeWebViewActivateWifi:
            {
                break;
            }
            case ConnectMeWebViewManageWifi:
            {
                weakify(self)
                [self getExternalLinkForManageWifi:^(NSURL *manageWifiURL, NSError *error) {
                    strongify(self)
                    if (error) {
                        if ([self.connectMeDelegate respondsToSelector:@selector(connectMeViewController:didFail:)])
                        {
                            [self.connectMeDelegate connectMeViewController:self didFail:error];
                        }
                        return;
                    }
                    
                    self.connectMeURL = manageWifiURL;
                    [self.webView loadRequest:[NSURLRequest requestWithURL:self.connectMeURL]];
                }];
                break;
            }
            case ConnectMeWebViewCancelWifi:
            {
                weakify(self)
                [self getExternalLinkForCancelation:^(NSURL *cancelationURL, NSError *error) {
                   
                    strongify(self)
                    if (error) {
                        if ([self.connectMeDelegate respondsToSelector:@selector(connectMeViewController:didFail:)])
                        {
                            [self.connectMeDelegate connectMeViewController:self didFail:error];
                        }
                        return;
                    }
                    
                    self.connectMeURL = cancelationURL;
                    [self.webView loadRequest:[NSURLRequest requestWithURL:self.connectMeURL]];
                    
                }];
                break;
            }
            default:
                break;
        }
    }
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self.navigationItem setHidesBackButton:YES];
}

#pragma mark - Network Calls

- (void)getExternalLinkForCancelation:(void(^)(NSURL *cancelationURL, NSError *error))completion
{
    [self.service getExternalLinkForCancelWifiWithDeviceId:self.deviceId success:^(NSDictionary *externalLinkDict, NSHTTPURLResponse *response) {
        if (externalLinkDict)
        {
            NSString *deletionExternalLinkStr = externalLinkDict[@"externalLink"][@"link"];
            
            NSURL *deletionURL = [NSURL URLWithString:deletionExternalLinkStr];
            if (completion) {
                completion(deletionURL, nil);
            }
        }

    } failure:^(NSError *error, NSHTTPURLResponse *response, NSString *bodyString) {
        if (completion) {
            completion(nil, error);
        }
    }];
}

- (void)getExternalLinkForManageWifi:(void(^)(NSURL *manageWifiURL, NSError *error))completion
{
    [self.service getExternalLinkForWifiManagementWithDeviceId:self.deviceId success:^(NSDictionary *externalLinkDict, NSHTTPURLResponse *response) {
        if (externalLinkDict)
        {
            NSString *manageWifiExternalLinkStr = externalLinkDict[@"externalLink"][@"link"];
            
            NSURL *manageWifiURL = [NSURL URLWithString:manageWifiExternalLinkStr];
            if (completion) {
                completion(manageWifiURL, nil);
            }
        }
    } failure:^(NSError *error, NSHTTPURLResponse *response, NSString *bodyString) {
        if (completion) {
            completion(nil, error);
        }
    }];
}

#pragma mark - UIWebViewDelegate

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    if ([request.URL.absoluteString containsString:kMyVinliURLString] || [request.URL.absoluteString containsString:kMyVinliSetupCompleteURLString])
    {
        if (self.type == ConnectMeWebViewActivateWifi)
        {
            if ([self.activationCompletionDelegate respondsToSelector:@selector(connectMeViewControllerDidCompleteActivation:)])
            {
                [self.activationCompletionDelegate connectMeViewControllerDidCompleteActivation:self];
            }
            return NO;
        }
                
        if ([self.connectMeDelegate respondsToSelector:@selector(connectMeViewControllerDidComplete:)])
        {
            [self.connectMeDelegate connectMeViewControllerDidComplete:self];
        }
        
        return NO;
    }
    
    return YES;
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{    
    if (self.type == ConnectMeWebViewActivateWifi && !self.service && !self.accessToken)
    {
        if ([self.activationCompletionDelegate respondsToSelector:@selector(connectMeViewController:didFailActivationWithError:)])
        {
            [self.activationCompletionDelegate connectMeViewController:self didFailActivationWithError:error];
        }
        return;
    }
    
    if ([self.connectMeDelegate respondsToSelector:@selector(connectMeViewController:didFail:)])
    {
        [self.connectMeDelegate connectMeViewController:self didFail:error];
    }
}

- (void)webViewDidStartLoad:(UIWebView *)webView
{
    
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    
}

@end
