//
//  VLDistancePager.h
//  VinliSDK
//
//  Created by Jai Ghanekar on 3/10/16.
//  Copyright © 2016 Vinli. All rights reserved.
//


#import "VLChronoPager.h"

@interface VLDistancePager : VLChronoPager
@property NSArray *distances;

- (NSArray *)populateDistances:(NSDictionary *)dictionary;
- (instancetype)initWithDictionary:(NSDictionary *)dictionary service:(VLService *)service;
- (instancetype)initWithDictionary:(NSDictionary *)dictionary;

@end
