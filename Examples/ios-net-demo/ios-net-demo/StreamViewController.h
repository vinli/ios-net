//
//  StreamViewController.h
//  ios-net-demo
//
//  Created by Tommy Brown on 4/28/16.
//  Copyright © 2016 Vinli. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <VinliSDK.h>
#import <MapKit/MapKit.h>

@interface StreamViewController : UIViewController <UITableViewDelegate, UITableViewDataSource>

@property (strong, nonatomic) VLDevice *device;
@property (strong, nonatomic) VLService *vlService;
@property (weak, nonatomic) IBOutlet MKMapView *mapView;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end
