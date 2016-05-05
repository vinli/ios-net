//
//  StreamViewController.m
//  ios-net-demo
//
//  Created by Tommy Brown on 4/28/16.
//  Copyright © 2016 Vinli. All rights reserved.
//

#import "StreamViewController.h"
#import "AppDelegate.h"

#define RPM_ROW 0
#define VEHICLE_SPEED_ROW 1
#define MASS_AIRFLOW_ROW 2
#define CALCULATED_ENGINE_LOAD_ROW 3
#define INTAKE_MANIFOLD_PRESSURE_ROW 4
#define ENGINE_COOLANT_TEMP_ROW 5
#define THROTTLE_POSITION_ROW 6
#define TIME_SINCE_ENGINE_START_ROW 7
#define FUEL_RAIL_PRESSURE_ROW 8
#define FUEL_PRESSURE_ROW 9
#define INTAKE_AIR_TEMP_ROW 10
#define TIMING_ADVANCE_ROW 11

#define DEFAULT_VALUE -101010101

@interface StreamViewController ()

@property (strong) VLStream *stream;
@property (strong, atomic) NSMutableDictionary *valueDictionary;
@property (strong) MKPointAnnotation *vehicleAnnotation;

@end

@implementation StreamViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    
    _mapView.userInteractionEnabled = NO;
    
    _valueDictionary = [[NSMutableDictionary alloc] init];
    _vehicleAnnotation = [[MKPointAnnotation alloc] init];
    
    NSArray *parameterArray = [NSArray arrayWithObject:[[VLParametricFilter alloc] initWithParameter:@"rpm"]];
    _stream = [_vlService getStreamForDeviceId:_device.deviceId parametricFilters:parameterArray geometryFilter:nil onMessageBlock:^(VLStreamMessage *streamMessage) {
        [self receivedMessage:streamMessage];
    } onErrorBlock:^(NSError *error) {
        NSLog(@"Error getting stream for device: %@", error.description);
    }];
}

- (void) viewWillDisappear:(BOOL)animated{
    [_stream disconnect];
    [super viewWillDisappear:animated];
}

