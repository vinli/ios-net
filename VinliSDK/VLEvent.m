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

@property (readwrite, nonatomic) NSString *eventId;
@property (readwrite, nonatomic) NSString *timestamp;
@property (readwrite, nonatomic) NSString *deviceId;
@property (readwrite, nonatomic) NSString *stored;
@property (readwrite, nonatomic) NSString *eventType;
@property (readwrite, nonatomic) NSString *vehicleId;
@property (readwrite, nonatomic) NSString *objectId;
@property (readwrite, nonatomic) NSString *objectType;
@property (readwrite, nonatomic) NSURL *selfURL;
@property (readwrite, nonatomic) NSURL *notificationsURL;
@property (readwrite, nonatomic) NSNumber *latitude;
@property (readwrite, nonatomic) NSNumber *longitude;
@property (readwrite, nonatomic) NSDictionary *meta;

@end

@implementation VLEvent

- (id)initWithDictionary:(NSDictionary *)dictionary {
    if (self = [super init]) {
        if (dictionary) {
            NSLog(@"Event: %@", dictionary);
            
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
                NSDictionary *location = dictionary[@"location"];
                if ([location jsonObjectForKey:@"coordinates"]) {
                    NSArray *coords = location[@"coordinates"];
                    _longitude = [coords objectAtIndex:0];
                    _latitude = [coords objectAtIndex:1];
                }
            }

            if ([dictionary objectForKey:@"links"] != nil) {
                _selfURL = [NSURL URLWithString:dictionary[@"links"][@"self"]];
                _notificationsURL = [NSURL URLWithString:dictionary[@"links"][@"notifications"]];
            }
            
            if ([dictionary jsonObjectForKey:@"meta"]) {
                _meta = [dictionary jsonObjectForKey:@"meta"];
                _vehicleId = [_meta jsonObjectForKey:@"vehicleId"];
            }
        }
    }
    return self;
}

- (NSString *)description {
    return [NSString stringWithFormat:@"Event: %@, %@", self.eventType, self.eventId];
}

- (NSDate *)eventDate {
    if (!_eventDate) {
        _eventDate = [VLDateFormatter initializeDateFromString:self.timestamp];
    }
    
    return _eventDate;    
}

@end
