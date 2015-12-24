//
//  VLEvent.m
//  VinliSDK
//
//  Created by Josh Beridon on 5/27/15.
//  Copyright (c) 2015 Vinli. All rights reserved.
//

#import "VLSubscription.h"
#import "NSDictionary+NonNullable.h"

@implementation VLSubscription

- (id) initWithEventType:(NSString *)eventType url:(NSURL *)url appData:(NSDictionary *)appData objectRef:(VLObjectRef *)objectRef{
    self = [super init];
    if(self){
        _eventType = eventType;
        _url = url;
        _appData = appData;
        _objectRef = objectRef;
    }
    return self;
}

- (id) initWithDictionary: (NSDictionary *) dictionary{
    
    self = [super init];
    if(self){
        if(dictionary){
            
            if(dictionary[@"subscription"] != nil){
                dictionary = dictionary[@"subscription"];
            }
            
            _subscriptionId = dictionary[@"id"];
            _deviceId = dictionary[@"deviceId"];
            _eventType = dictionary[@"eventType"];
            _url =   [NSURL URLWithString:dictionary[@"url"]];
            _createdAt = [dictionary jsonObjectForKey:@"createdAt"];
            _updatedAt = [dictionary jsonObjectForKey:@"updatedAt"];
            
            if(dictionary[@"appData"]){
                NSString *jsonString = dictionary[@"appData"];
                NSData *jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
                _appData = [NSJSONSerialization JSONObjectWithData:jsonData options:NSUTF8StringEncoding error:nil];
            }
            
            if([dictionary jsonObjectForKey:@"object"]){
                _objectRef = [[VLObjectRef alloc] initWithDictionary:dictionary[@"object"]];
            }
            
            if(dictionary[@"links"]){
                _selfURL = [NSURL URLWithString:dictionary[@"links"][@"self"] ];
                _notificationURL = [NSURL URLWithString:dictionary[@"links"][@"notifications"]];
            }
        }
    }
    return self;
}

- (NSDictionary *) toDictionary{
    NSMutableDictionary *dictionary = [[NSMutableDictionary alloc] init];
    NSMutableDictionary *subscription = [[NSMutableDictionary alloc] init];
    
    if(_subscriptionId != nil){
        subscription[@"id"] = _subscriptionId;
    }
    
    if(_deviceId != nil){
        subscription[@"deviceId"] = _deviceId;
    }
    
    if(_createdAt != nil){
        subscription[@"createdAt"] = _createdAt;
    }
    
    if(_selfURL != nil){
        subscription[@"links"][@"self"] = _selfURL.absoluteString;
    }
    
    if(_notificationURL != nil){
        subscription[@"links"][@"notifications"] = _notificationURL;
    }
    
    subscription[@"eventType"] = _eventType;
    subscription[@"url"] = _url.absoluteString;
    
    if(_appData != nil){
        subscription[@"appData"] = [self dictToJson:_appData];
    }
    
    if(_objectRef != nil){
        subscription[@"object"] = [_objectRef toDictionary];
    }
    
    dictionary[@"subscription"] = subscription;
    return dictionary;
}

- (NSDictionary *) toSubscriptionEditDictionary{
    NSMutableDictionary *dictionary = [[NSMutableDictionary alloc] init];
    NSMutableDictionary *subscription = [[NSMutableDictionary alloc] init];
    
    if(_appData != nil){
        [subscription setObject:[self dictToJson:_appData] forKey:@"appData"];
    }
    
    [subscription setObject:[_url absoluteString] forKey:@"url"];
    
    [dictionary setObject:subscription forKey:@"subscription"];
    
    return dictionary;
}

-(NSString *)dictToJson:(NSDictionary *)dict
{
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dict options:NSJSONWritingPrettyPrinted error:nil];
    NSString *string = [[NSString alloc] initWithBytes:[jsonData bytes] length:[jsonData length] encoding:NSUTF8StringEncoding];
    string = [string stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    return string;
}

@end
