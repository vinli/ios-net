//
//  VLVehiclePager.h
//  VinliSDK
//
//  Created by Tommy Brown on 5/26/15.
//  Copyright (c) 2015 Vinli. All rights reserved.
//

#import "VLOffsetPager.h"

@interface VLVehiclePager : VLOffsetPager

@property (readonly) NSArray *vehicles;

- (id) initWithDictionary:(NSDictionary *)dictionary;
- (id) initWithDictionary:(NSDictionary *)dictionary service:(VLService *)service;

@end
