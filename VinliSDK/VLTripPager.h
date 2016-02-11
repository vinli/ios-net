//
//  VLTripPager.h
//  VinliSDK
//
//  Created by Tommy Brown on 5/26/15.
//  Copyright (c) 2015 Vinli. All rights reserved.
//

#import "VLChronoPager.h"
#import "VLTrip.h"


@class VLService;

@interface VLTripPager : VLChronoPager

@property (readonly) NSArray *trips;

- (id) initWithDictionary:(NSDictionary *)dictionary;
- (id) initWithDictionary:(NSDictionary *)dictionary service:(VLService *)service;
- (void)getLatestTrips:(NSURL *)url onSuccess:(void(^)(NSArray *values, NSError *error))completion;
- (NSArray *)poulateTrips:(NSDictionary *)dictionary;

@end
