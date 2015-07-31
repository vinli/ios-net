//
//  VLSession.m
//  VinliSDK
//
//  Created by Tommy Brown on 5/27/15.
//  Copyright (c) 2015 Vinli. All rights reserved.
//

#import "VLSession.h"

@implementation VLSession

- (id) initWithAccessToken:(NSString *)token{
    self = [super init];
    if(self){
        _accessToken = token;
    }
    return self;
}

@end
