//
//  VLLocationMessagePager.h
//  VinliSDK
//
//  Created by Josh Beridon on 5/27/15.
//  Copyright (c) 2015 Vinli. All rights reserved.
//


#import "VLChronoPager.h"

@interface VLLocationPager : VLChronoPager

@property (readonly) NSArray *locations;

- (id) initWithDictionary:(NSDictionary *)dictionary;
- (id) initWithDictionary:(NSDictionary *)dictionary service:(VLService *)service;

@end
