//
//  VLLoginViewController.h
//  VinliSDK
//
//  Created by Tommy Brown on 5/27/15.
//  Copyright (c) 2015 Vinli. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "VLSession.h"

@protocol VLLoginViewControllerDelegate;

@interface VLLoginViewController : UIViewController <UIWebViewDelegate>

@property (nonatomic, weak) id<VLLoginViewControllerDelegate> delegate;
@property NSString *clientId;
@property NSString *redirectUri;
@property NSString *host;

- (instancetype)initWithClientId:(NSString *)clientId redirectUri:(NSString *)redirectUri;
- (instancetype)initWithClientId:(NSString *)clientId redirectUri:(NSString *)redirectUri host:(NSString *)host;

@end

@protocol VLLoginViewControllerDelegate <NSObject>

@required
- (void)vlLoginViewController:(VLLoginViewController *)loginController didLoginWithSession:(VLSession *) session;
- (void)vlLoginViewController:(VLLoginViewController *)loginController didFailToLoginWithError:(NSError *) error;

@optional
- (void)vlLoginViewControllerDidCancelLogin:(VLLoginViewController *)loginController;

@end