- (void) receivedMessage:(VLStreamMessage *)message{
    NSMutableArray *reloadArray = [[NSMutableArray alloc] init];
    
    int rpm = [message integerForKey:@"rpm" defaultValue:DEFAULT_VALUE];
    if(rpm != DEFAULT_VALUE){
        NSLog(@"Updating rpm: %d", rpm);
        [_valueDictionary setObject:@(rpm) forKey:@"rpm"];
        [reloadArray addObject:[NSIndexPath indexPathForRow:RPM_ROW inSection:0]];
    }
    
    int vehicleSpeed = [message integerForKey:@"vehicleSpeed" defaultValue:DEFAULT_VALUE];
    if(vehicleSpeed != DEFAULT_VALUE){
        [_valueDictionary setObject:@(vehicleSpeed) forKey:@"vehicleSpeed"];
        [reloadArray addObject:[NSIndexPath indexPathForRow:VEHICLE_SPEED_ROW inSection:0]];
    }
    
    float massAirflow = [message floatForKey:@"massAirFlow" defaultValue:DEFAULT_VALUE];
    if(massAirflow != DEFAULT_VALUE){
        [_valueDictionary setObject:@(massAirflow) forKey:@"massAirFlow"];
        [reloadArray addObject:[NSIndexPath indexPathForRow:MASS_AIRFLOW_ROW inSection:0]];
    }
    
    float calculatedEngineLoad = [message floatForKey:@"calculatedLoadValue" defaultValue:DEFAULT_VALUE];
    if(calculatedEngineLoad != DEFAULT_VALUE){
        [_valueDictionary setObject:@(calculatedEngineLoad) forKey:@"calculatedLoadValue"];
        [reloadArray addObject:[NSIndexPath indexPathForRow:CALCULATED_ENGINE_LOAD_ROW inSection:0]];
    }
    
    int intakeManifoldPressure = [message integerForKey:@"intakeManifoldPressure" defaultValue:DEFAULT_VALUE];
    if(intakeManifoldPressure != DEFAULT_VALUE){
        [_valueDictionary setObject:@(intakeManifoldPressure) forKey:@"intakeManifoldPressure"];
        [reloadArray addObject:[NSIndexPath indexPathForRow:INTAKE_MANIFOLD_PRESSURE_ROW inSection:0]];
    }
    
    int engineCoolantTemp = [message integerForKey:@"coolantTemp" defaultValue:DEFAULT_VALUE];
    if(engineCoolantTemp != DEFAULT_VALUE){
        [_valueDictionary setObject:@(engineCoolantTemp) forKey:@"coolantTemp"];
        [reloadArray addObject:[NSIndexPath indexPathForRow:ENGINE_COOLANT_TEMP_ROW inSection:0]];
    }
    
    double throttlePosition = [message doubleForKey:@"absoluteThrottleSensorPosition" defaultValue:DEFAULT_VALUE];
    if(throttlePosition != DEFAULT_VALUE){
        [_valueDictionary setObject:@(throttlePosition) forKey:@"absoluteThrottleSensorPosition"];
        [reloadArray addObject:[NSIndexPath indexPathForRow:THROTTLE_POSITION_ROW inSection:0]];
    }
    
    int timeSinceEngineStart = [message integerForKey:@"runTimeSinceEngineStart" defaultValue:DEFAULT_VALUE];
    if(timeSinceEngineStart != DEFAULT_VALUE){
        [_valueDictionary setObject:@(timeSinceEngineStart) forKey:@"runTimeSinceEngineStart"];
        [reloadArray addObject:[NSIndexPath indexPathForRow:TIME_SINCE_ENGINE_START_ROW inSection:0]];
    }
    
    double fuelRailPressure = [message doubleForKey:@"fuelRailPressure" defaultValue:DEFAULT_VALUE];
    if(fuelRailPressure != DEFAULT_VALUE){
        [_valueDictionary setObject:@(fuelRailPressure) forKey:@"fuelRailPressure"];
        [reloadArray addObject:[NSIndexPath indexPathForRow:FUEL_RAIL_PRESSURE_ROW inSection:0]];
    }
    
    int fuelPressure = [message integerForKey:@"fuelPressure" defaultValue:DEFAULT_VALUE];
    if(fuelPressure != DEFAULT_VALUE){
        [_valueDictionary setObject:@(fuelPressure) forKey:@"fuelPressure"];
        [reloadArray addObject:[NSIndexPath indexPathForRow:FUEL_PRESSURE_ROW inSection:0]];
    }
    
    int intakeAirTemp = [message integerForKey:@"intakeAirTemperature" defaultValue:DEFAULT_VALUE];
    if(intakeAirTemp != DEFAULT_VALUE){
        [_valueDictionary setObject:@(intakeAirTemp) forKey:@"intakeAirTemperature"];
        [reloadArray addObject:[NSIndexPath indexPathForRow:INTAKE_AIR_TEMP_ROW inSection:0]];
    }
    
    double timingAdvance = [message doubleForKey:@"timingAdvance" defaultValue:DEFAULT_VALUE];
    if(timingAdvance != DEFAULT_VALUE){
        [_valueDictionary setObject:@(timingAdvance) forKey:@"timingAdvance"];
        [reloadArray addObject:[NSIndexPath indexPathForRow:TIMING_ADVANCE_ROW inSection:0]];
    }
    
    VLLocation *location = [message coord];
    if(location != nil){
        [self updateLocationWithLatitude:location.latitude longitude:location.longitude];
    }
    
    [_tableView reloadRowsAtIndexPaths:reloadArray withRowAnimation:UITableViewRowAnimationFade];
}

- (void) updateLocationWithLatitude:(double)latitude longitude:(double)longitude{
    CLLocationCoordinate2D coord2D = CLLocationCoordinate2DMake(latitude, longitude);
    _vehicleAnnotation.coordinate = coord2D;
    if([_mapView annotations].count == 0){
        _vehicleAnnotation.title = _device.name;
        [_mapView addAnnotation:_vehicleAnnotation];
    }
    [_mapView setRegion:MKCoordinateRegionMake(coord2D, MKCoordinateSpanMake(0.003, 0.003)) animated:YES];
}

