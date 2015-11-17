//
//  VLNotification.m
//  VinliSDK
//
//  Created by Lucas Thomas on 5/28/15.
//  Copyright (c) 2015 Vinli. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "VLNotification.h"
#import "NSDictionary+NonNullable.h"

@implementation VLNotification

- (id) initWithDictionary:(NSDictionary *)dictionary{
    self = [super init];
    if(self){
        
        if(dictionary){
            
            if(dictionary[@"notification"] != nil){
                dictionary = [dictionary jsonObjectForKey:@"notification"];
            }
            
            _notificationId = [dictionary jsonObjectForKey:@"id"];
            _eventId = [dictionary jsonObjectForKey:@"eventId"];
            _eventType = [dictionary jsonObjectForKey:@"eventType"];
            _eventTimestamp = [dictionary jsonObjectForKey:@"eventTimestamp"];
            _subscriptionId = [dictionary jsonObjectForKey:@"subscriptionId"];
            
            NSNumber* responseCode = [dictionary jsonObjectForKey:@"responseCode"];
            if (responseCode) {
                _responseCode = [responseCode unsignedLongValue];
            }
            
            _response = [dictionary jsonObjectForKey:@"response"];
            _url = [NSURL URLWithString:[dictionary jsonObjectForKey:@"url"]];
            _payload = [dictionary jsonObjectForKey:@"payload"];
            _state = [dictionary jsonObjectForKey:@"state"];
            _notifiedAt = [dictionary jsonObjectForKey:@"notifiedAt"];
            _respondedAt = [dictionary jsonObjectForKey:@"respondedAt"];
            _createdAt = [dictionary jsonObjectForKey:@"createdAt"];
            
            if([dictionary objectForKey:@"links"] != nil){
                _selfURL = [NSURL URLWithString:@"self"];
                _eventURL = [NSURL URLWithString:@"event"];
                _subscriptionURL = [NSURL URLWithString:@"subscription"];
            }
            
        }
    }
    return self;
}

@end

