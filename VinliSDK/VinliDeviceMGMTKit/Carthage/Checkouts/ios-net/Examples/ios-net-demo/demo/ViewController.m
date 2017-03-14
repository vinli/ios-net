
#import "ViewController.h"
#import "Secrets.h"

#define USER_SECTION 0

#define FIRST_NAME_ROW 0
#define LAST_NAME_ROW 1
#define EMAIL_ROW 2
#define PHONE_ROW 3

#define DEVICE_NAME_ROW 0
#define LATEST_VEHICLE_ROW 1
#define LATEST_LOCATION_ROW 2
#define STREAM_ROW 3

#define DEFAULT_VALUE -10101

@interface ViewController ()

@property (strong, nonatomic) NSMutableArray<VLDevice *> *deviceList;
@property (strong, nonatomic) VLUser *user;
@property (strong, nonatomic) NSMutableDictionary<NSString *, VLVehicle *> *latestVehicleMap;
@property (strong, nonatomic) NSMutableDictionary<NSString *, VLLocation *> *latestLocationMap;
@property (strong, nonatomic) VLStream *stream;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationController.navigationBar.translucent = NO;
    self.title = @"Vinli Net Demo";
    
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"LogOut" style:UIBarButtonItemStyleDone target:self action:@selector(logoutButtonPressed:)];
}

- (void) viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    // If we are already logged in, we can create a VLService and continue with the app.
    if([VLSessionManager loggedIn]){
        _vlService = [[VLService alloc] initWithSession:[VLSessionManager currentSession]];
        [self fetchUserAndDevices];
    }else{ // If we aren't logged in, we need to login.
        [self loginWithVinli];
    }
}

- (void) viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    // Stop the stream if our view controller disappears.
    [self stopStream];
}

- (void) resetDataStructures{
    _deviceList = [[NSMutableArray alloc] init];
    _user = nil;
    _latestVehicleMap = [[NSMutableDictionary alloc] init];
    _latestLocationMap = [[NSMutableDictionary alloc] init];
}

- (void) loginWithVinli{
    // Clear cookies before calling loginWithClientId
    [self clearCookies];
    
    // This will launch the Vinli login flow.
    [VLSessionManager loginWithClientId:CLIENT_ID // Get your app client id at dev.vin.li
                            redirectUri:REDIRECT_URI // Get your app redirect uri at dev.vin.li
                             completion:^(VLSession * _Nullable session, NSError * _Nullable error) { // Called if the user successfully logs in, or if there is an error
        if(!error){
            NSLog(@"Logged in successfully");
        }else{
            NSLog(@"Error logging in: %@", [error localizedDescription]);
        }
    } onCancel:^{ // Called if the user presses the 'Cancel' button
        NSLog(@"Canceled login");
    }];
}

- (void) fetchUserAndDevices{
    [self resetDataStructures];
    
    // Get the current user logged in with Vinli
    [_vlService getUserOnSuccess:^(VLUser *user, NSHTTPURLResponse *response) {
        _user = user;
        [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationFade];
    } onFailure:^(NSError *error, NSHTTPURLResponse *response, NSString *bodyString) {
        NSLog(@"Error fetching user: %@", bodyString);
    }];
    
    // Get the first page of the user's devices.
    [_vlService getDevicesOnSuccess:^(VLDevicePager *devicePager, NSHTTPURLResponse *response) {
        [_deviceList addObjectsFromArray:devicePager.devices];
        [self.tableView reloadData];
        [self fetchLatestVehicles];
        [self fetchLatestLocations];
    } onFailure:^(NSError *error, NSHTTPURLResponse *response, NSString *bodyString) {
        NSLog(@"Error fetching devices: %@", bodyString);
    }];
}

// We want the latest vehicle for each device.
- (void) fetchLatestVehicles{
    for(int i = 0; i < _deviceList.count; i++){
        VLDevice *device = [_deviceList objectAtIndex:i];
        [_vlService getLatestVehicleForDeviceWithId:device.deviceId onSuccess:^(VLVehicle *vehicle, NSHTTPURLResponse *response) {
            if(vehicle != nil){
                [_latestVehicleMap setObject:vehicle forKey:device.deviceId];
                [self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:LATEST_VEHICLE_ROW inSection:(i + 1)]] withRowAnimation:UITableViewRowAnimationFade];
            }
        } onFailure:^(NSError *error, NSHTTPURLResponse *response, NSString *bodyString) {
            NSLog(@"Error getting latest vehicle for device %@: %@", device.deviceId, bodyString);
        }];
    }
}

// We want the latest location for each device.
- (void) fetchLatestLocations{
    for(int i = 0; i < _deviceList.count; i++){
        VLDevice *device = [_deviceList objectAtIndex:i];
        // We set limit to be 1 since we only want the most recent location
        [_vlService getLocationsForDeviceWithId:device.deviceId limit:@1 until:nil since:nil sortDirection:nil onSuccess:^(VLLocationPager *locationPager, NSHTTPURLResponse *response) {
            if(locationPager.locations.count > 0){
                [_latestLocationMap setObject:locationPager.locations.firstObject forKey:device.deviceId];
                [self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:LATEST_LOCATION_ROW inSection:(i + 1)]] withRowAnimation:UITableViewRowAnimationFade];
            }
        } onFailure:^(NSError *error, NSHTTPURLResponse *response, NSString *bodyString) {
            NSLog(@"Error getting latest location for device %@: %@", device.deviceId, bodyString);
        }];
    }
}

