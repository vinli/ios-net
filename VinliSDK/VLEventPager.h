//
//  VLEventPager.h
//  VinliSDK
//
//  Created by Lucas Thomas on 5/27/15.
//  Copyright (c) 2015 Vinli. All rights reserved.
//

#import "VLChronoPager.h"

@interface VLEventPager : VLChronoPager;

@property (readonly) NSArray *events;

- (id) initWithDictionary:(NSDictionary *)dictionary;
- (id) initWithDictionary:(NSDictionary *)dictionary service:(VLService *)service;

@end