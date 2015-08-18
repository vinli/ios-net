//
//  VLUserCache.h
//  test3
//
//  Created by Andrew Wells on 8/4/15.
//  Copyright (c) 2015 Andrew Wells. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface VLUserCache : NSObject

@property (strong, nonatomic) NSString* userId;
@property (strong, nonatomic) NSString* accessToken;
@property (strong, nonatomic) NSString* devicesStr;
@property (strong, nonatomic) NSDictionary* devices;

- (void)save;
+ (VLUserCache *)getUserWithId:(NSString *)userId;
+ (VLUserCache *)getUserWithChipId:(NSString *)chipId;
+ (VLUserCache *)getUserWithAccessToken:(NSString *)accessToken;

+ (void)deleteUserWithId:(NSString *)userId;

+ (void)clearUsersCache;
+ (NSDictionary *)getUsersCache;

@end
