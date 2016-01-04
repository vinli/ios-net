//
//  ProfileViewController.h
//  VinliAuth
//
//  Created by Jai Ghanekar on 12/7/15.
//  Copyright © 2015 Jai Ghanekar. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <VinliNet/VinliSDK.h>
#import "DeviceViewController.h"




@interface ProfileViewController : UIViewController<UITableViewDelegate, UITableViewDataSource>
//@property (strong, nonatomic) IBOutlet UIImageView *profileImageView;

@property (weak, nonatomic) IBOutlet UILabel *fullNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *phoneNumberLabel;
@property (weak, nonatomic) IBOutlet UILabel *emailLabel;
@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UILabel *phoneLabel;
@property (weak, nonatomic) IBOutlet UILabel *emailText;

+ (instancetype)initFromStoryboard;

@end
