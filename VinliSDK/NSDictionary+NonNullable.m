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

- (id)filterAllNSNullValues
{
    id JSONObject = self;

    if ([JSONObject isKindOfClass:[NSArray class]])
    {
        NSMutableArray *mutableArray = [NSMutableArray arrayWithCapacity:[(NSArray *)JSONObject count]];
        for (id value in (NSArray *)JSONObject)
        {
            [mutableArray addObject:[value filterAllNSNullValues]];
        }
        
        return mutableArray;
        
    }
    else if ([JSONObject isKindOfClass:[NSDictionary class]])
    {
        NSMutableDictionary *mutableDictionary = [NSMutableDictionary dictionaryWithDictionary:JSONObject];
        NSArray *keysForNullValues = [mutableDictionary allKeysForObject:[NSNull null]];
        [mutableDictionary removeObjectsForKeys:keysForNullValues];
        
        [JSONObject enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
           
            if ([obj isKindOfClass:[NSArray class]])
            {
                for (NSDictionary *aDict in (NSArray *)obj)
                {
                    [(NSMutableArray *)obj addObject:[aDict filterAllNSNullValues]];
                    [(NSMutableArray *)obj removeObject:aDict];
                }
            }
            else if ([obj isKindOfClass:[NSDictionary class]])
            {
                [mutableDictionary setObject:[(NSDictionary *)obj filterAllNSNullValues] forKey:key];
            }
            
            
        }];
        
        
        return mutableDictionary;
    }
    
    return JSONObject;
}

@end
