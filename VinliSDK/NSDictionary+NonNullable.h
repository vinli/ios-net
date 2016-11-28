//
//  NSDictionary+NonNullable.h
//  VinliSDK
//
//  Created by Andrew Wells on 7/30/15.
//  Copyright (c) 2015 Vinli. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDictionary (NonNullable)

- (id)jsonObjectForKey:(id)aKey;

- (NSDictionary *)filterAllNSNullValues;

- (NSString *)vl_getStringAttributeForKey:(NSString *)key;
- (NSString *)vl_getStringAttributeForKey:(NSString *)key defaultValue:(NSString *)defaultValue;

- (NSNumber *)vl_getNumberAttributeForKey:(NSString *)key;
- (NSNumber *)vl_getNumberAttributeForKey:(NSString *)key defaultValue:(NSNumber *)defaultValue;

- (BOOL)vl_getBoolAttributeForKey:(NSString *)key;
- (BOOL)vl_getBoolAttributeForKey:(NSString *)key defaultValue:(BOOL)defaultValue;

- (NSDictionary *)vl_getDictionaryAttributeForKey:(NSString *)key;
- (NSDictionary *)vl_getDictionaryAttributeForKey:(NSString *)key defaultValue:(NSDictionary *)defaultValue;

- (NSArray *)vl_getArrayAttributeForKey:(NSString *)key;
- (NSArray *)vl_getArrayAttributeForKey:(NSString *)key defaultValue:(NSArray *)defaultValue;

@end
