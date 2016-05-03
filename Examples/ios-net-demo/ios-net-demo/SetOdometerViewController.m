//
//  SetOdometerViewController.m
//  ios-net-demo
//
//  Created by Tommy Brown on 4/28/16.
//  Copyright © 2016 Vinli. All rights reserved.
//

#import "SetOdometerViewController.h"

#define MILES 0
#define KILOMETERS 1
#define METERS 2

@interface SetOdometerViewController ()

@property VLDistanceUnit distanceUnit;

@end

@implementation SetOdometerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _unitPicker.delegate = self;
    _unitPicker.dataSource = self;
    [_unitPicker selectRow:KILOMETERS inComponent:0 animated:NO];
    
    _setOdometerButton.clipsToBounds = NO;
    _setOdometerButton.layer.cornerRadius = 4;
    [_setOdometerButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
    [_textField becomeFirstResponder];
}

#pragma mark - Actions

- (IBAction) setOdometerButtonPressed:(id)sender{
    NSLog(@"Value: %@ %d", [_textField text], _distanceUnit);
    return;
    VLOdometer *odometer = [[VLOdometer alloc] initWithReading:@([[_textField text] doubleValue]) dateStr:nil unit:_distanceUnit];
    [_vlService createOdometer:odometer vehicleId:_vehicle.vehicleId OnSuccess:^(VLOdometer *odometer, NSHTTPURLResponse *response) {
        
    } onFailure:^(NSError *error, NSHTTPURLResponse *response, NSString *bodyString) {
        NSLog(@"Error creating odometer");
    }];
}

#pragma mark - UIPickerViewDataSource

- (NSInteger) numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 1;
}

- (NSInteger) pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    return 3;
}

#pragma mark - UIPickerViewDelegate

- (UIView *) pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view{
    UITextView *textView = (UITextView *) view;
    if(view == nil){
        textView = [[UITextView alloc] init];
    }
    
    NSString *rowText = @"";
    
    switch(row){
        case MILES:
            rowText = @"miles";
            break;
        case KILOMETERS:
            rowText = @"kilometers";
            break;
        case METERS:
            rowText = @"meters";
            break;
    }
    
    textView.text = rowText;
    
    return textView;
}

- (void) pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    switch(row){
        case MILES:
            _distanceUnit = VLDistanceUnitMiles;
            break;
        case KILOMETERS:
            _distanceUnit = VLDistanceUnitKilometers;
            break;
        case METERS:
            _distanceUnit = VLDistanceUnitMeters;
            break;
    }
}

@end
