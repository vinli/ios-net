//
//  VLTrip.h
//  VinliSDK
//
//  Created by Tommy Brown on 5/26/15.
//  Copyright (c) 2015 Vinli. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "VLLocation.h"

@interface VLTrip : NSObject

@property (readonly) NSString *tripId;
@property (readonly) NSString *start;
@property (readonly) NSString *stop;
@property (readonly) NSString *status;
@property (readonly) NSString *vehicleId;
@property (readonly) NSString *deviceId;
@property (readonly) NSNumber *distance;
@property (readonly) NSNumber *duration;
@property (readonly) NSNumber *locationCount;
@property (readonly) NSNumber *messageCount;
@property (readonly) NSNumber *mpg;
@property (readonly) VLLocation *startPoint;
@property (readonly) VLLocation *stopPoint;
@property (readonly) NSString *orphanedAt;
@property (readonly) NSURL *selfURL;
@property (readonly) NSURL *deviceURL;
@property (readonly) NSURL *vehicleURL;
@property (readonly) NSURL *locationsURL;
@property (readonly) NSURL *messagesURL;
@property (readonly) NSURL *eventsURL;

@property (readonly) NSDictionary* stats;

- (id) initWithDictionary: (NSDictionary *) dictionary;

@end
