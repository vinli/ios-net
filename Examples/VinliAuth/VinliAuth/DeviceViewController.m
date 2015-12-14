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
@property (strong, nonatomic) VLLocation *location;
@property (strong, nonatomic) VLVehicle *latestVehicle;

@end

@implementation DeviceViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.vehicleInfo setHidden:YES];
    [self.locationMapView setHidden:YES];
    [self.locationLabel setHidden:YES];
    [self.locationMapView setHidden:YES];
    // Do any additional setup after loading the view.
    UIColor *grayColor = [[UIColor alloc]initWithRed:211.0f/255.0f green:211.0f/255.0f blue:211.0f/255.0f alpha:1]; //divide by 255.0f
    self.view.backgroundColor = grayColor;
    
    
    //set the top nav bar
    //self.navigationController.navigationBar.topItem.title = [NSString stringWithFormat:@"%@", self.currentDevice.name];
    
    //get methods on relevant items
//    [[VLSessionManager sharedManager].service getLocationsForDeviceWithId:self.currentDevice.deviceId onSuccess:^(VLLocationPager *locationPager, NSHTTPURLResponse *response) {
//        
//        if ((locationPager.locations.count <= 0 || nil == locationPager.locations)) {
//            // Set to current location
//            // Use CLLocationManager Current Location
//           
//            
//            
//            self.locationManager = [[CLLocationManager alloc]init];
//            self.locationManager.distanceFilter = kCLDistanceFilterNone;
//            self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
//            self.locationManager.delegate = self;
//            [self.locationManager requestWhenInUseAuthorization];
//            
//            
//            
//            [self.locationManager startUpdatingLocation];
//            
//           
//        }
//        
//        else if (locationPager.locations.count > 0)
//        {
//            self.location = [locationPager.locations objectAtIndex:0];//tempLocation;
//            
//            
//            [self putOnMap:self.location.latitude longitude:self.location.longitude];
//        }
//        
//        
//        
//    } onFailure:nil];
    
    [[VLSessionManager sharedManager].service getLatestVehicleForDeviceWithId:self.currentDevice.deviceId onSuccess:^(VLVehicle *vehicle, NSHTTPURLResponse *response) {
        
        if (!vehicle)
        {
            
            self.noVehicleLabel.text = @"No Vehicle info availible";
            return;
            
        }
        
        self.latestVehicle = vehicle;
        
        [[VLSessionManager sharedManager].service getLocationsForDeviceWithId:self.currentDevice.deviceId onSuccess:^(VLLocationPager *locationPager, NSHTTPURLResponse *response) {
        
            
            if (locationPager.locations.count > 0 && self.latestVehicle)
            {
                self.location = [locationPager.locations objectAtIndex:0];//tempLocation;
                
                
                [self putOnMap:self.location.latitude longitude:self.location.longitude];
            }
            
            
            
        } onFailure:nil];

        
        
        
    } onFailure:nil];
    
    
    //create the map view
    self.locationMapView.mapType = MKMapTypeStandard;
    
   
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    [self.vehicleInfo setHidden:NO];
    [self.locationLabel setHidden:NO];
    
}

- (void)putOnMap:(double)latitude longitude:(double) longitude
{
    //the rest of the map view
    [self.locationMapView setHidden:NO];
    CLLocationCoordinate2D coord;
    coord.latitude = latitude;
    coord.longitude = longitude;
    //MKCoordinateSpan span = {.latitudeDelta =  0.25, .longitudeDelta =  0.05};
    MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(coord, 250, 250);
    
    //add a title
    MKPointAnnotation *annotation = [[MKPointAnnotation alloc]init];
    [annotation setCoordinate:coord];
    [annotation setTitle:[NSString stringWithFormat:@" %@, %@ %@", self.latestVehicle.year, self.latestVehicle.make, self.latestVehicle.model]];
    [self.locationMapView setCenterCoordinate:coord animated:YES];
    [self.locationMapView setRegion:region];
    [self.locationMapView addAnnotation:annotation];
   
    
}







@end
