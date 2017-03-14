//
//  VLDActivationCreationViewController.m
//  VinliDeviceMGMTKit
//
//  Created by Bryan on 3/1/17.
//  Copyright © 2017 vinli. All rights reserved.
//

#import "VLDActivationCreationViewController.h"

#import "VLActionButton.h"

#import "UIViewController+VLStyleAdditions.h"

#import "VLService+Private.h"

#import "UIFont+VLAdditions.h"
#import "UIColor+VLAdditions.h"

#import "VLActivityIndicatorView.h"

@interface VLDActivationCreationViewController ()

@property (weak, nonatomic) IBOutlet UILabel *activationTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *activationDetailLabel;

@property (weak, nonatomic) IBOutlet VLActionButton *createTMobAccountActionButton;

@property (strong, nonatomic) NSString *accessToken;
@property (strong, nonatomic) VLService *service;

@property (strong, nonatomic) NSString *pin;
@property (strong, nonatomic) NSString *caseId;

@end

@implementation VLDActivationCreationViewController

#pragma mark - Class Methods

+ (instancetype)initFromStoryboardWithAccessToken:(NSString *)accessToken caseId:(NSString *)caseId andPin:(NSString *)pin
{
    VLDActivationCreationViewController *instance = [[UIStoryboard storyboardWithName:@"VLDActivationCreationViewController" bundle:[NSBundle bundleForClass:[VLDActivationCreationViewController class]]] instantiateViewControllerWithIdentifier:NSStringFromClass([VLDActivationCreationViewController class])];
    
    instance.caseId = caseId;
    instance.pin = pin;
    
    instance.accessToken = accessToken;
    instance.service = [[VLService alloc] initWithAccessToken:instance.accessToken];
    
    return instance;
}

- (void)createActivationURL:(void(^)(NSURL *activationURL, NSError *error))completion
{
    if (self.pin.length == 0 || self.caseId.length == 0)
    {
        if (completion)
        {
            completion(nil, nil);
        }
        return;
    }
    
    [self.service activateDeviceWithCaseId:self.caseId pin:self.pin success:^(NSDictionary *activationDict, NSHTTPURLResponse *response) {
        NSURL* activationURL;
        NSError* error;
        if ([activationDict[@"externalLink"][@"link"] isKindOfClass:[NSString class]])
        {
            activationURL = [NSURL URLWithString:activationDict[@"externalLink"][@"link"]];
        }
        else
        {
            error = [NSError errorWithDomain:@"VinliUnexpectedResult" code:-101 userInfo:@{@"message" : @"No external link was returned"}];
        }
        
        if (completion) { completion(activationURL, error); }
    } failure:^(NSError *error, NSHTTPURLResponse *response, NSString *bodyString) {
        if (completion) { completion(nil, error); }
    }];
}


#pragma mark - View Controller Lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self.navigationItem setHidesBackButton:YES];
    
    [self setTitleText:NSLocalizedString(@"ACTIVATION REQUIRED", @"#bc-ignore!")];
    
    self.activationTitleLabel.font = [UIFont vl_OpenSans_Bold:17.0f];
    self.activationTitleLabel.textColor = [UIColor vl_DarkGreyColor];
    self.activationTitleLabel.text = NSLocalizedString(@"You're Almost There", @"#bc-ignore!");
    self.activationDetailLabel.text = NSLocalizedString(@"Next, activate your device on the T-Mobile network. And check out the optional high-speed internet data plans available. Otherwise, just click \"No, thanks\" and you'll be ready to roll.", @"#bc-ignore!");
    [self.activationDetailLabel setFont:[UIFont vl_OpenSans:15.0f]];
    [self.activationDetailLabel setNumberOfLines:0];
    [self.activationDetailLabel setLineBreakMode:NSLineBreakByWordWrapping];
    
    [self.createTMobAccountActionButton setTitle:NSLocalizedString(@"LET'S GO TO ACTIVATION", @"#bc-ignore!") forState:UIControlStateNormal];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self.navigationItem setHidesBackButton:YES];
}

#pragma mark - Actions

- (IBAction)createTMobAccountAction:(id)sender
{
    VLActivityIndicatorView *activityIndicatorView = [[VLActivityIndicatorView alloc] init];
    [activityIndicatorView addActivityIndicatorToView:self.view];
    weakify(self)
    [self createActivationURL:^(NSURL *activationURL, NSError *error) {
        [activityIndicatorView removeActivityIndicatorFromSuperView];
        strongify(self)
        if (error)
        {
            if ([self.delegate respondsToSelector:@selector(didFailToCreateActivationWithError:)])
            {
                [self.delegate didFailToCreateActivationWithError:error];
            }
            return;
        }
        
        if ([self.delegate respondsToSelector:@selector(didCreateActivationWithURL:)])
        {
            [self.delegate didCreateActivationWithURL:activationURL];
        }
    }];
}

@end
