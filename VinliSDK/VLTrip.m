//
//  VLTrip.m
//  VinliSDK
//
//  Created by Tommy Brown on 5/26/15.
//  Copyright (c) 2015 Vinli. All rights reserved.
// 

#import "VLTrip.h"
#import "VLDateFormatter.h"
#import "NSDictionary+NonNullable.h"

@interface VLTrip()

@property (strong, nonatomic) NSDate* startDate;
@property (strong, nonatomic) NSDate* stopDate;

@end

@implementation VLTrip

- (id)initWithDictionary:(NSDictionary *)dictionary{
    self = [super init];
    
    if (self) {
        if (dictionary){
            if (dictionary[@"trip"] != nil) {
                dictionary = dictionary[@"trip"];
            }
            
            dictionary = [dictionary filterAllNSNullValues];
            
            _tripId = [dictionary objectForKey:@"id"];
            _start = [dictionary jsonObjectForKey:@"start"];
            _stop = [dictionary jsonObjectForKey:@"stop"];
            _status = [dictionary objectForKey:@"status"];
            _vehicleId = [dictionary objectForKey:@"vehicleId"];
            _deviceId = [dictionary objectForKey:@"deviceId"];
            _distance = [[dictionary jsonObjectForKey:@"stats"] objectForKey:@"distance"];
            _duration = [[dictionary jsonObjectForKey:@"stats"] objectForKey:@"duration"];
            _locationCount = [dictionary objectForKey:@"locationCount"];
            _messageCount = [dictionary objectForKey:@"messageCount"];
            _mpg = [[dictionary jsonObjectForKey:@"stats"] objectForKey:@"fuelEconomy"];
            
            if ([dictionary[@"preview"] isKindOfClass:[NSString class]]) {
                _preview = dictionary[@"preview"];
            }
            
            _startPoint = ([dictionary jsonObjectForKey:@"startPoint"]) ? [[VLLocation alloc] initWithDictionary:[dictionary objectForKey:@"startPoint"]] : nil;
            _stopPoint = ([dictionary jsonObjectForKey:@"stopPoint"]) ? [[VLLocation alloc] initWithDictionary:[dictionary objectForKey:@"stopPoint"]] : nil;
            _orphanedAt = [dictionary objectForKey:@"orphanedAt"];
            
            if ([dictionary objectForKey:@"links"]) {
                _selfURL = [NSURL URLWithString:[[dictionary objectForKey:@"links"] objectForKey:@"self"]];
                _deviceURL = [NSURL URLWithString:[[dictionary objectForKey:@"links"] objectForKey:@"device"]];
                _vehicleURL = [NSURL URLWithString:[[dictionary objectForKey:@"links"] objectForKey:@"vehicle"]];
                _locationsURL = [NSURL URLWithString:[[dictionary objectForKey:@"links"] objectForKey:@"locations"]];
                _messagesURL = [NSURL URLWithString:[[dictionary objectForKey:@"links"] objectForKey:@"messages"]];
                _eventsURL = [NSURL URLWithString:[[dictionary objectForKey:@"links"] objectForKey:@"events"]];
            }
            
            if ([dictionary jsonObjectForKey:@"stats"]) {
                NSDictionary *data = [[dictionary jsonObjectForKey:@"stats"] copy];
                NSMutableDictionary *dataMutable = [data mutableCopy];
                [data enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
                    if ([obj isKindOfClass:[NSNull class]]) {
                        [dataMutable removeObjectForKey:key];
                    }
                }];
                _stats = [NSDictionary dictionaryWithDictionary:dataMutable];
            }
        
            if ([dictionary jsonObjectForKey:@"eventCounts"]) {
                NSDictionary *data = [[dictionary jsonObjectForKey:@"eventCounts"] copy];
                NSMutableDictionary *dataMutable = [data mutableCopy];
                [data enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
                    if ([obj isKindOfClass:[NSNull class]]) {
                        [dataMutable removeObjectForKey:key];
                    }
                }];
                _eventCounts = [NSDictionary dictionaryWithDictionary:dataMutable];
            }
        }
    }
    return self;
}

- (NSString *)description {
    return [NSString stringWithFormat: @"Trip Id:%@, start:%@, stop:%@, status:%@, Vehicle Id%@", self.tripId, self.start, self.stop, self.status, self.vehicleId];
}

- (NSDate *)startDate {
    if (!_startDate) {
        _startDate = [VLDateFormatter initializeDateFromString:self.start];
    }
    
    return _startDate;
}

- (NSDate *)stopDate {
    if (!_stopDate) {
        _stopDate = [VLDateFormatter initializeDateFromString:self.stop];
    }
    
    return _stopDate;
}

@end
