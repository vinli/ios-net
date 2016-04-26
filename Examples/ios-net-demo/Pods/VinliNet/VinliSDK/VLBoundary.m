//
//  VLBoundary.m
//  VinliSDK
//
//  Created by Tommy Brown on 5/20/15.
//  Copyright (c) 2015 Cheng Gu. All rights reserved.
//

#import "VLBoundary.h"

@implementation VLBoundary

- (id) initWithType:(NSString *)type{
    self = [super init];
    if(self){
        _type = type;
    }
    return self;
}

- (id) initWithDictionary:(NSDictionary *)dictionary{
    self = [super init];
    if(self){
        if(dictionary){
            _type = dictionary[@"type"];
        }
    }
    return self;
}

- (NSDictionary *) toDictionary{
    NSMutableDictionary *boundaryDictionary = [[NSMutableDictionary alloc] init];
    
    boundaryDictionary[@"type"] = _type;
    
    return boundaryDictionary;
}

- (NSString *) description{
    return [NSString stringWithFormat: @"Type: %@", _type];
}

@end
