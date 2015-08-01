//
//  VLDevicePicker.h
//  VinliSDK
//
//  Created by Andrew Wells on 8/1/15.
//  Copyright (c) 2015 Vinli. All rights reserved.
//

#import <UIKit/UIKit.h>

@class VLDevicePickerViewController;
@class VLDevice;

@protocol VLDevicePickerViewControllerDelegate <NSObject>

- (void)devicePicker:(VLDevicePickerViewController *)devicePicker didSelectDevice:(VLDevice *)device;

@end

@interface VLDevicePickerViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) id <VLDevicePickerViewControllerDelegate> delegate;

@property (strong, nonatomic) NSArray* devices;


- (IBAction)onDoneButton:(id)sender;

+ (instancetype)instantiate;
+ (instancetype)instantiateAndPresentDevicePickerWithTarget:(UIViewController *)target
                                                   delegate:(id<VLDevicePickerViewControllerDelegate>)delegate
                                                    devices:(NSArray *)devices;

@end

