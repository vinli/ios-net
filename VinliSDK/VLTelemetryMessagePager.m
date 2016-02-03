//
//  VLTelemetryMessagePager.m
//  VinliSDK
//
//  Created by Josh Beridon on 5/26/15.
//  Copyright (c) 2015 Vinli. All rights reserved.
//

#import "VLTelemetryMessagePager.h"
#import "VLTelemetryMessage.h"

@implementation VLTelemetryMessagePager

- (id) initWithDictionary:(NSDictionary *)dictionary{

    return [self initWithDictionary:dictionary service:nil];
}

- (id)initWithDictionary:(NSDictionary *)dictionary service:(VLService *)service
{
    if (self = [super initWithDictionary:dictionary service:service])
    {
        if(dictionary){
            if(dictionary[@"messages"]){
                NSArray *jsonArray = dictionary[@"messages"];
                NSMutableArray *messagesArray = [[NSMutableArray alloc] init];
                for(NSDictionary *message in jsonArray){
                    [messagesArray addObject:[[VLTelemetryMessage alloc] initWithDictionary:message]];
                }
                _messages = messagesArray;
            }
        }
    }
    return self;
}

@end
