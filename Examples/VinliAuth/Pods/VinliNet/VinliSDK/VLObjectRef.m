//
//  VLObjectRef.m
//  VinliSDK
//
//  Created by Tommy Brown on 6/23/15.
//  Copyright (c) 2015 Vinli. All rights reserved.
//

#import "VLObjectRef.h"

@implementation VLObjectRef

- (id) initWithDictionary:(NSDictionary *)dictionary{
    self = [super init];
    if(self){
        if(dictionary != nil){
            _type = dictionary[@"type"];
            _objectId = dictionary[@"id"];
        }
    }
    return self;
}

- (id) initWithType:(NSString *)type objectId:(NSString *)objectId{
    self = [super init];
    if(self){
        _type = type;
        _objectId = objectId;
    }
    return self;
}

- (NSDictionary *) toDictionary{
    NSMutableDictionary *dictionary = [[NSMutableDictionary alloc] init];
    
    dictionary[@"id"] = _objectId;
    dictionary[@"type"] = _type;
    
    return dictionary;
}

@end
