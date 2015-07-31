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

- (id) initWithAccessToken:(NSString *) token;

@end
