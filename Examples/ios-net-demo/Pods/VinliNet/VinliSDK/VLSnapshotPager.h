//
//  VLSnapshotPager.h
//  VinliSDK
//
//  Created by Josh Beridon on 5/29/15.
//  Copyright (c) 2015 Vinli. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "VLChronoPager.h"

@interface VLSnapshotPager : VLChronoPager

@property (readonly) NSArray *snapshots;

- (id) initWithDictionary:(NSDictionary *)dictionary fields:(NSString *)fields;

- (id) initWithDictionary:(NSDictionary *)dictionary service:(VLService *)service fields:(NSString *)fields;

- (NSArray *)populateSnapshots:(NSDictionary *)dictionary fields:(NSString *)fields;

- (void)getNextSnapshots:(void(^)(NSArray *values, NSError *error))completion;
@end
