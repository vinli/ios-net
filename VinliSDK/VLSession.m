//
//  VLSession.m
//  VinliSDK
//
//  Created by Tommy Brown on 5/27/15.
//  Copyright (c) 2015 Vinli. All rights reserved.
//

#import "VLSession.h"

static NSString * const kVLSessionCachedSession = @"kVLSessionCachedSession";
static VLSession *currentSession;
static NSDictionary *sessionCache;

@implementation VLSession

+ (VLSession *)currentSession {
    // NSKeyedUnarchiver
    
    if (!currentSession) {
        NSDictionary *sessionCache = [[NSUserDefaults standardUserDefaults] objectForKey:kVLSessionCachedSession];
        currentSession = [NSKeyedUnarchiver unarchiveObjectWithData:sessionCache[@"session"]];
    }
    
    return currentSession;
}

+ (BOOL)exitSession {
    currentSession = nil; //maybe get rid of this state
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:kVLSessionCachedSession];
    return [[NSUserDefaults standardUserDefaults] objectForKey:kVLSessionCachedSession] == nil;
    
    
}

+ (void)setCurrentSession:(VLSession *)session {
    // set defaults
    if (!session) {
        return;
    }
    
    @synchronized(sessionCache)
    {
        NSMutableDictionary* mutableSessionsCache = [sessionCache mutableCopy];
        if (!mutableSessionsCache)
        {
            mutableSessionsCache = [NSMutableDictionary new];
        }
        
        NSData *encodedSession = [NSKeyedArchiver archivedDataWithRootObject:session];
        [mutableSessionsCache setObject:encodedSession forKey:@"session"];
        sessionCache = [mutableSessionsCache copy];
        
        [[NSUserDefaults standardUserDefaults] setObject:sessionCache forKey:kVLSessionCachedSession];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }

    
    //return [VLSession new];
}



- (instancetype) initWithAccessToken:(NSString *)token {
    self = [super init];
    if(self){
        _accessToken = [token copy];
        _createdAt = [NSDate date];
        _lastUpdated = [NSDate date];
        
        // NSKeyedArchiver to data - store data in defaults
        
        [VLSession setCurrentSession:self];
        
//        [sessionCache setValue:self forKey:_accessToken];
//        
//        [[NSUserDefaults standardUserDefaults] setObject:sessionCache forKey:kVLSessionCachedSession];
//        [[NSUserDefaults standardUserDefaults] synchronize];
        
    }
    return self;
}

- (instancetype)initWithAccessToken:(NSString *)token userId:(NSString *)userId
{
    if ([self initWithAccessToken:token])
    {
        _userId = [userId copy];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)encoder {
    
    [encoder encodeObject:_accessToken forKey:@"accessToken"];
    [encoder encodeObject:_userId forKey:@"userId"];
    [encoder encodeObject:_createdAt forKey:@"createdAt"];
    [encoder encodeObject:_lastUpdated forKey:@"lastUpdated"];
}

- (id)initWithCoder:(NSCoder *)decoder {
    
    if((self = [super init])) {
        _accessToken = [decoder decodeObjectForKey:@"accessToken"];
        _userId = [decoder decodeObjectForKey:@"userId"];
        _createdAt = [decoder decodeObjectForKey:@"createdAt"];
        _lastUpdated = [decoder decodeObjectForKey:@"lastUpdated"];
    }
    return self;
}


@end
