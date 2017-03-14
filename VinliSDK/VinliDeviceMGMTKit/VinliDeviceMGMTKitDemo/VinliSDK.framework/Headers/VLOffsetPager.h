//
//  VLOffsetPager.h
//  VinliSDK
//
//  Created by Tommy Brown on 5/26/15.
//  Copyright (c) 2015 Vinli. All rights reserved.
//

#import "VLPager.h"

@interface VLOffsetPager : VLPager

@property (readonly) unsigned long total;
@property (readonly) unsigned long offset;
@property (readonly) NSURL *firstURL;
@property (readonly) NSURL *nextURL;
@property (readonly) NSURL *lastURL;

- (id) initWithDictionary: (NSDictionary *) dictionary;
- (id) initWithDictionary:(NSDictionary *)dictionary service:(VLService *)service;

- (void)getNext:(void (^)(NSArray *newValues, NSError *error))completion;
- (void)getFirst:(void (^)(id value, NSError *error))completion;
- (void)getLast:(void (^)(id value, NSError *error))completion;
@end
