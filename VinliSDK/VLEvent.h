//
//  VLEvent.h
//  VinliSDK
//
//  Created by Lucas Thomas on 5/27/15.
//  Copyright (c) 2015 Vinli. All rights reserved.
//

#import "VLRule.h"

@interface VLEvent : NSObject

@property (readonly, nonatomic) NSString *eventId;
@property (readonly, nonatomic) NSString *timestamp;
@property (readonly, nonatomic) NSDate* eventDate;
@property (readonly, nonatomic) NSString *deviceId;
@property (readonly, nonatomic) NSString *stored;
@property (readonly, nonatomic) NSString *eventType;

@property (readonly, nonatomic) NSString *vehicleId;

@property (readonly, nonatomic) NSString *objectId;
@property (readonly, nonatomic) NSString *objectType;

@property (readonly, nonatomic) NSURL *selfURL;
@property (readonly, nonatomic) NSURL *notificationsURL;

@property (readonly, nonatomic) NSNumber *latitude;
@property (readonly, nonatomic) NSNumber *longitude;

- (id)initWithDictionary: (NSDictionary *)dictionary;
- (NSString *)description;

@end
