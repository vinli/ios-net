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

@end
