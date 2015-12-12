//
//  ViewController.m
//  VinliAuth
//
//  Created by Jai Ghanekar on 12/4/15.
//  Copyright © 2015 Jai Ghanekar. All rights reserved.
//

#import "ViewController.h"
#import <Foundation/Foundation.h>
#import <VinliNet/VinliSDK.h>
#import <UIKit/UIKit.h>
#import "ProfileViewController.h"

@implementation ViewController


#pragma mark - Public Static

+ (instancetype)initFromStoryboard
{
    ViewController* instance = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:NSStringFromClass(self.class)];
    return instance;
}



- (void)viewDidLoad
{
    [super viewDidLoad];
    
    UIColor *vinliColor = [[UIColor alloc]initWithRed:0/255.0f green:163.0f/255.0f blue:224.0f/255.0f alpha:1]; //divide by 255.0f
    
    self.view.backgroundColor = vinliColor;
    
    self.navigationController.navigationBar.hidden = YES;
    
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    
}

- (void)presentLoginViewController
{
    
    [[VLSessionManager sharedManager] loginWithCompletion:^(VLSession *session, NSError *error) {
        //handle login
        [self.logInButton setHidden:YES];
        [self performSegueWithIdentifier:@"showProfile" sender:self];
        
    } onCancel:^{
        // Handle your errors
    }];
}





- (IBAction)btnActionLogin:(id)sender {
    
    [self presentLoginViewController];
    
    
    

}


@end