//
//  VLRequestHeader.h
//  VinliSDK
//
//  Created by Cheng Gu on 5/29/14.
//  Copyright (c) 2014 Cheng Gu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface VLRequestHeader : NSObject

typedef NS_ENUM(NSInteger, VLProtocolType) {
    VLProtocolTypeHTTP,
    VLProtocolTypeHTTPS,
};

+ (NSURLRequest *) requestWithToken:(NSString *)token
                            method:(NSString *)method
                       contentType:(NSString *)contentType
                          protocol:(VLProtocolType)protocolType
                              host:(NSString *)host // without "http://"
                        requestUri:(NSString *)requestUri
                              port:(NSNumber *)port
                           payload:(NSDictionary *)dictPayload;  // will be the same as HTTP body

+ (NSURLRequest *) requestWithToken:(NSString *)token contentType:(NSString *)contentType requestUri:(NSString *)requestUri;

+ (NSURLRequest *)requestWithToken:(NSString *)token requestUri:(NSURL *)requestUri;


@end
