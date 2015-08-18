//
//  VLTestObject.h
//  test3
//
//  Created by Andrew Wells on 8/4/15.
//  Copyright (c) 2015 Andrew Wells. All rights reserved.
//

#import <Foundation/Foundation.h>

@class VLUserCache;

@interface VLUrlParser : NSObject

@property (nonatomic, strong) NSString* clientId;
@property (nonatomic, strong) NSString* redirectUri;

- (VLUserCache *)parseUrl:(NSURL *)url;
- (NSURL *)buildUrl;

@end
