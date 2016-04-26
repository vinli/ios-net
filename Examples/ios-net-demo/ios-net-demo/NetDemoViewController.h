//
//  ViewController.h
//  ios-net-demo
//
//  Created by Tommy Brown on 4/26/16.
//  Copyright © 2016 Vinli. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <VinliSDK.h>
#import "Secrets.h"

@interface NetDemoViewController : UIViewController <VLLoginViewControllerDelegate>

@property (strong, nonatomic) VLService *vlService;

- (IBAction) refreshButtonPressed:(id)sender;
- (IBAction) logoutButtonPressed:(id)sender;

@end