- (void) stopStream{
    if(_stream != nil){
        [_stream disconnect];
        _stream = nil;
    }
}

#pragma mark - Actions

- (IBAction) logoutButtonPressed:(id)sender{
    [self resetDataStructures];
    [self.tableView reloadData];
    // Simply call this to clear out the user's Vinli session.
    [VLSessionManager logOut];
    // Need to have the user relogin if they log out
    [self loginWithVinli];
}

#pragma mark - UITableViewDataSource

- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView{
    return 1 + ((_deviceList != nil) ? _deviceList.count : 0);
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 4;
}

- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SimpleCell"];
    if(cell == nil){
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"SimpleCell"];
    }
    
    NSString *label = @"";
    NSString *value = @"";
    
    if(indexPath.section == USER_SECTION){
        switch(indexPath.row){
            case FIRST_NAME_ROW:
                label = @"First Name";
                value = (_user == nil) ? @"" : _user.firstName;
                break;
            case LAST_NAME_ROW:
                label = @"Last Name";
                value = (_user == nil) ? @"" : _user.lastName;
                break;
            case EMAIL_ROW:
                label = @"Email";
                value = (_user == nil) ? @"" : _user.email;
                break;
            case PHONE_ROW:
                label = @"Phone";
                value = (_user == nil) ? @"" : _user.phone;
                break;
        }
    }else{
        VLDevice *device = [_deviceList objectAtIndex:(indexPath.section - 1)];
        VLVehicle *vehicle = [_latestVehicleMap objectForKey:device.deviceId];
        VLLocation *location = [_latestLocationMap objectForKey:device.deviceId];
        
        switch(indexPath.row){
            case DEVICE_NAME_ROW:
                label = @"Device Name";
                value = device.name;
                break;
            case LATEST_VEHICLE_ROW:
                label = @"Latest Vehicle";
                value = (vehicle != nil) ? vehicle.vin : @"None";
                break;
            case LATEST_LOCATION_ROW:
                label = @"Latest Location";
                value = (location != nil) ? [NSString stringWithFormat:@"%f, %f", location.latitude, location.longitude] : @"None";
                break;
            case STREAM_ROW:
                label = @"Press here to stream this device";
                break;
        }
    }
    
    cell.textLabel.text = (indexPath.section != USER_SECTION && indexPath.row == STREAM_ROW) ? label : [NSString stringWithFormat:@"%@ : %@", label, value];
    
    return cell;
}

#pragma mark - UITableViewDelegate

- (BOOL) tableView:(UITableView *)tableView shouldHighlightRowAtIndexPath:(NSIndexPath *)indexPath{
    return (indexPath.section != USER_SECTION && indexPath.row == STREAM_ROW);
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if(indexPath.row == STREAM_ROW){
        
        // Only need to have 1 stream around at a time, so kill the previous one if its running
        [self stopStream];
        
        VLDevice *device = [_deviceList objectAtIndex:(indexPath.section - 1)];
        NSLog(@"Starting stream for device: %@", device.deviceId);
        
        // Create an array of VLParametricFilters.
        NSMutableArray<VLParametricFilter *> *filterArray = [[NSMutableArray alloc] init];
        [filterArray addObject:[[VLParametricFilter alloc] initWithParameter:@"rpm"]]; // By adding this filter we will only receive stream messages that contain 'rpm' in the data.
        
        // Get a VLStream from VLService, make sure to keep a strong reference to the VLStream.
        [_vlService getStreamForDeviceId:device.deviceId
                       parametricFilters:filterArray
                          geometryFilter:nil
                          onMessageBlock:^(VLStreamMessage *streamMessage) { // // Called whenever we get a new stream message from the device
            // Get the rpm from the stream message, if it isn't in the stream message it returns DEFAULT_VALUE
            int rpm = [streamMessage integerForKey:@"rpm" defaultValue:DEFAULT_VALUE];
            if(rpm != DEFAULT_VALUE){
                NSLog(@"RPM: %d", rpm);
            }
            
            // Get the location of the device from the stream message, if it isn't in the stream message it returns nil.
            VLLocation *coord = [streamMessage coord];
            if(coord != nil){
                NSLog(@"Latitude: %f, Longitude: %f", coord.latitude, coord.longitude);
            }
        } onErrorBlock:^(NSError *error) { // Called if there is an error in the stream.
            NSLog(@"Error during stream: %@", [error localizedDescription]);
        }];
    }
}

#pragma mark - Misc

/**
 * Kill all WebView cookies. Need this to sign out & in properly, so WebView doesn't cache the
 * last session.
 */
- (void) clearCookies{
    [[NSURLCache sharedURLCache] removeAllCachedResponses];
    for (NSHTTPCookie *cookie in [[NSHTTPCookieStorage sharedHTTPCookieStorage] cookies]) {
        [[NSHTTPCookieStorage sharedHTTPCookieStorage] deleteCookie:cookie];
    }
}

@end
