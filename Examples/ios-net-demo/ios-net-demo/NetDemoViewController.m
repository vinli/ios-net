//
//  ViewController.m
//  ios-net-demo
//
//  Created by Tommy Brown on 4/26/16.
//  Copyright © 2016 Vinli. All rights reserved.
//

#import "NetDemoViewController.h"
#import "DeviceFooterView.h"
#import "StreamViewController.h"

#define ACCESS_TOKEN_KEY @"net_demo_access_token"

#define USER_SECTION 0
#define DEVICE_SECTION 1

#define DEVICE_NAME_ROW 0
#define LATEST_VEHICLE_ROW 1
#define LATEST_LOCATION_ROW 2
#define ODOMETER_ESTIMATE_ROW 3

#define MILES_PER_METER 0.00062137

@interface NetDemoViewController ()

@property (strong, nonatomic) VLUser *user;
@property (strong, nonatomic) NSArray *devices;
@property (strong, nonatomic) NSMutableDictionary *latestLocationMap;
@property (strong, nonatomic) NSMutableDictionary *latestVehicleMap;
@property (strong, nonatomic) NSMutableDictionary *odometerEstimateMap;

@end

@implementation NetDemoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _devices = [[NSArray alloc] init];
    _latestLocationMap = [[NSMutableDictionary alloc] init];
    _latestVehicleMap = [[NSMutableDictionary alloc] init];
    _odometerEstimateMap = [[NSMutableDictionary alloc] init];
}

- (void) viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
    NSString *accessToken = [self accessToken];
    if(accessToken != nil){
        self.vlService = [[VLService alloc] initWithSession:[[VLSession alloc] initWithAccessToken:accessToken]];
        [self fetchData];
    }else{
        [self beginLoginFlow];
    }
}

- (NSString *) accessToken{
    return [[NSUserDefaults standardUserDefaults] objectForKey:ACCESS_TOKEN_KEY];
}

- (void) beginLoginFlow{
    [self clearCookies];
    VLLoginViewController *loginViewController = [[VLLoginViewController alloc] init];
    loginViewController.clientId = CLIENT_ID;
    loginViewController.redirectUri = REDIRECT_URI;
    loginViewController.delegate = self;
    [self presentViewController:loginViewController animated:YES completion:nil];
}

- (void) loggedInWithSession:(VLSession *)session{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setObject:session.accessToken forKey:ACCESS_TOKEN_KEY];
    [userDefaults synchronize];
}

- (void) fetchData{
    [self.vlService getUserOnSuccess:^(VLUser *user, NSHTTPURLResponse *response) {
        [self setUser:user];
    } onFailure:^(NSError *error, NSHTTPURLResponse *response, NSString *bodyString) {
        NSLog(@"Error fetching user data: %@", bodyString);
    }];
    
    [self.vlService getDevicesOnSuccess:^(VLDevicePager *devicePager, NSHTTPURLResponse *response) {
        [self setDevices:devicePager.devices];
        for(int i = 0; i < devicePager.devices.count; i++){
            [self fetchDeviceData:[devicePager.devices objectAtIndex:i] section:(i + 1)];
        }
    } onFailure:^(NSError *error, NSHTTPURLResponse *response, NSString *bodyString) {
        NSLog(@"Error fetching devices: %@", bodyString);
    }];
}

- (void) fetchDeviceData:(VLDevice *)device section:(int)section{
    
    [_vlService getLatestVehicleForDeviceWithId:device.deviceId onSuccess:^(VLVehicle *vehicle, NSHTTPURLResponse *response) {
        
        if(vehicle != nil){
            [_latestVehicleMap setObject:vehicle forKey:device.deviceId];
            
            [self fetchOdometerData:vehicle section:section deviceId:device.deviceId];
            
            [self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:LATEST_VEHICLE_ROW inSection:section]] withRowAnimation:UITableViewRowAnimationFade];
        }
        
    } onFailure:^(NSError *error, NSHTTPURLResponse *response, NSString *bodyString) {
        NSLog(@"Error fetching latest vehicle: %@", bodyString);
    }];
    
    [_vlService getLocationsForDeviceWithId:device.deviceId limit:@1 until:nil since:nil sortDirection:nil onSuccess:^(VLLocationPager *locationPager, NSHTTPURLResponse *response) {
        
        if(locationPager.locations.count > 0){
            [_latestLocationMap setObject:locationPager.locations.firstObject forKey:device.deviceId];
            
            [self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:LATEST_LOCATION_ROW inSection:section]] withRowAnimation:UITableViewRowAnimationFade];
        }
        
    } onFailure:^(NSError *error, NSHTTPURLResponse *response, NSString *bodyString) {
        NSLog(@"Error fetching latest location: %@", bodyString);
    }];
}

- (void) fetchOdometerData:(VLVehicle *)vehicle section:(int)section deviceId:(NSString *)deviceId{
    [_vlService getDistancesForVehicleWithId:vehicle.vehicleId onSuccess:^(VLDistancePager *distancePager, NSHTTPURLResponse *response) {
        
        if(distancePager.distances.count > 0){
            [_odometerEstimateMap setObject:distancePager.distances.firstObject forKey:deviceId];
            
            [self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:ODOMETER_ESTIMATE_ROW inSection:section]] withRowAnimation:UITableViewRowAnimationFade];
        }
        
    } onFailure:^(NSError *error, NSHTTPURLResponse *response, NSString *bodyString) {
        NSLog(@"Error fetching distances: %@", bodyString);
    }];
}

- (void) logout{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setObject:nil forKey:ACCESS_TOKEN_KEY];
    [userDefaults synchronize];
    
    self.vlService = nil;
    _user = nil;
    [self beginLoginFlow];
}

