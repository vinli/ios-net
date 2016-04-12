//
//  VLStreamMessage.m
//  VinliSDK
//
//  Created by Tommy Brown on 4/12/16.
//  Copyright © 2016 Vinli. All rights reserved.
//

#import "VLStreamMessage.h"

@interface VLStreamMessage(){
    NSString *type;
    NSDictionary *subject;
    NSDictionary *payload;
}
@end

@implementation VLStreamMessage

- (id) initWithDictionary:(NSDictionary *)dictionary{
    self = [super init];
    if(self){
        type = [dictionary objectForKey:@"type"];
        
        if([dictionary objectForKey:@"subject"] != nil){
            subject = [dictionary objectForKey:@"subject"];
        }
        
        if([dictionary objectForKey:@"payload"] != nil){
            payload = [dictionary objectForKey:@"payload"];
        }
    }
    return self;
}

@end
