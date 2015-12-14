//
//  VLNotification.h
//  VinliSDK
//
//  Created by Lucas Thomas on 5/28/15.
//  Copyright (c) 2015 Vinli. All rights reserved.
//

#import "VLRule.h"
#import "VLTelemetryMessage.h"

@interface VLNotification : NSObject

@property (readonly) NSString *notificationId;
@property (readonly) NSString *eventId;
@property (readonly) NSString *eventType;
@property (readonly) NSString *eventTimestamp;
@property (readonly) NSString *subscriptionId;
@property (readonly) unsigned long responseCode;
@property (readonly) NSString *response;
@property (readonly) NSURL *url;
@property (readonly) NSString *payload;
@property (readonly) NSString *state;
@property (readonly) NSString *notifiedAt;
@property (readonly) NSString *respondedAt;
@property (readonly) NSString *createdAt;
@property (readonly) NSURL *selfURL;
@property (readonly) NSURL *eventURL;
@property (readonly) NSURL *subscriptionURL;

- (id) initWithDictionary: (NSDictionary *) dictionary;

@end