- (void) setUser:(VLUser *)user{
    _user = user;
    [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationNone];
}

- (void) setDevices:(NSArray *)devices{
    _devices = devices;
    [_latestLocationMap removeAllObjects];
    [_latestVehicleMap removeAllObjects];
    [_odometerEstimateMap removeAllObjects];
    [self.tableView reloadData];
}

#pragma mark - Actions

- (IBAction) refreshButtonPressed:(id)sender{
    [self fetchData];
}

- (IBAction) logoutButtonPressed:(id)sender{
    [self logout];
}

- (IBAction) setOdometerButtonPressed:(id)sender{
    
}

- (IBAction) streamButtonPressed:(id)sender{
    UIButton *streamButton = (UIButton *) sender;
    StreamViewController *streamViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"StreamViewController"];
    streamViewController.device = [_devices objectAtIndex:(streamButton.tag - 1)];
    [self.navigationController pushViewController:streamViewController animated:YES];
}

#pragma mark - UITableViewDataSource

- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView{
    return _devices.count + 1;
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    int numRows = 0;
    if(section == USER_SECTION){
        numRows = 4;
    }else{
        numRows = 4;
    }
    return numRows;
}

- (NSString *) tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    NSString *title = @"";
    switch(section){
        case USER_SECTION:
            title = @"User";
            break;
        case DEVICE_SECTION:
            title = @"Devices";
            break;
    }
    return title;
}

- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
    
    NSString *title = @"";
    NSString *value = @"";
    
    if(indexPath.section == USER_SECTION){
        
        switch(indexPath.row){
            case 0:
                title = @"First Name : ";
                value = (_user != nil) ? _user.firstName : @"";
                break;
            case 1:
                title = @"Last Name : ";
                value = (_user != nil) ? _user.lastName : @"";
                break;
            case 2:
                title = @"Email : ";
                value = (_user != nil) ? _user.email : @"";
                break;
            case 3:
                title = @"Phone : ";
                value = (_user != nil) ? _user.phone : @"";
                break;
        }
    }else{
        VLDevice *device = [_devices objectAtIndex:(indexPath.section - 1)];
        
        switch(indexPath.row){
            case DEVICE_NAME_ROW:{
                title = @"Device Name : ";
                value = (device != nil) ? device.name : @"";
                break;
            }case LATEST_VEHICLE_ROW:{
                VLVehicle *vehicle = (VLVehicle *) [_latestVehicleMap objectForKey:device.deviceId];
                title = @"Latest Vehicle : ";
                value = (vehicle == nil) ? @"None" : [self vehicleDescription:vehicle];
                break;
            }case LATEST_LOCATION_ROW:{
                VLLocation *location = (VLLocation *) [_latestLocationMap objectForKey:device.deviceId];
                title = @"Latest Location : ";
                value = (location == nil) ? @"None" : [NSString stringWithFormat:@"%f, %f", location.latitude, location.longitude];
                break;
            }case ODOMETER_ESTIMATE_ROW:{
                VLDistance *distance = (VLDistance *)[_odometerEstimateMap objectForKey:device.deviceId];
                title = @"Odometer Estimate : ";
                value = (distance == nil) ? @"None" : [NSString stringWithFormat:@"%.2f miles", (distance.value.doubleValue * MILES_PER_METER)];
                break;
            }
        }
    }
    
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@%@", title, value]];
    [attributedString addAttribute:NSFontAttributeName value:[UIFont boldSystemFontOfSize:14.0f] range:NSMakeRange(0, title.length)];
    [cell.textLabel setAttributedText:attributedString];
    
    return cell;
}

- (CGFloat) tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return (section == USER_SECTION) ? 0 : 50;
}

- (UIView *) tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    
    if(section == USER_SECTION){
        return nil;
    }
    
    CGRect frame = CGRectMake(0, 0, self.tableView.frame.size.width, [self tableView:self.tableView heightForFooterInSection:section]);
    DeviceFooterView *footerView = [[DeviceFooterView alloc] initWithSection:(int)section frame:frame];
    [footerView.setOdometerButton addTarget:self action:@selector(setOdometerButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    [footerView.streamButton addTarget:self action:@selector(streamButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    return footerView;
}

#pragma mark - UITableViewDelegate

- (BOOL) tableView:(UITableView *)tableView shouldHighlightRowAtIndexPath:(NSIndexPath *)indexPath{
    return NO;
}

#pragma mark - VLLoginViewControllerDelegate

- (void)vlLoginViewController:(VLLoginViewController *)loginController didLoginWithSession:(VLSession *)session{
    [self loggedInWithSession:session];
}

- (void)vlLoginViewController:(VLLoginViewController *)loginController didFailToLoginWithError:(NSError *)error{
    NSLog(@"Failed to login, %@", error);
}

#pragma mark - Misc

- (void) clearCookies{
    [[NSURLCache sharedURLCache] removeAllCachedResponses];
    for (NSHTTPCookie *cookie in [[NSHTTPCookieStorage sharedHTTPCookieStorage] cookies]) {
        [[NSHTTPCookieStorage sharedHTTPCookieStorage] deleteCookie:cookie];
    }
}

- (NSString *) vehicleDescription:(VLVehicle *)vehicle{
    if(vehicle == nil){
        return @"None";
    }
    
    NSString *description = [[NSString stringWithFormat:@"%@ %@ %@", vehicle.year, vehicle.make, vehicle.model] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    
    if(description.length == 0 || (vehicle.year == nil && vehicle.make == nil && vehicle.model == nil)){
        description = @"Unnamed Vehicle";
    }
    
    return description;
}

@end
