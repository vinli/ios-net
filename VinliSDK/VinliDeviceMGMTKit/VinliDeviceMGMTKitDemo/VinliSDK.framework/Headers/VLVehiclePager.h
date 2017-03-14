//
//  VLVehiclePager.h
//  VinliSDK
//
//  Created by Tommy Brown on 5/26/15.
//  Copyright (c) 2015 Vinli. All rights reserved.
//

#import "VLOffsetPager.h"
#import "VLParsable.h"

@interface VLVehiclePager : VLOffsetPager <VLParsable>

@property (readonly) NSArray *vehicles;

- (id) initWithDictionary:(NSDictionary *)dictionary;
- (id) initWithDictionary:(NSDictionary *)dictionary service:(VLService *)service;

@end
