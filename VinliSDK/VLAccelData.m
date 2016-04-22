//
//  VLAccelData.m
//  VinliSDK
//
//  Created by Tommy Brown on 4/13/16.
//  Copyright © 2016 Vinli. All rights reserved.
//

#import "VLAccelData.h"

@implementation VLAccelData

- (id) initWithDictionary:(NSDictionary *)dictionary{
    self = [super init];
    
    if(self){
        _maxX = [[dictionary objectForKey:@"maxX"] doubleValue];
        _maxY = [[dictionary objectForKey:@"maxY"] doubleValue];
        _maxZ = [[dictionary objectForKey:@"maxZ"] doubleValue];
        _minX = [[dictionary objectForKey:@"minX"] doubleValue];
        _minY = [[dictionary objectForKey:@"minY"] doubleValue];
        _minZ = [[dictionary objectForKey:@"minZ"] doubleValue];
    }
    
    return self;
}

@end
