//
//  VLNotification.m
//  VinliSDK
//
//  Created by Lucas Thomas on 5/28/15.
//  Copyright (c) 2015 Vinli. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "VLNotification.h"

@implementation VLNotification

- (id) initWithDictionary:(NSDictionary *)dictionary{
    self = [super init];
    if(self){
        
        if(dictionary){
            
            if(dictionary[@"notification"] != nil){
                dictionary = dictionary[@"notification"];
            }
            
            _notificationId = dictionary[@"id"];
            _eventId = dictionary[@"eventId"];
            _eventType = dictionary[@"eventType"];
            _eventTimestamp = dictionary[@"eventTimestamp"];
            _subscriptionId = dictionary[@"subscriptionId"];
            _responseCode = [dictionary[@"responseCode"] unsignedLongValue];
            _response = dictionary[@"response"];
            _url = [NSURL URLWithString:dictionary[@"url"]];
            _payload = dictionary[@"payload"];
            _state = dictionary[@"state"];
            _notifiedAt = dictionary[@"notifiedAt"];
            _respondedAt = dictionary[@"respondedAt"];
            _createdAt = dictionary[@"createdAt"];
            
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

