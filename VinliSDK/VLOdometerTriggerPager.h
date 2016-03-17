//
//  VLOdometerTriggerPager.h
//  VinliSDK
//
//  Created by Jai Ghanekar on 3/16/16.
//  Copyright © 2016 Vinli. All rights reserved.
//
#import "VLChronoPager.h"
#import "VLService.h"


@interface VLOdometerTriggerPager : VLChronoPager
@property NSArray *odometerTriggers;

- (instancetype)initWithDictionary:(NSDictionary *)dictionary;
- (instancetype)initWithDictionary:(NSDictionary *)dictionary service:(VLService *)service;
- (NSArray *)populateOdometerTriggers:(NSDictionary *)dictionary;

@end
