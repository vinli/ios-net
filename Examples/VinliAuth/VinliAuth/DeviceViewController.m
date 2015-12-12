//
//  DeviceViewController.m
//  VinliAuth
//
//  Created by Jai Ghanekar on 12/11/15.
//  Copyright © 2015 Jai Ghanekar. All rights reserved.
//

#import "DeviceViewController.h"
#import "ProfileViewController.h"
#import <VinliNet/VinliSDK.h>
#import <MapKit/MapKit.h>

@interface DeviceViewController ()
@property (strong, atomic) VLLocation *location;
@property (strong, nonatomic) VLVehicle *latestVehicle;
@end

@implementation DeviceViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.vehicleInfo setHidden:YES];
    [self.locationMapView setHidden:YES];
    [self.locationLabel setHidden:YES];
    
    
    // Do any additional setup after loading the view.
    UIColor *grayColor = [[UIColor alloc]initWithRed:211.0f/255.0f green:211.0f/255.0f blue:211.0f/255.0f alpha:1]; //divide by 255.0f
    self.view.backgroundColor = grayColor;
    
    
    //set the top nav bar
    self.navigationController.navigationBar.topItem.title = [NSString stringWithFormat:@"%@", self.currentDevice.name];
    
    //get methods on relevant items
    [[VLSessionManager sharedManager].service getLocationsForDeviceWithId:self.currentDevice.deviceId onSuccess:^(VLLocationPager *locationPager, NSHTTPURLResponse *response) {
       VLLocation *tempLocation = [locationPager.locations objectAtIndex:0];
        self.location = tempLocation;
    } onFailure:nil];
    
    [[VLSessionManager sharedManager].service getLatestVehicleForDeviceWithId:self.currentDevice.deviceId onSuccess:^(VLVehicle *vehicle, NSHTTPURLResponse *response) {
        self.latestVehicle = vehicle;
        
    } onFailure:nil];
    
    
    //create the map view
    self.locationMapView.mapType = MKMapTypeHybrid;
    
   
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    //the rest of the map view
    CLLocationCoordinate2D coord;
    coord.latitude = self.location.latitude;
    coord.longitude = self.location.longitude;
    MKCoordinateSpan span = {.latitudeDelta =  0.5, .longitudeDelta =  0.5};
    MKCoordinateRegion region = {coord, span};
    
    //add a title
    MKPointAnnotation *annotation = [[MKPointAnnotation alloc]init];
    [annotation setCoordinate:coord];
    [annotation setTitle:[NSString stringWithFormat:@" %@, %@ %@", self.latestVehicle.year, self.latestVehicle.make, self.latestVehicle.model]];
    [self.locationMapView setRegion:region];
    [self.locationMapView addAnnotation:annotation];

    
    //update the label for the vehcicle info and
    
    //update make and model lable
//    
//    self.vehicleInfo.text = [NSString stringWithFormat:@" %@, %@ %@", self.latestVehicle.year, self.latestVehicle.make, self.latestVehicle.model];
//    
//    self.locationLabel.text = [NSString stringWithFormat:@"Latitude: %f, Longitude: %f ", self.location.latitude, self.location.longitude];
    
    [self.vehicleInfo setHidden:NO];
    [self.locationMapView setHidden:NO];
    [self.locationLabel setHidden:NO];
    
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}




/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
