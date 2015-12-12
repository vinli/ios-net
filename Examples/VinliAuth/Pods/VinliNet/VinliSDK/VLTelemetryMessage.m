//
//  VLTelemetryMessage.m
//  VinliSDK
//
//  Created by Tommy Brown on 5/21/15.
//  Copyright (c) 2015 Cheng Gu. All rights reserved.
//

#import "VLTelemetryMessage.h"
#import "NSDictionary+NonNullable.h"

@implementation VLTelemetryMessage

- (id) initWithDictionary: (NSDictionary *) dictionary{
   
    self = [super init];
    if(self){
        if(dictionary){
            if(dictionary[@"message"]){
                dictionary = dictionary[@"message"];
            }
            
            _messageId = dictionary[@"id"];
            _timestamp = dictionary[@"timestamp"];
            
//            if([dictionary objectForKey:@"location"]){
//                _locationType = dictionary[@"location"][@"type"];
//                
//                _latitude = [dictionary[@"location"][@"coordinates"][1] doubleValue];
//                _longitude = [dictionary[@"location"][@"coordinates"][0] doubleValue];
//            }
            
            if([dictionary objectForKey:@"data"] != nil) {
                _data = [dictionary objectForKey:@"data"];
                
                if([_data jsonObjectForKey:@"location"]) {
                    
                    _locationType = _data[@"location"][@"type"];
                    
                    _latitude = [_data[@"location"][@"coordinates"][1] doubleValue];
                    _longitude = [_data[@"location"][@"coordinates"][0] doubleValue];
                }
                
            }
        }
    }
    return self;
}

@end
