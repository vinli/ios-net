//
//  BearingFilter.m
//  ios_intl_demo
//
//  Created by Tommy Brown on 6/7/16.
//  Copyright © 2016 Vinli. All rights reserved.
//

#define SIZE 32
#define SHORTENED_TIME 4.0

#import "VLBearingFilter.h"
#import "VLBearing.h"

@interface VLBearingFilter()

@property (strong, nonatomic) NSMutableArray<Bearing *> *bearingList;

@end

@implementation BearingFilter

- (id) init{
    self = [super init];
    
    if(self){
        _bearingList = [[NSMutableArray alloc] init];
    }
    
    return self;
}

- (void) addBearing:(double)bearing atTimestamp:(long)posixTimestamp{
    [_bearingList addObject:[[VLBearing alloc] initWithBearing:bearing timestamp:posixTimestamp]];
}

- (double) filteredBearing{
    if(_bearingList.count == 0){
        return 0.0;
    }
    
    NSMutableArray<Bearing *> *recentBearings = [[NSMutableArray alloc] init];
    VLBearing *latestBearing = [_bearingList lastObject];
    for(VLBearing *bearing in _bearingList){
        if((latestBearing.timestamp - bearing.timestamp) <= SHORTENED_TIME){
            [recentBearings addObject:bearing];
        }
    }
    
    double x = 0;
    double y = 0;
    VLBearing *previous = nil;
    
    for(VLBearing *bearing in recentBearings){
        long timestampDiff = bearing.timestamp - recentBearings.firstObject.timestamp;
        if(timestampDiff == 0){
            timestampDiff = 1;
        }
        
        x += cos([self degreesToRadians:bearing.bearing]) * ((previous == nil) ? 1 : timestampDiff);
        y += sin([self degreesToRadians:bearing.bearing]) * ((previous == nil) ? 1 : timestampDiff);
        
        previous = bearing;
    }
    
    double bearing = [self radiansToDegrees:atan2(y, x) ];
    
    return bearing;
}

- (double) degreesToRadians:(double)degrees{
    return (degrees * M_PI / 180.0);
}

- (double) radiansToDegrees:(double)radians{
    return (radians * (180.0 / M_PI));
}

@end
