//
//  VLEvent.m
//  VinliSDK
//
//  Created by Lucas Thomas on 5/27/15.
//  Copyright (c) 2015 Vinli. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "VLRule.h"
#import "VLEvent.h"
#import "NSDictionary+NonNullable.h"
#import "VLDateFormatter.h"

@interface VLEvent()

@property (strong, nonatomic) NSDate* eventDate;

@end

@implementation VLEvent

- (id)initWithDictionary:(NSDictionary *)dictionary {
    if (self = [super init]) {
        if (dictionary) {
            if (dictionary[@"event"] != nil) {
                dictionary = dictionary[@"event"];
            }
            
            _eventId = dictionary[@"id"];
            _timestamp = dictionary[@"timestamp"];
            _deviceId = dictionary[@"deviceId"];
            _stored = dictionary[@"stored"];
            _eventType = dictionary[@"eventType"];
            
            if ([dictionary jsonObjectForKey:@"object"]) {
                _objectId = dictionary[@"object"][@"id"];
                _objectType = dictionary[@"object"][@"type"];
            }

            if ([dictionary jsonObjectForKey:@"location"]) {
                _latitude = dictionary[@"location"][@"lat"];
                _longitude = dictionary[@"location"][@"lon"];
            }

            if ([dictionary objectForKey:@"links"] != nil) {
                _selfURL = [NSURL URLWithString:dictionary[@"links"][@"self"]];
                _notificationsURL = [NSURL URLWithString:dictionary[@"links"][@"notifications"]];
            }
            
            if ([dictionary jsonObjectForKey:@"meta"]) {
                _vehicleId = [[dictionary jsonObjectForKey:@"meta"] jsonObjectForKey:@"vehicleId"];
            }
        }
    }
    return self;
}

- (NSString *)description {
    return [NSString stringWithFormat:@"EventId: %@", _eventId];
}

- (NSDate *)eventDate {
    if (!_eventDate) {
        _eventDate = [VLDateFormatter initializeDateFromString:self.timestamp];
    }
    
    return _eventDate;    
}

@end
