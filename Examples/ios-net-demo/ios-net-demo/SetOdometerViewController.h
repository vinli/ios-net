//
//  SetOdometerViewController.h
//  ios-net-demo
//
//  Created by Tommy Brown on 4/28/16.
//  Copyright © 2016 Vinli. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <VinliSDK.h>

@interface SetOdometerViewController : UIViewController <UIPickerViewDelegate, UIPickerViewDataSource>

@property (strong, nonatomic) VLVehicle *vehicle;
@property (strong, nonatomic) VLService *vlService;
@property (weak, nonatomic) IBOutlet UITextField *textField;
@property (weak, nonatomic) IBOutlet UIPickerView *unitPicker;
@property (weak, nonatomic) IBOutlet UIButton *setOdometerButton;

- (IBAction) setOdometerButtonPressed:(id)sender;

@end
