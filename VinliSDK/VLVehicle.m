//
//  VLVehicle.m
//  VinliSDK
//
//  Created by Tommy Brown on 5/21/15.
//  Copyright (c) 2015 Cheng Gu. All rights reserved.
//

#import "VLVehicle.h"

@implementation VLVehicle

- (id) initWithDictionary:(NSDictionary *)dictionary{
    self = [super init];
    if(self){
        if(dictionary){
            
            if([dictionary objectForKey:@"vehicle"] == (id)[NSNull null]){
                return nil;
            }
            
            if(dictionary[@"vehicle"] != nil){
                dictionary = dictionary[@"vehicle"];
            }
            
            _vehicleId = dictionary[@"id"];
            _year = dictionary[@"year"];
            _make = dictionary[@"make"];
            _model = dictionary[@"model"];
            _trim = dictionary[@"trim"];
            _vin = dictionary[@"vin"];
        }
    }
    return self;
}

- (NSString *) description{
    return [NSString stringWithFormat: @"Vehicle ID :%@, Year:%@, Make:%@, Model:%@", _vehicleId, _year, _make, _model];
}

@end
