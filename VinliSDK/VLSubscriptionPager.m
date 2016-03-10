//
//  VLSubscriptionPager.m
//  VinliSDK
//
//  Created by Josh Beridon on 5/27/15.
//  Copyright (c) 2015 Vinli. All rights reserved.
//

#import "VLSubscriptionPager.h"
#import "VLSubscription.h"

@implementation VLSubscriptionPager

- (id) initWithDictionary:(NSDictionary *)dictionary{
    return [self initWithDictionary:dictionary service:nil];
}

- (id)initWithDictionary:(NSDictionary *)dictionary service:(VLService *)service
{
    if (self = [super initWithDictionary:dictionary service:service])
    {
        if(dictionary){
            if(dictionary[@"subscriptions"]){
                NSArray *jsonArray = dictionary[@"subscriptions"];
                NSMutableArray *subscriptionsArray = [[NSMutableArray alloc] init];
                
                for(NSDictionary *subscription in jsonArray){
                    [subscriptionsArray addObject:[[VLSubscription alloc] initWithDictionary:subscription]];
                }
                _subscriptions = subscriptionsArray;
            }
        }
    }
    return self;
}

@end
