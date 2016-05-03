//
//  VLOdometerTriggerPager.m
//  VinliSDK
//
//  Created by Jai Ghanekar on 3/16/16.
//  Copyright © 2016 Vinli. All rights reserved.
//

#import "VLOdometerTriggerPager.h"
#import "VLOdometerTrigger.h"

@implementation VLOdometerTriggerPager

- (instancetype)initWithDictionary:(NSDictionary *)dictionary {
    return [self initWithDictionary:dictionary service:nil];
}

- (instancetype)initWithDictionary:(NSDictionary *)dictionary service:(VLService *)service {
    if (self = [super initWithDictionary:dictionary service:service]) {
        if (self) {
            _odometerTriggers = [self populateOdometerTriggers:dictionary];
        }
    }
    return self;
}

- (NSArray *)populateOdometerTriggers:(NSDictionary *)dictionary {
    if (dictionary) {
        if (dictionary[@"odometerTriggers"]) {
            NSArray *json = dictionary[@"odometerTriggers"];
            NSMutableArray *odometerTriggersArray = [[NSMutableArray alloc] init];
            
            for (NSDictionary *odometerTriggers in json) {
                [odometerTriggersArray addObject:[[VLOdometerTrigger alloc] initWithDictionary:odometerTriggers]];
            }
            return odometerTriggersArray;
        }
    }
    return [[NSArray alloc] init];
}

@end
