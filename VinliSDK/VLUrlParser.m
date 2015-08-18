//
//  VLTestObject.m
//  test3
//
//  Created by Andrew Wells on 8/4/15.
//  Copyright (c) 2015 Andrew Wells. All rights reserved.
//

#import "VLUrlParser.h"
#import "VLUserCache.h"

static NSString * const VLUrlParserKeyToken         = @"token";
static NSString * const VLUrlParserKeyDevices       = @"devices";
static NSString * const VLUrlParserKeyUserId        = @"userId";



@implementation VLUrlParser

- (VLUserCache *)parseUrl:(NSURL *)url
{
    NSString* scheme = url.scheme.lowercaseString;
    NSString* redirectUri = self.redirectUri.lowercaseString;
    redirectUri = [redirectUri stringByReplacingOccurrencesOfString:@"://" withString:@""];
    
    if ([scheme isEqualToString:redirectUri])
    {
        NSMutableDictionary* params = [NSMutableDictionary new];
        for (NSString* param in [url.query componentsSeparatedByString:@"&"])
        {
            NSArray* elements = [param componentsSeparatedByString:@"="];
            if (elements.count < 2) { continue; }
            [params setObject:elements[1] forKey:elements[0]];
        }
        
        if (params.count == 0) {
            return nil;
        }
        
         VLUserCache* userCache = [[VLUserCache alloc] init];
        
        if (params[VLUrlParserKeyToken])
        {
            userCache.accessToken = params[VLUrlParserKeyToken];
            NSLog(@"Token = %@", params[VLUrlParserKeyToken]);
        }
        
        if (params[VLUrlParserKeyDevices])
        {
            NSString* devicesString = params[VLUrlParserKeyDevices];
            userCache.devicesStr = devicesString;
            NSArray* devicesArr = [devicesString componentsSeparatedByString:@","];
            NSLog(@"Devices = %@", devicesArr);
        }
        
        if (params[VLUrlParserKeyUserId])
        {
            userCache.userId = params[VLUrlParserKeyUserId];
            NSLog(@"UserId = %@", params[VLUrlParserKeyUserId]);
        }
        return userCache;
    }
    
    return nil;
}

- (NSURL *)buildUrl
{
    // Powell User ID
    //9e1dbe1d-a6e4-4b9d-af1e-f97ab7064e79
    
    NSString* userId = @"9e1dbe1d-a6e4-4b9d-af1e-f97ab7064e79";
    
    NSString* redirectUri = self.redirectUri;
    if (![redirectUri containsString:@"://"])
    {
        redirectUri = [NSString stringWithFormat:@"%@://", redirectUri];
    }
    
    NSString* urlStr = [NSString stringWithFormat:@"myvinli://?redirectUri=%@&userId=%@&clientId=%@",redirectUri, userId, self.clientId];
    
    return [NSURL URLWithString:urlStr];
}

@end
