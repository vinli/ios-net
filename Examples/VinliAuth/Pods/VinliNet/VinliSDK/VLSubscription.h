//
//  VLEvent.h
//  VinliSDK
//
//  Created by Josh Beridon on 5/27/15.
//  Copyright (c) 2015 Vinli. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "VLObjectRef.h"

@interface VLSubscription : NSObject

@property NSString *eventType;
@property NSDictionary *appData;
@property NSURL *url;
@property VLObjectRef *objectRef;

@property (readonly) NSString *subscriptionId;
@property (readonly) NSString *deviceId;
@property (readonly) NSString *createdAt;
@property (readonly) NSString *updatedAt;

@property (readonly) NSURL *selfURL;
@property (readonly) NSURL *notificationURL;

- (id) initWithEventType:(NSString *)eventType url:(NSURL *)url appData:(NSDictionary *)appData objectRef:(VLObjectRef *)objectRef;
- (id) initWithDictionary: (NSDictionary *) dictionary;

- (NSDictionary *) toDictionary;
- (NSDictionary *) toSubscriptionEditDictionary;

@end
