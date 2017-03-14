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
    
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.navigationController.navigationBar.hidden = YES;
    UIColor *vinliColor = [[UIColor alloc]initWithRed:0/255.0f green:163.0f/255.0f blue:224.0f/255.0f alpha:1]; //divide by 255.0f
    self.logInButton.backgroundColor = vinliColor;

    
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
// - (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
//{
//    if ([segue.identifier isEqualToString:@"showProfile"])
//    {
//        UINavigationController *navController = segue.destinationViewController;
//        //[navController.navigationBar setTintColor:[UIColor clearColor]];
//        [navController.navigationBar setTranslucent:NO];
//    }
//}




- (IBAction)btnActionLogin:(id)sender {
    
    [self presentLoginViewController];
    
    
    

}


@end