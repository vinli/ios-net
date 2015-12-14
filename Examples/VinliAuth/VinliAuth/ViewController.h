//
//  ViewController.h
//  VinliAuth
//
//  Created by Jai Ghanekar on 12/4/15.
//  Copyright © 2015 Jai Ghanekar. All rights reserved.
//


#import <UIKit/UIKit.h>
#import <VinliNet/VinliSDK.h>

@class ViewController;

@protocol ViewControllerDelegate <NSObject>

-(void)loginViewControllerDidLogin:(ViewController *)loginViewController;

@end

@interface ViewController : UIViewController <VLLoginViewControllerDelegate>

@property (weak, nonatomic) IBOutlet UIButton *logInButton;

@property (weak, nonatomic) id <ViewControllerDelegate> delegate;

- (IBAction)btnActionLogin:(id)sender;


+(instancetype) initFromStoryBoard;

@end
