//
//  VLDActivationCreationViewController.h
//  VinliDeviceMGMTKit
//
//  Created by Bryan on 3/1/17.
//  Copyright © 2017 vinli. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol VLDActivationCreationViewControllerDelegate <NSObject>

@optional
- (void)didCreateActivationWithURL:(NSURL *)activationURL;
- (void)didFailToCreateActivationWithError:(NSError *)error;

@end

@interface VLDActivationCreationViewController : UIViewController

@property (weak, nonatomic) id<VLDActivationCreationViewControllerDelegate> delegate;

#pragma mark - Class Methods

+ (instancetype)initFromStoryboardWithAccessToken:(NSString *)accessToken caseId:(NSString *)caseId andPin:(NSString *)pin;

@end
