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
//@protocol VLLoginCompletionDelegate;


@interface VLLoginViewController : UIViewController <UIWebViewDelegate>

@property (nonatomic, weak) id<VLLoginViewControllerDelegate> delegate;
//@property (nonatomic, weak) id <VLLoginCompletionDelegate> loginDelegate;
@property NSString *clientId;
@property NSString *redirectUri;
@property NSString *host;

- (id) initWithClientId: (NSString *) clientId redirectUri: (NSString *) redirectUri;
- (id) initWithClientId: (NSString *) clientId redirectUri: (NSString *) redirectUri host:(NSString *)host;

@end

@protocol VLLoginViewControllerDelegate <NSObject>

@required
- (void) vlLoginViewController:(VLLoginViewController *)loginController didLoginWithSession:(VLSession *) session;
- (void) vlLoginViewController:(VLLoginViewController *)loginController didFailToLoginWithError:(NSError *) error;

@end


//@protocol VLLoginCompletionDelegate <NSObject>
//
//@required
//- (void)successfullLogin:(void(^)(void))onSuccessBlock onFailure:(void(^)(NSError *error))onFailureBlock;
//@end