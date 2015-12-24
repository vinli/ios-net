//
//  VLRequestHeader.m
//  VinliSDK
//
//  Created by Cheng Gu on 5/29/14.
//  Copyright (c) 2014 Cheng Gu. All rights reserved.
//

#import "VLRequestHeader.h"
#import "NSString+Random.h"

@implementation VLRequestHeader

+ (NSURLRequest *) requestWithToken:(NSString *)token
                             method:(NSString *)method
                        contentType:(NSString *)contentType
                           protocol:(VLProtocolType)protocolType
                               host:(NSString *)host
                         requestUri:(NSString *)requestUri
                               port:(NSNumber *)port
                            payload:(NSDictionary *)dictPayload{
    
    NSString *stringURL = protocolType ? @"https://" : @"http://";
    stringURL = [stringURL stringByAppendingString:host];
    
    if(port){
        stringURL = [stringURL stringByAppendingFormat:@":%d", [port unsignedIntValue]];
    }
    
    stringURL = [stringURL stringByAppendingString:requestUri];
    
    NSMutableURLRequest *URLRequest = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:stringURL]];
    
    NSData* jsonDataToPost = [[NSData alloc] init];
    
    if (([method isEqualToString:@"POST"] || [method isEqualToString:@"PUT"]) && dictPayload) {
        NSError *error;
        jsonDataToPost = [NSJSONSerialization dataWithJSONObject:dictPayload
                                                         options:NSJSONWritingPrettyPrinted error:&error];
        if (error) {
            NSLog(@"Internal error occurred when converting JSON to NSData: %@", error.description);
            return nil;
        }
    }
    
    [URLRequest setHTTPMethod:method];
    
    if(![method isEqualToString:@"DELETE"]){
        [URLRequest setValue:contentType forHTTPHeaderField:@"Accept"];
        [URLRequest setValue:contentType forHTTPHeaderField:@"Content-Type"];
    }
    
    [URLRequest setValue:[NSString stringWithFormat:@"Bearer %@", token] forHTTPHeaderField:@"Authorization"];
    
    if (([method isEqualToString:@"POST"] || [method isEqualToString:@"PUT"]) && dictPayload) {
        NSData *body = jsonDataToPost;
        [URLRequest setHTTPBody:body];
    }
    
    return (NSURLRequest *)URLRequest;
}

@end
