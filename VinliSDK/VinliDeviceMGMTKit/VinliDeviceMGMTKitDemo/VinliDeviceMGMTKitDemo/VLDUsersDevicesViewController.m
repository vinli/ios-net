//
//  VLDUsersDevicesViewController.m
//  VinliDeviceMGMTKitDemo
//
//  Created by Bryan on 3/2/17.
//  Copyright © 2017 vinli. All rights reserved.
//

#import "VLDUsersDevicesViewController.h"

#import "VLDDemoManager.h"

#import <VinliSDK/VLDevicePager.h>

#import "VLDManageCancelWifiViewController.h"

@interface VLDUsersDevicesViewController () <UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (strong, nonatomic) VLDevicePager *devicePager;

@end

@implementation VLDUsersDevicesViewController

#pragma mark - Initalizer

+ (instancetype)initFromStoryboard
{
    VLDUsersDevicesViewController *instance = [[UIStoryboard storyboardWithName:NSStringFromClass([VLDUsersDevicesViewController class]) bundle:nil] instantiateViewControllerWithIdentifier:NSStringFromClass([VLDUsersDevicesViewController class])];

    [instance getUsersDevices];
    
    [[NSNotificationCenter defaultCenter] addObserver:instance selector:@selector(getUsersDevices) name:VLDDidCancelWifiForADeviceNotification object:nil];
    
    return instance;
}

- (void)getUsersDevices
{
    [[VLDDemoManager sharedManager] getDevicesOnCompletion:^(VLDevicePager *pager, NSError *error) {
        
        if (error) {
            NSLog(@"Failed to get device pager with error: %@", error);
            return;
        }
        
        if (pager) {
            self.devicePager = pager;
            [self.tableView reloadData];
        }
        
        [self.tableView setHidden:NO];
        
    }];
}

#pragma mark - View Controller

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self.tableView setDelegate:self];
    [self.tableView setDataSource:self];
    [self.tableView setHidden:YES];
    [self.tableView setTableFooterView:[UIView new]];
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.devicePager.devices.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    VLDevice *device = self.devicePager.devices[indexPath.row];
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    [cell.textLabel setText:device.name];
    
    return cell;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    VLDevice *device = self.devicePager.devices[indexPath.row];
    
    VLDManageCancelWifiViewController *manageCancelWifiVC = [VLDManageCancelWifiViewController initFromStoryboardWithDevice:device];
    [self.navigationController pushViewController:manageCancelWifiVC animated:YES];
}

@end
