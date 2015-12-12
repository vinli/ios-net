//
//  VLSnapshot.m
//  VinliSDK
//
//  Created by Josh Beridon on 5/29/15.
//  Copyright (c) 2015 Vinli. All rights reserved.
//

#import "VLSnapshot.h"

@implementation VLSnapshot

- (id) initWithDictionary:(NSDictionary *)dictionary fields:(NSString *)fields{
    self = [super init];
    if(self){
        if(dictionary){
            if(dictionary[@"snapshot"] != nil){
                dictionary = dictionary[@"snapshot"];
            }
            
            _timestamp = [dictionary[@"timestamp"] doubleValue];
            if([dictionary objectForKey:@"data"] != nil){
                _data = [dictionary objectForKey:@"data"];
            }
        }
    }
    return self;
}

@end
