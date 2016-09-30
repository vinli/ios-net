//
//  VLPager.m
//  VinliSDK
//
//  Created by Tommy Brown on 5/26/15.
//  Copyright (c) 2015 Vinli. All rights reserved.
//

#import "VLPager.h"

#import "NSDictionary+NonNullable.h"

@implementation VLPager

- (id)initWithDictionary:(NSDictionary *)dictionary
{
    return [self initWithDictionary:dictionary service:nil];
}


- (id)initWithDictionary:(NSDictionary *)dictionary service:(VLService *)service
{
    
    if (self = [super init])
    {
        self.service = service;

        if(dictionary[@"meta"][@"pagination"])
        {
            dictionary = [dictionary filterAllNSNullValues];
            [self setLimit:[dictionary[@"meta"][@"pagination"][@"limit"] unsignedLongValue]];
        }
    }
    
    return self;
}



- (void)setLimit:(unsigned long)limit
{
    _limit = (limit > 50) ? 50 : limit; //limit is 50 if its greater than 50 else its limit passed
    
}

@end
