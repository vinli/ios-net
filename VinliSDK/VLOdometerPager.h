//
//  VLOdometerPager.h
//  VinliSDK
//
//  Created by Jai Ghanekar on 3/14/16.
//  Copyright © 2016 Vinli. All rights reserved.
//

#import "VLChronoPager.h"

@class VLOdometer;

@interface VLOdometerPager : VLChronoPager

@property (readonly) NSArray *odometers;

- (instancetype)initWithDictionary:(NSDictionary *)dictionary service:(VLService *)service;
- (instancetype)initWithDictionary:(NSDictionary *)dictionary;

- (NSArray *)populateOdometers:(NSDictionary *)dictionary;

@end
