//
//  VLRulePager.h
//  VinliSDK
//
//  Created by Tommy Brown on 5/26/15.
//  Copyright (c) 2015 Vinli. All rights reserved.
//

#import "VLOffsetPager.h"
#import "VLRule.h"
#import "VLBoundary.h"

@interface VLRulePager : VLOffsetPager

@property (readonly) NSArray *rules;

- (id) initWithDictionary:(NSDictionary *)dictionary;
- (id)initWithDictionary:(NSDictionary *)dictionary service:(VLService *)service;

@end
