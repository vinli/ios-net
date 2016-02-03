//
//  VLEventPager.m
//  VinliSDK
//
//  Created by Lucas Thomas on 5/27/15.
//  Copyright (c) 2015 Vinli. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "VLEventPager.h"
#import "VLEvent.h"


@implementation VLEventPager : VLChronoPager;

- (id) initWithDictionary:(NSDictionary *)dictionary{
    return [self initWithDictionary:dictionary service:nil];
}

- (id) initWithDictionary:(NSDictionary *)dictionary service:(VLService *)service
{
    if (self = [super initWithDictionary:dictionary service:service])
    {
        if(dictionary && dictionary[@"events"]){
            NSArray *json = dictionary[@"events"];
            NSMutableArray *eventArrayTemp = [[NSMutableArray alloc] init];
            
            for(NSDictionary *event in json){
                [eventArrayTemp addObject:[[VLEvent alloc] initWithDictionary:event]];
            }
            
            _events = eventArrayTemp;
        }
    }
    return self;
}



@end