#pragma mark - UITableViewDataSource

- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 12;
}

- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
    cell.textLabel.textColor = UIColorFromRGB(0x333F48);
    
    NSString *title = @"";
    NSString *value = @"";
    
    switch(indexPath.row){
        case RPM_ROW:
            title = @"RPM";
            value = ([_valueDictionary objectForKey:@"rpm"] == nil) ? @"" : [[_valueDictionary objectForKey:@"rpm"] stringValue];
            break;
        case VEHICLE_SPEED_ROW:
            title = @"Vehicle Speed";
            value = ([_valueDictionary objectForKey:@"vehicleSpeed"] == nil) ? @"" : [[_valueDictionary objectForKey:@"vehicleSpeed"] stringValue];
            break;
        case MASS_AIRFLOW_ROW:
            title = @"Mass Airflow";
            value = ([_valueDictionary objectForKey:@"massAirFlow"] == nil) ? @"" : [[_valueDictionary objectForKey:@"massAirFlow"] stringValue];
            break;
        case CALCULATED_ENGINE_LOAD_ROW:
            title = @"Calculated Load Value";
            value = ([_valueDictionary objectForKey:@"calculatedLoadValue"] == nil) ? @"" : [[_valueDictionary objectForKey:@"calculatedLoadValue"] stringValue];
            break;
        case INTAKE_MANIFOLD_PRESSURE_ROW:
            title = @"Intake Manifold Pressure";
            value = ([_valueDictionary objectForKey:@"intakeManifoldPressure"] == nil) ? @"" : [[_valueDictionary objectForKey:@"intakeManifoldPressure"] stringValue];
            break;
        case ENGINE_COOLANT_TEMP_ROW:
            title = @"Coolant Temperature";
            value = ([_valueDictionary objectForKey:@"coolantTemp"] == nil) ? @"" : [[_valueDictionary objectForKey:@"coolantTemp"] stringValue];
            break;
        case THROTTLE_POSITION_ROW:
            title = @"Throttle Position";
            value = ([_valueDictionary objectForKey:@"absoluteThrottleSensorPosition"] == nil) ? @"" : [[_valueDictionary objectForKey:@"absoluteThrottleSensorPosition"] stringValue];
            break;
        case TIME_SINCE_ENGINE_START_ROW:
            title = @"Time Since Engine Start";
            value = ([_valueDictionary objectForKey:@"runTimeSinceEngineStart"] == nil) ? @"" : [[_valueDictionary objectForKey:@"runTimeSinceEngineStart"] stringValue];
            break;
        case FUEL_RAIL_PRESSURE_ROW:
            title = @"Fuel Rail Pressure";
            value = ([_valueDictionary objectForKey:@"fuelRailPressure"] == nil) ? @"" : [[_valueDictionary objectForKey:@"fuelRailPressure"] stringValue];
            break;
        case FUEL_PRESSURE_ROW:
            title = @"Fuel Pressure";
            value = ([_valueDictionary objectForKey:@"fuelPressure"] == nil) ? @"" : [[_valueDictionary objectForKey:@"fuelPressure"] stringValue];
            break;
        case INTAKE_AIR_TEMP_ROW:
            title = @"Intake Air Temperature";
            value = ([_valueDictionary objectForKey:@"intakeAirTemperature"] == nil) ? @"" : [[_valueDictionary objectForKey:@"intakeAirTemperature"] stringValue];
            break;
        case TIMING_ADVANCE_ROW:
            title = @"Timing Advance";
            value = ([_valueDictionary objectForKey:@"timingAdvance"] == nil) ? @"" : [[_valueDictionary objectForKey:@"timingAdvance"] stringValue];
            break;
    }
    
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@ : %@", title, value]];
    [attributedString addAttribute:NSFontAttributeName value:[UIFont boldSystemFontOfSize:14.0f] range:NSMakeRange(0, title.length + 3)];
    [cell.textLabel setAttributedText:attributedString];
    
    return cell;
}

#pragma mark - UITableViewDelegate

- (BOOL) tableView:(UITableView *)tableView shouldHighlightRowAtIndexPath:(NSIndexPath *)indexPath{
    return NO;
}



@end
