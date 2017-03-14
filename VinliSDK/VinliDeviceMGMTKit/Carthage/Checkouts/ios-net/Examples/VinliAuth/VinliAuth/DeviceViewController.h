//
//  DeviceViewController.h
//  VinliAuth
//
//  Created by Jai Ghanekar on 12/11/15.
//  Copyright © 2015 Jai Ghanekar. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ProfileViewController.h"
#import <VinliNet/VinliSDK.h>
#import <MapKit/MapKit.h>


@interface DeviceViewController : UIViewController
@property (weak, nonatomic) VLDevice *currentDevice;
@property (weak, nonatomic) IBOutlet UILabel *vehicleInfo;
@property (strong, nonatomic) IBOutlet MKMapView *locationMapView;

@property (strong, nonatomic) IBOutlet UILabel *locationLabel;
@property (weak, nonatomic) IBOutlet UILabel *noVehicleLabel;
@property (strong, nonatomic) CLLocationManager *locationManager;
@end
