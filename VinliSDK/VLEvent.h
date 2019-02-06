//
//  VLEvent.h
//  VinliSDK
//
//  Created by Lucas Thomas on 5/27/15.
//  Copyright (c) 2015 Vinli. All rights reserved.
//

#import "VLRule.h"

@interface VLEvent : NSObject

@property (readonly) NSString *eventId;
@property (readonly) NSString *timestamp;
@property (readonly, nonatomic) NSDate* eventDate;
@property (readonly) NSString *deviceId;
@property (readonly) NSString *stored;
@property (readonly) NSString *eventType;

@property (readonly) NSString *vehicleId;

@property (readonly) NSString *objectId;
@property (readonly) NSString *objectType;

@property (readonly) NSURL *selfURL;
@property (readonly) NSURL *notificationsURL;

- (id) initWithDictionary: (NSDictionary *) dictionary;
- (NSString *) description;

@end
