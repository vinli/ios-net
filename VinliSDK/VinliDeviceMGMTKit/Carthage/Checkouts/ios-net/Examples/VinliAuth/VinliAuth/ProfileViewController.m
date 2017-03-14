//
//  ProfileViewController.m
//  VinliAuth
//
//  Created by Jai Ghanekar on 12/7/15.
//  Copyright © 2015 Jai Ghanekar. All rights reserved.
//

#import "ProfileViewController.h"
#import "DeviceViewController.h"
#import <Foundation/Foundation.h>
#import <VinliNet/VinliSDK.h>


@interface MyCustomCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *thumbNail;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;

@end



@interface ProfileViewController ()

@property (strong, nonatomic) NSArray *deviceArray;


@end

@implementation ProfileViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    UIColor *grayColor = [[UIColor alloc]initWithRed:244.0f/255.0f green:244.0f/255.0f blue:244.0f/255.0f alpha:1]; //divide by 255.0f
    self.view.backgroundColor = grayColor;
    
    self.tableView.backgroundColor = grayColor;
    self.tableView.tableFooterView = [UIView new];
    
   // [self.profileImageView setHidden:YES];
    [self.fullNameLabel setHidden:YES];
    [self.phoneNumberLabel setHidden:YES];
    [self.emailLabel setHidden:YES];
    [self.emailText setHidden:YES];
    [self.phoneLabel setHidden:YES];
    
    self.tableView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
   
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    //[self.tableView reloadData];
    
    
    
    [[VLSessionManager sharedManager].service getDevicesOnSuccess:^(VLDevicePager *devicePager, NSHTTPURLResponse *response) {
        
        self.deviceArray = devicePager.devices;
        
        //needs to be changed
        [self.tableView reloadData];
        
        
    } onFailure:^(NSError *error, NSHTTPURLResponse *response, NSString *bodyString) {
        //
    }]; 
    UIColor *vinliColor = [[UIColor alloc]initWithRed:0/255.0f green:163.0f/255.0f blue:224.0f/255.0f alpha:1]; //divide by 255.0f
    self.navigationController.navigationBar.backgroundColor = vinliColor;
    self.navigationController.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName : [UIColor whiteColor]};
    //[self.navigationController.navigationBar setTranslucent:NO];
    //[self.navigationController.navigationBar setOpaque:YES];
    //self.navigationController.navigationBar.tintColor = [UIColor clearColor];
    [[UINavigationBar appearance] setBarStyle:UIBarStyleDefault];
    [[UINavigationBar appearance] setBarTintColor:vinliColor];
    [self.navigationController.navigationBar setTranslucent:NO];
    
    
}


- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    
    [[VLSessionManager sharedManager].service getUserOnSuccess:^(VLUser *user, NSHTTPURLResponse *response) {
    
        //Text information
        
        //self.fullNameLabel.text = [NSString stringWithFormat:@"%@ %@", user.firstName, user.lastName];
        self.navigationController.navigationBar.topItem.title = [NSString stringWithFormat:@"%@ %@", user.firstName, user.lastName];
        

        self.phoneNumberLabel.text = [NSString stringWithFormat:@"%@", user.phone];
        
        self.emailLabel.text = [NSString stringWithFormat:@"%@", user.email];
        
      
        //[self.fullNameLabel setHidden:NO];
        [self.phoneNumberLabel setHidden:NO];
        [self.emailLabel setHidden:NO];
        
        [self.emailText setHidden:NO];
        [self.phoneLabel setHidden:NO];

        
    } onFailure:^(NSError *error, NSHTTPURLResponse *response, NSString *bodyString) {
        
    }];
    
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:( NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    DeviceViewController *deviceViewController = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:NSStringFromClass([DeviceViewController class])];
    deviceViewController.currentDevice = self.deviceArray[indexPath.row];
    [self.navigationController pushViewController:deviceViewController animated:YES];
    //[self performSegueWithIdentifier:@"deviceCell" sender:self];
    
    
}





- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.deviceArray.count;
}


- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return @"Devices registered to user";
}


- (UIView *) tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.bounds.size.width, 30)];
    [headerView setBackgroundColor:[UIColor clearColor]];
    return headerView;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *MyIdentifier = @"MyCustomCell";
    
    
    MyCustomCell *cell = [tableView dequeueReusableCellWithIdentifier:MyIdentifier];
    if (!cell) {
        cell = [[MyCustomCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:MyIdentifier];
    }
    
    VLDevice* device = self.deviceArray[indexPath.row];
    cell.nameLabel.text = device.name;
    
    if (device.iconURL)
    {
        
        UIImage *picture = [UIImage imageWithData:[NSData dataWithContentsOfURL:device.iconURL]];
        cell.thumbNail.image = picture;
        
        
    }
    
    cell.backgroundColor = [UIColor whiteColor];
    
    return cell;
}

@end

@implementation MyCustomCell

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    self.thumbNail.layer.cornerRadius = self.thumbNail.frame.size.width / 2;
    [self.thumbNail setClipsToBounds:YES];
    self.thumbNail.layer.borderWidth = 1.0f;
    // really light grey
    UIColor *lightGrayColor = [[UIColor alloc]initWithRed:225.0f/255.0f green:211.0f/255.0f blue:193.0f/255.0f alpha:1]; //divide by 255.0f
    self.thumbNail.layer.borderColor = [lightGrayColor CGColor];
}

@end
