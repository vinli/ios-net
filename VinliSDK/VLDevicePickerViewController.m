//
//  VLDevicePicker.m
//  VinliSDK
//
//  Created by Andrew Wells on 8/1/15.
//  Copyright (c) 2015 Vinli. All rights reserved.
//

#import "VLDevicePickerViewController.h"
#import "VLDevice.h"

@interface VLDevicePickerViewController ()
@end

@implementation VLDevicePickerViewController

#pragma mark - LifeCycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.tableFooterView = [UIView new];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    if (self.devices.count == 0)
    {
        return;
    }
    
    NSIndexPath* firstCell = [NSIndexPath indexPathForRow:0 inSection:0];
    
    UITableViewCell* cell = [self.tableView cellForRowAtIndexPath:firstCell];
    cell.accessoryType = UITableViewCellAccessoryCheckmark;
    
    
     [self.tableView selectRowAtIndexPath:firstCell animated:NO scrollPosition:UITableViewScrollPositionNone];
}

#pragma mark - Tableview DataSource Methods

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.devices.count;
}

#pragma mark - Tableview Delegate Methods

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"VLDevicePickerCell"];
    
    
    VLDevice* device = self.devices[indexPath.row];
    cell.textLabel.text = device.name;
    cell.detailTextLabel.text = device.deviceId;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger cellCount = [tableView numberOfRowsInSection:indexPath.section];
    for (int i = 0; i < cellCount; i++)
    {
        NSIndexPath *cellIndexPath = [NSIndexPath indexPathForRow:i inSection:indexPath.section];
        UITableViewCell* cell = [tableView cellForRowAtIndexPath:cellIndexPath];
        
        if ([cellIndexPath isEqual:indexPath])
        {
             [cell setAccessoryType:UITableViewCellAccessoryCheckmark];
        }
        else
        {
             [cell setAccessoryType:UITableViewCellAccessoryNone];
        }
    }
}

- (IBAction)onDoneButton:(id)sender
{
    if ([self.delegate respondsToSelector:@selector(devicePicker:didSelectDevice:)])
    {
        NSIndexPath* selectedIndexPath = [self.tableView indexPathForSelectedRow];
        VLDevice* device = self.devices[selectedIndexPath.row];
        [self.delegate devicePicker:self didSelectDevice:device];
    }
}

#pragma mark - Class Methods

+ (instancetype)instantiate
{
    VLDevicePickerViewController* devicePicker = [[UIStoryboard storyboardWithName:@"Vinli" bundle:nil] instantiateViewControllerWithIdentifier:NSStringFromClass([self class])];
    return devicePicker;
}

+ (instancetype)instantiateAndPresentDevicePickerWithTarget:(UIViewController *)target
                                                   delegate:(id<VLDevicePickerViewControllerDelegate>)delegate
                                                    devices:(NSArray *)devices
{
    VLDevicePickerViewController* devicePicker = [VLDevicePickerViewController instantiate];
    devicePicker.delegate = delegate;
    devicePicker.devices = devices;
    
    /*
     ios7:
     presentingVC.modalPresentationStyle = UIModalPresentationCurrentContext;
     
     
     ios8:
     modalVC.modalPresentationStyle = UIModalPresentationOverCurrentContext;
     modalVC.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
     
     and then in both:
     [presentingVC presentViewController:modalVC animated:YES completion:nil];
     */
    
    devicePicker.modalPresentationStyle = UIModalPresentationOverCurrentContext;
    devicePicker.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    
    [UIView animateWithDuration:0.5 animations:^{
        [target presentViewController:devicePicker animated:YES completion:nil];
    }];
    
    return devicePicker;
}




@end
