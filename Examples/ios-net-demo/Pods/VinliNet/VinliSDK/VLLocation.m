//
//  VLLocationMessage.m
//  VinliSDK
//
//  Created by Josh Beridon on 5/27/15.
//  Copyright (c) 2015 Vinli. All rights reserved.
//

#import "VLLocation.h"

@implementation VLLocation

- (id) initWithDictionary: (NSDictionary *) dictionary{
    
    self = [super init];
    if(self){
        if(dictionary){
            
            _locationType = dictionary[@"type"];
            
            if(dictionary[@"geometry"]){
                _geometryType = dictionary[@"geometry"][@"type"];
                if(dictionary[@"geometry"][@"coordinates"]){
                    _longitude = [dictionary[@"geometry"][@"coordinates"][0] doubleValue];
                    _latitude = [dictionary[@"geometry"][@"coordinates"][1] doubleValue];
                }
            }
            
//alternate schema
            if(dictionary[@"type"]){
                _geometryType = dictionary[@"type"];
            }
            
            if(dictionary[@"coordinates"]){
                    _longitude = [dictionary[@"coordinates"][0] doubleValue];
                    _latitude = [dictionary[@"coordinates"][1] doubleValue];
            }
            
            _properties = [dictionary objectForKey:@"properties"];
        }
    }
    return self;
}

- (NSString *) description{
     return [NSString stringWithFormat: @"latitude: %f, longitude: %f", _latitude, _longitude];
}

@end
