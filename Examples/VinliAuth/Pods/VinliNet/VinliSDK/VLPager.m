//
//  VLPager.m
//  VinliSDK
//
//  Created by Tommy Brown on 5/26/15.
//  Copyright (c) 2015 Vinli. All rights reserved.
//

#import "VLPager.h"

@implementation VLPager

- (id) initWithDictionary:(NSDictionary *)dictionary{
    self = [super init];
    if(self){
        if(dictionary && dictionary[@"meta"] && dictionary[@"meta"][@"pagination"]){
            [self setLimit:[dictionary[@"meta"][@"pagination"][@"limit"] unsignedLongValue]];
        }
    }
    return self;
}

- (void) setLimit:(unsigned long)limit{
    if(limit > 50){
        _limit = 50;
    }else{
        _limit = limit;
    }
}

@end
