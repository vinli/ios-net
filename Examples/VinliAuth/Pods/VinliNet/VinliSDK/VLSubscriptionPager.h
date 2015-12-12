//
//  VLSubscriptionPager.h
//  VinliSDK
//
//  Created by Josh Beridon on 5/27/15.
//  Copyright (c) 2015 Vinli. All rights reserved.
//

#import "VLOffsetPager.h"

@interface VLSubscriptionPager : VLOffsetPager

@property (readonly) NSArray *subscriptions;

- (id) initWithDictionary:(NSDictionary *)dictionary;

@end


