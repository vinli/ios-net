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
                NSMutableArray *mutableCopy = [NSMutableArray arrayWithArray:obj];
                for (id arrayObject in (NSMutableArray *)obj)
                {
                    if (![arrayObject isKindOfClass:[NSDictionary class]] && [arrayObject isKindOfClass:[NSNull class]])
                    {
                        [mutableCopy removeObject:arrayObject];
                    }
                    else if ([arrayObject isKindOfClass:[NSDictionary class]])
                    {
                        [mutableCopy addObject:[arrayObject filterAllNSNullValues]];
                        [mutableCopy removeObject:arrayObject];
                    }
                }
                
                obj = mutableCopy;
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

- (BOOL)valueIsNull:(NSString *)key
{
    return [self[key] isKindOfClass:[NSNull class]];
}

- (BOOL)valueForKey:(NSString *)key isExpectedType:(Class)class
{
    id value = self[key];
    return [value isKindOfClass:[class class]];
}

- (NSString *)vl_getStringAttributeForKey:(NSString *)key
{
    return [self vl_getStringAttributeForKey:key defaultValue:@""];
}

- (NSString *)vl_getStringAttributeForKey:(NSString *)key defaultValue:(NSString *)defaultValue
{
    if ([self valueForKey:key isExpectedType:[NSString class]])
    {
        return self[key];
    }
    else if ([self valueForKey:key isExpectedType:[NSNumber class]]) {
        return [NSString stringWithFormat:@"%@", self[key]];
    }
    
    return defaultValue;
}


- (NSNumber *)vl_getNumberAttributeForKey:(NSString *)key
{
    return [self vl_getNumberAttributeForKey:key defaultValue:@(0)];
}

- (NSNumber *)vl_getNumberAttributeForKey:(NSString *)key defaultValue:(NSNumber *)defaultValue
{
    // return if a number
    // if not a number check other cases like is it a NSString
    // if so convert string to number if possible
    if ([self valueForKey:key isExpectedType:[NSString class]])
    {
        NSNumberFormatter *stringToNumberFormatter = [[NSNumberFormatter alloc] init];
        [stringToNumberFormatter setNumberStyle:NSNumberFormatterDecimalStyle];
        [stringToNumberFormatter numberFromString:key];
        return self[stringToNumberFormatter];
    }
    else if ([self valueForKey:key isExpectedType:[NSNumber class]])
    {
        return self[key];
    }
    else
    {
        return defaultValue;     // if none of the above works, pass back default value
    }
}

- (BOOL)vl_getBoolAttributeForKey:(NSString *)key
{
    return [self vl_getBoolAttributeForKey:key defaultValue:NO];
}

- (BOOL)vl_getBoolAttributeForKey:(NSString *)key defaultValue:(BOOL)defaultValue
{
    if ([self valueIsNull:key]) {
        return defaultValue;
    }
    
    id value = self[key];
    
    if ([value isKindOfClass:[NSNumber class]])
    {
        return [value boolValue];
    }
    else if ([value isKindOfClass:[NSString class]])
    {
        NSString* valueStr = value;
        if ([valueStr.lowercaseString isEqualToString:@"true"]) {
            return YES;
        }
        else if ([valueStr.lowercaseString isEqualToString:@"false"]) {
            return NO;
        }
    }
    
    return (BOOL)value;
    
}

- (NSDictionary *)vl_getDictionaryAttributeForKey:(NSString *)key
{
    return [self vl_getDictionaryAttributeForKey:key defaultValue:@{}];
}

- (NSDictionary *)vl_getDictionaryAttributeForKey:(NSString *)key defaultValue:(NSDictionary *)defaultValue
{
    if ([self valueIsNull:key])
    {
        return defaultValue;
    }
    
    if (![self valueForKey:key isExpectedType:[NSDictionary class]])
    {
        return defaultValue;
    }
    
    return self[key];
}

- (NSArray *)vl_getArrayAttributeForKey:(NSString *)key {
    return [self vl_getArrayAttributeForKey:key defaultValue:nil];
}

- (NSArray *)vl_getArrayAttributeForKey:(NSString *)key defaultValue:(NSArray *)defaultValue
{
    if ([self valueIsNull:key])
    {
        return defaultValue;
    }
    
    if (![self valueForKey:key isExpectedType:[NSArray class]])
    {
        return defaultValue;
    }
    
    return self[key];
}

@end
