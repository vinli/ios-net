//
//  HomeScreenViewController.h
//  Commute
//
//  Created by Jai Ghanekar on 1/22/16.
//  Copyright © 2016 Vinli. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Mapbox/Mapbox.h>

@interface HomeScreenViewController : UIViewController

@property (nonatomic) MGLMapView *mapView;
+ (instancetype)initFromStoryboard;

@end
