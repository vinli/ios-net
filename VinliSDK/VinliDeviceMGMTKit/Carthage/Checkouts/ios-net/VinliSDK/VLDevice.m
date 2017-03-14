//
//  VLDevice.m
//  VinliSDK
//
//  Created by Cheng Gu on 8/21/14.
//  Copyright (c) 2014 Cheng Gu. All rights reserved.
//

#import "VLDevice.h"
#import "NSDictionary+NonNullable.h"

@implementation VLDevice

- (id) initWithDictionary:(NSDictionary *)dictionary{
    self = [super init];
    if(self){
        if (dictionary) {
            
            if(dictionary[@"device"]){
                dictionary = dictionary[@"device"];
            }
            
            _deviceId = dictionary[@"id"];
            _name = dictionary[@"name"];
            
            if([dictionary objectForKey:@"unlockToken"] == (id)[NSNull null]){
                _unlockToken = nil;
            }else{
                _unlockToken = [dictionary objectForKey:@"unlockToken"];
            }
            
            if([dictionary objectForKey:@"icon"] == (id)[NSNull null]){
                _iconURL = nil;
            }else{
                _iconURL = [NSURL URLWithString:[dictionary objectForKey:@"icon"]];
            }
            
            if ([dictionary jsonObjectForKey:@"chipId"])
            {
                _chipID = [dictionary jsonObjectForKey:@"chipId"];
            }
            
            if (dictionary[@"links"]) {
                _selfURL = [NSURL URLWithString:dictionary[@"links"][@"self"]];
                _vehiclesURL = [NSURL URLWithString:dictionary[@"links"][@"vehicles"]];
                _latestVehicleURL = [NSURL URLWithString:dictionary[@"links"][@"latestVehicle"]];
                _rulesURL = [NSURL URLWithString:dictionary[@"links"][@"rules"]];
                _eventsURL = [NSURL URLWithString:dictionary[@"links"][@"events"]];
                _subscriptionsURL = [NSURL URLWithString:dictionary[@"links"][@"subscriptions"]];
            }
        }
    }
    return self;
}


- (NSString *) description{
    return [NSString stringWithFormat: @"Device ID: %@", self.deviceId];
}

@end
