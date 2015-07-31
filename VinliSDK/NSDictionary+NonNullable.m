//
//  NSDictionary+NonNullable.m
//  VinliSDK
//
//  Created by Andrew Wells on 7/30/15.
//  Copyright (c) 2015 Vinli. All rights reserved.
//

#import "NSDictionary+NonNullable.h"

@implementation NSDictionary (NonNullable)

- (id)jsonObjectForKey:(id)aKey {
    
    id object = [self objectForKey:aKey];
    if ([object isKindOfClass:[NSNull class]]) {
        object = nil;
    }
    
    return object;
}

@end
