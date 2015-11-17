//
//  VLUserCache.m
//  test3
//
//  Created by Andrew Wells on 8/4/15.
//  Copyright (c) 2015 Andrew Wells. All rights reserved.
//

#import "VLUserCache.h"

static NSString * const VLUserCacheUsers = @"VLUserCacheUsers";

@implementation VLUserCache

#pragma mark - Initialization
- (instancetype)initWithUser:(VLUser *)user
{
    if (self = [super init])
    {
        _user = user;
    }
    
    return self;
}

+ (NSDictionary *)getUsersCache
{
    NSDictionary* cacheData = [[NSUserDefaults standardUserDefaults] objectForKey:VLUserCacheUsers];
    NSMutableDictionary* retVal = [NSMutableDictionary new];
    [cacheData enumerateKeysAndObjectsUsingBlock:^(id key, NSData* data, BOOL *stop) {
        VLUserCache* userCache = [NSKeyedUnarchiver unarchiveObjectWithData:data];
        if (userCache) {
            [retVal setObject:userCache forKey:key];
        }
    }];
    return [retVal copy];
}

- (void)encodeWithCoder:(NSCoder *)encoder {
    
    [encoder encodeObject:self.accessToken forKey:@"accessToken"];
    [encoder encodeObject:self.userId forKey:@"userId"];
    [encoder encodeObject:self.devices forKey:@"devices"];
    
    [encoder encodeObject:[NSKeyedArchiver archivedDataWithRootObject:_user] forKey:@"user"];
}

- (id)initWithCoder:(NSCoder *)decoder {
    if((self = [super init])) {
        self.accessToken = [decoder decodeObjectForKey:@"accessToken"];
        self.userId = [decoder decodeObjectForKey:@"userId"];
        self.devices = [decoder decodeObjectForKey:@"devices"];
        
        _user = [NSKeyedUnarchiver unarchiveObjectWithData:[decoder decodeObjectForKey:@"user"]];
    }
    return self;
}

- (void)save
{
    NSData *encodedObject = [NSKeyedArchiver archivedDataWithRootObject:self];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    //[defaults setObject:encodedObject forKey:self.userId];
    
    NSMutableDictionary* mutableUsers = [[defaults objectForKey:VLUserCacheUsers] mutableCopy];
    if (!mutableUsers) {
        mutableUsers = [NSMutableDictionary new];
    }
    [mutableUsers setObject:encodedObject forKey:self.userId];
    [defaults setObject:mutableUsers forKey:VLUserCacheUsers];
    [defaults synchronize];
}

+ (VLUserCache *)getUserWithAccessToken:(NSString *)accessToken
{
    __block VLUserCache* retVal;
    NSDictionary* usersCache = [VLUserCache getUsersCache];
    [usersCache.allValues enumerateObjectsUsingBlock:^(VLUserCache* userCache, NSUInteger idx, BOOL *stop) {
        if ([userCache.accessToken isEqualToString:accessToken])
        {
            retVal = userCache;
            *stop = YES;
        }
    }];
    return retVal;
}

+ (VLUserCache *)getUserWithChipId:(NSString *)chipId
{
    __block VLUserCache* retVal;
    NSDictionary* usersCache = [VLUserCache getUsersCache];
    [usersCache.allValues enumerateObjectsUsingBlock:^(VLUserCache* userCache, NSUInteger idx, BOOL *stop) {
        if (userCache.devices[chipId])
        {
            retVal = userCache;
            *stop = YES;
        }
    }];
    return retVal;
}

+ (VLUserCache *)getUserWithId:(NSString *)userId
{
    NSDictionary* usersCache = [VLUserCache getUsersCache];
    return usersCache[userId];
}

+ (void)deleteUserWithId:(NSString *)userId;
{
    NSMutableDictionary* mutableUsersCache = [[VLUserCache getUsersCache] mutableCopy];
    [mutableUsersCache removeObjectForKey:userId];
    [[NSUserDefaults standardUserDefaults] setObject:mutableUsersCache forKey:VLUserCacheUsers];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+ (void)clearUsersCache
{
    [[NSUserDefaults standardUserDefaults] setObject:@[] forKey:VLUserCacheUsers];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (NSString *)description
{
    return [NSString stringWithFormat:@"<%@: %p (userId: %@) (accessToken: %@)> (devices: %@)", NSStringFromClass([self class]), self, self.userId, self.accessToken, self.devices];
}

@end
