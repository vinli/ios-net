//
//  VLTripPager.h
//  VinliSDK
//
//  Created by Tommy Brown on 5/26/15.
//  Copyright (c) 2015 Vinli. All rights reserved.
//

#import "VLChronoPager.h"
#import "VLTrip.h"

@interface VLTripPager : VLChronoPager

@property (readonly) NSArray *trips;

- (id) initWithDictionary:(NSDictionary *)dictionary;

@end
