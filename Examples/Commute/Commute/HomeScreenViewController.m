 //
//  HomeScreenViewController.m
//  Commute
//
//  Created by Jai Ghanekar on 1/22/16.
//  Copyright © 2016 Vinli. All rights reserved.
//

#import "HomeScreenViewController.h"
#import "LoginViewController.h"
#import "SettingsViewController.h"
#import "DummyService.h"
#import <Mapbox/Mapbox.h>
#import <VinliNet/VinliSDK.h>


@interface HomeScreenViewController () <MGLMapViewDelegate>
@property VLStream *stream;
@property(strong, nonatomic) NSMutableArray *points;
@property (strong, nonatomic) UILabel *speedLabel;
@end

@implementation HomeScreenViewController


+ (instancetype)initFromStoryboard {
    HomeScreenViewController *instance = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:NSStringFromClass(self.class)];
    return instance;
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    if (![VLSession currentSession]) {
        UINavigationController *loginVC = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"loginNav"];
        [[[UIApplication sharedApplication].windows[0] rootViewController] presentViewController:loginVC animated:YES completion:nil];
    } else {
        [self initialize];
    }
}

- (void)initialize {
    //initialize the mapview
    //self.mapView = [[MGLMapView alloc]initWithFrame:self.view.bounds styleURL:[MGLStyle darkStyleURL]];
    self.mapView = [[MGLMapView alloc]initWithFrame:CGRectMake(self.view.frame.origin.x, self.view.frame.origin.y, self.view.frame.size.width, self.view.frame.size.height * 0.60)
                                           styleURL:[MGLStyle darkStyleURL]];
    self.mapView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    //center it on the usa
    [self.mapView setCenterCoordinate:CLLocationCoordinate2DMake(39.8282, -98.5795)
                            zoomLevel:0
                             animated:NO];
    
    self.speedLabel = [[UILabel alloc]initWithFrame:CGRectMake(20, 35, 200, 90)];
    self.speedLabel.text = @"No Current Run";
    [self.speedLabel setTextColor:[UIColor whiteColor]];
    [self.mapView addSubview:self.speedLabel];
    //self.mapView.showsUserLocation = YES;
    [self.view addSubview:self.mapView];
    self.mapView.delegate = self;
    //draw on the map in current time
    [self drawOnMap];
}

- (void)viewDidLoad {
    [super viewDidLoad];
}


-(void)getData:(NSString *)deviceId {
    dispatch_queue_t backgroundQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_async(backgroundQueue, ^{
        self.stream = [[VLService sharedService] getStreamForDeviceId:deviceId onMessageBlock:^(VLStreamMessage *message) {
            CLLocationCoordinate2D point = CLLocationCoordinate2DMake(message.coord.latitude, message.coord.longitude);
            [self.mapView setCenterCoordinate:CLLocationCoordinate2DMake(message.coord.latitude, message.coord.longitude)
                                    zoomLevel:15
                                     animated:YES];
            [self.speedLabel setText:[NSString stringWithFormat:@"Speed: %i mph", [message integerForKey:[VLParametricFilter stringFromDataType:VLDataTypeVehicleSpeed] defaultValue:0]]];
            MGLPointAnnotation *polyline = [[MGLPointAnnotation alloc]init];
            polyline.coordinate = point;
            polyline.title = [NSString stringWithFormat:@"Lat:%f, Long:%f", message.coord.latitude, message.coord.longitude];
            __weak typeof(self) weakSelf = self;
            dispatch_async(dispatch_get_main_queue(), ^(void) {
               [weakSelf.mapView addAnnotation:polyline];
           });
        } onErrorBlock:^(NSError *error) {
            NSLog(@"Error getting stream %@", error);
        }];
    });
}

- (void)drawOnMap {
    [[VLService sharedService] getDevicesOnSuccess:^(VLDevicePager *devicePager, NSHTTPURLResponse *response) {
        if (devicePager.devices) {
            VLDevice *device = [devicePager.devices firstObject];
            NSLog(@"%@", device);
            if (device) {
                [self getData:device.deviceId]; //get the stream data
            }
            
        }
    } onFailure:^(NSError *error, NSHTTPURLResponse *response, NSString *bodyString) {
        NSLog(@"Error getting devices");
    }];
    
//    [DummyService dummyOnSuccess:^(NSDictionary *dummy, NSHTTPURLResponse *response) {
//        NSLog(@"got this dummy %@", dummy);
//        [self getData:dummy[@"deviceId"]];
//    } onFailure:^(NSError *error, NSHTTPURLResponse *response, NSString *bodyString) {
//         NSLog(@"Error getting dummies");
//    }];
    
    
    
}

- (MGLAnnotationImage *)mapView:(MGLMapView *)mapView imageForAnnotation:(id <MGLAnnotation>)annotation
{
    MGLAnnotationImage *annotationImage = [mapView dequeueReusableAnnotationImageWithIdentifier:@"marker"];
    if (!annotationImage) {
        UIImage *image = [UIImage imageNamed:@"marker.png"];
        image = [image imageWithAlignmentRectInsets:UIEdgeInsetsMake(0, 0, image.size.height/2, 0)];
        annotationImage = [MGLAnnotationImage annotationImageWithImage:image reuseIdentifier:@"marker"];
    }
    return annotationImage;
}

- (BOOL)mapView:(MGLMapView *)mapView annotationCanShowCallout:(id <MGLAnnotation>)annotation {
    // Always allow callouts to popup when annotations are tapped
    return YES;
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}


//- (void)viewDidDisappear:(BOOL)animated {
//    [super viewDidDisappear:animated];
//    [[VLService sharedService] getDevicesOnSuccess:^(VLDevicePager *devicePager, NSHTTPURLResponse *response) {
//       // [[VLService sharedService] get];
//    } onFailure:^(NSError *error, NSHTTPURLResponse *response, NSString *bodyString) {
//        NSLog(@"Could not deregister dummy device");
//    }];
//}





@end
