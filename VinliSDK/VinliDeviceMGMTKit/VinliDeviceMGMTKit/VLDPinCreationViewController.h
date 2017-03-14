//
//  VLDPinCreationViewController.h
//  VinliDeviceMGMTKit
//
//  Created by Bryan on 2/28/17.
//  Copyright © 2017 vinli. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol VLDPinCreationViewControllerDelegate <NSObject>

@optional
- (void)pinEntryWasSuccessfulWithPin:(NSString *)pin andCaseId:(NSString *)caseId;
- (void)pinEntryDidFail:(NSError *)error;
- (void)didCancelPinEntry;

@end

@interface VLDPinCreationViewController : UIViewController

@property (weak, nonatomic) id<VLDPinCreationViewControllerDelegate> delegate;

#pragma mark - Class Methods

+ (instancetype)initFromStoryboard;
+ (instancetype)initFromStoryboardWithAccessToken:(NSString *)accessToken andCaseId:(NSString *)caseId;

@end
