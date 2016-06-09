//
//  BearingCalculator.m
//  ios_intl_demo
//
//  Created by Tommy Brown on 6/7/16.
//  Copyright © 2016 Vinli. All rights reserved.
//

#import "BearingCalculator.h"
#import "BearingFilter.h"
#import <VinliSDK.h>

#define DISTANCE_THRESHOLD 0.00025

@interface BearingCalculator()

@property (strong, nonatomic) BearingFilter *bearingFilter;
@property (nonatomic) VLLocation *previousCoordinate;

@end

@implementation BearingCalculator

- (id) init{
    self = [super init];
    
    if(self){
        _bearingFilter = [[BearingFilter alloc] init];
        _previousCoordinate = nil;
    }
    
    return self;
}

- (void) addCoordinate:(VLLocation *)coordinate atTimestamp:(NSString *)timestamp{
    if(_previousCoordinate == nil){
        _previousCoordinate = coordinate;
        return;
    }
    
    double distance = sqrt(pow(coordinate.latitude - _previousCoordinate.latitude, 2) + pow(coordinate.longitude - _previousCoordinate.longitude, 2));
    if(distance > DISTANCE_THRESHOLD){
        [self calcBearing:timestamp newCoord:coordinate prevCoord:_previousCoordinate];
        _previousCoordinate = coordinate;
    }
    
}

- (void) calcBearing:(NSString *)newTimestamp newCoord:(VLLocation *)newCoord prevCoord:(VLLocation *)prevCoord{
    double dLat = newCoord.latitude - prevCoord.latitude;
    double dLon = newCoord.longitude - prevCoord.longitude;
    
    double bearing = atan2(fabs(dLat), fabs(dLon));
    bearing = [self radiansToDegrees:bearing];
    
    if(dLat > 0 && dLon == 0.0){
        bearing = 0.0;
    }else if(dLat == 0.0 && dLon > 0.0){
        bearing = 90.0;
    }else if(dLat < 0.0 && dLon == 0){
        bearing = 180;
    }else if(dLat == 0.0 && dLon < 0.0){
        bearing = 270;
    }else if(dLat > 0.0 && dLon > 0.0){
        bearing = 90.0 - bearing;
    }else if(dLat > 0.0 && dLon < 0.0){
        bearing = bearing + 270;
    }else if(dLat < 0.0 && dLon > 0.0){
        bearing = bearing + 90;
    }else if(dLat < 0.0 && dLon < 0.0){
        bearing = 180 + (90 - bearing);
    }
    
    [_bearingFilter addBearing:bearing atTimestamp:[self posixFromISO:newTimestamp]];
}

- (double) currentBearing{
    return [_bearingFilter filteredBearing];
}

- (long) posixFromISO:(NSString *)isoDate{
    NSDate *date = [VLDateFormatter initializeDateFromString:isoDate];
    return [date timeIntervalSince1970];
}

- (double) degreesToRadians:(double)degrees{
    return (degrees * M_PI / 180.0);
}

- (double) radiansToDegrees:(double)radians{
    return (radians * (180.0 / M_PI));
}

@end
