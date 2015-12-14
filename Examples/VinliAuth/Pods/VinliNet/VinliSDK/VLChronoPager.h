//
//  VLChronoPager.h
//  VinliSDK
//
//  Created by Tommy Brown on 5/26/15.
//  Copyright (c) 2015 Vinli. All rights reserved.
//

#import "VLPager.h"

@interface VLChronoPager : VLPager

@property (readonly) unsigned long remaining;
@property (readonly) NSString *until;
@property (readonly) NSString *since;
@property (readonly) NSURL *latestURL;
@property (readonly) NSURL *priorURL;

- (id) initWithDictionary:(NSDictionary *)dictionary;

@end
