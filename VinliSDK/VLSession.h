//
//  VLSession.h
//  VinliSDK
//
//  Created by Tommy Brown on 5/27/15.
//  Copyright (c) 2015 Vinli. All rights reserved.
//

#import <Foundation/Foundation.h>



@interface VLSession : NSObject


@property (readonly) NSString *accessToken;
@property (readonly) NSString *userId;
@property (readonly) NSDate *createdAt;
@property (readonly) NSDate *lastUpdated;

+ (VLSession *)currentSession;
+ (BOOL)exitSession;
+ (void)setCurrentSession:(VLSession *)session;
- (instancetype)initWithAccessToken:(NSString *)token;
- (instancetype)initWithAccessToken:(NSString *)token userId:(NSString *)userId;

@end
