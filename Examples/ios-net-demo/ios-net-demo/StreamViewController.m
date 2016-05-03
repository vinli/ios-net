//
//  StreamViewController.m
//  ios-net-demo
//
//  Created by Tommy Brown on 4/28/16.
//  Copyright © 2016 Vinli. All rights reserved.
//

#import "StreamViewController.h"

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

@end

@implementation StreamViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    
    _valueDictionary = [[NSMutableDictionary alloc] init];
    
    NSArray *parameterArray = [NSArray arrayWithObject:[[VLParametricFilter alloc] initWithParameter:@"rpm"]];
    _stream = [_vlService getStreamForDeviceId:_device.deviceId parametricFilters:parameterArray geometryFilter:nil onMessageBlock:^(VLStreamMessage *streamMessage) {
        [self receivedMessage:streamMessage];
    } onErrorBlock:^(NSError *error) {
        NSLog(@"Error getting stream for device: %@", error.description);
    }];
}

- (void) viewWillDisappear:(BOOL)animated{
    
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
    
    float massAirflow = [message integerForKey:@"massAirFlow" defaultValue:DEFAULT_VALUE];
    if(massAirflow != DEFAULT_VALUE){
        [_valueDictionary setObject:@(massAirflow) forKey:@"massAirFlow"];
        [reloadArray addObject:[NSIndexPath indexPathForRow:MASS_AIRFLOW_ROW inSection:0]];
    }
    
    [_tableView reloadRowsAtIndexPaths:reloadArray withRowAnimation:UITableViewRowAnimationFade];
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
    
    NSString *title = @"";
    NSString *value = @"";
    
    switch(indexPath.row){
        case RPM_ROW:
            title = @"RPM";
            value = [[_valueDictionary objectForKey:@"rpm"] stringValue];
            break;
        case VEHICLE_SPEED_ROW:
            title = @"Vehicle Speed";
            value = [[_valueDictionary objectForKey:@"vehicleSpeed"] stringValue];
            break;
        case MASS_AIRFLOW_ROW:
            title = @"Mass Airflow";
            value = [[_valueDictionary objectForKey:@"massAirFlow"] stringValue];
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
