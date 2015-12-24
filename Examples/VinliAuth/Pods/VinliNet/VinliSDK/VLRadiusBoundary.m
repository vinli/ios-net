//
//  VLRadiusBoundary.m
//  VinliSDK
//
//  Created by Tommy Brown on 6/8/15.
//  Copyright (c) 2015 Vinli. All rights reserved.
//

#import "VLRadiusBoundary.h"

@implementation VLRadiusBoundary

- (id) init{
    self = [super initWithType:@"radius"];
    if(self){
    }
    return self;
}

- (id) initWithRadius:(double)radius latitude:(double)latitude longitude:(double)longitude{
    self = [super initWithType:@"radius"];
    if(self){
        _radius = radius;
        _latitude = latitude;
        _longitude = longitude;
    }
    return self;
}

- (id) initWithDictionary:(NSDictionary *)dictionary{
    self = [super initWithDictionary:dictionary];
    if(self){
        _longitude = [dictionary[@"lon"] doubleValue];
        _latitude = [dictionary[@"lat"] doubleValue];
        _radius = [dictionary[@"radius"] doubleValue];
    }
    return self;
}

- (NSDictionary *) toDictionary{
    NSMutableDictionary *dictionary = (NSMutableDictionary *) [super toDictionary];
    
    dictionary[@"lon"] = [NSNumber numberWithDouble:_longitude];
    dictionary[@"lat"] = [NSNumber numberWithDouble:_latitude];
    dictionary[@"radius"] = [NSNumber numberWithDouble:_radius];
    
    return dictionary;
}

- (NSString *) description{
    return [NSString stringWithFormat:@"Lat: %f, Lon: %f, Radius: %f", _latitude, _longitude, _radius];
}

@end
