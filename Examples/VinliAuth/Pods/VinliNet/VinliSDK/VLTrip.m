//
//  VLTrip.m
//  VinliSDK
//
//  Created by Tommy Brown on 5/26/15.
//  Copyright (c) 2015 Vinli. All rights reserved.
// 

#import "VLTrip.h"
#import "NSDictionary+NonNullable.h"

@implementation VLTrip

- (id) initWithDictionary:(NSDictionary *)dictionary{
    self = [super init];
    if(self){
        
        if(dictionary){
            
            if(dictionary[@"trip"] != nil){
                dictionary = dictionary[@"trip"];
            }
            
            _tripId = [dictionary objectForKey:@"id"];
            _start = [dictionary jsonObjectForKey:@"start"];
            _stop = [dictionary jsonObjectForKey:@"stop"];
            _status = [dictionary objectForKey:@"status"];
            _vehicleId = [dictionary objectForKey:@"vehicleId"];
            _deviceId = [dictionary objectForKey:@"deviceId"];
            _distance = [dictionary objectForKey:@"distance"];
            _duration = [dictionary objectForKey:@"duration"];
            _locationCount = [dictionary objectForKey:@"locationCount"];
            _messageCount = [dictionary objectForKey:@"messageCount"];
            _mpg = [dictionary objectForKey:@"mpg"];
            
            _startPoint = ([dictionary jsonObjectForKey:@"startPoint"]) ? [[VLLocation alloc] initWithDictionary:[dictionary objectForKey:@"startPoint"]] : nil;
            _stopPoint = ([dictionary jsonObjectForKey:@"stopPoint"]) ? [[VLLocation alloc] initWithDictionary:[dictionary objectForKey:@"stopPoint"]] : nil;
            _orphanedAt = [dictionary objectForKey:@"orphanedAt"];
            
            if([dictionary objectForKey:@"links"]){
                _selfURL = [NSURL URLWithString:[[dictionary objectForKey:@"links"] objectForKey:@"self"]];
                _deviceURL = [NSURL URLWithString:[[dictionary objectForKey:@"link"] objectForKey:@"device"]];
                _vehicleURL = [NSURL URLWithString:[[dictionary objectForKey:@"links"] objectForKey:@"vehicle"]];
                _locationsURL = [NSURL URLWithString:[[dictionary objectForKey:@"links"] objectForKey:@"locations"]];
                _messagesURL = [NSURL URLWithString:[[dictionary objectForKey:@"links"] objectForKey:@"messages"]];
                _eventsURL = [NSURL URLWithString:[[dictionary objectForKey:@"links"] objectForKey:@"events"]];
            }
            
            if ([dictionary jsonObjectForKey:@"stats"])
            {
                _stats = [dictionary jsonObjectForKey:@"stats"];
            }
            
        }
    }
    return self;
}

- (NSString *) description{
    return [NSString stringWithFormat: @"Trip Id:%@, start:%@, stop:%@, status:%@, Vehicle Id%@", self.tripId, self.start, self.stop, self.status, self.vehicleId];
}

@end
