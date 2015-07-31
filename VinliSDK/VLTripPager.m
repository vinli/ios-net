//
//  VLTripPager.m
//  VinliSDK
//
//  Created by Tommy Brown on 5/26/15.
//  Copyright (c) 2015 Vinli. All rights reserved.
//

#import "VLTripPager.h"

@implementation VLTripPager

- (id) initWithDictionary:(NSDictionary *)dictionary{
    self = [super initWithDictionary:dictionary];
    if(self){
        if(dictionary){
            if(dictionary[@"trips"]){
                NSArray *json = dictionary[@"trips"];
                NSMutableArray *tripArray = [[NSMutableArray alloc] init];
                
                for(NSDictionary *trip in json){
                    [tripArray addObject:[[VLTrip alloc] initWithDictionary:trip]];
                }
                
                _trips = tripArray;
            }
        }
    }
    return self;
}

@end
