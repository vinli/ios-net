//
//  VLSession.m
//  VinliSDK
//
//  Created by Tommy Brown on 5/27/15.
//  Copyright (c) 2015 Vinli. All rights reserved.
//

#import "VLSession.h"

@implementation VLSession

- (instancetype) initWithAccessToken:(NSString *)token{
    self = [super init];
    if(self){
        _accessToken = [token copy];
        _createdAt = [NSDate date];
        _lastUpdated = [NSDate date];
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
