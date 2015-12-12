//
//  VLParametricBoundary.h
//  VinliSDK
//
//  Created by Tommy Brown on 6/8/15.
//  Copyright (c) 2015 Vinli. All rights reserved.
//

#import "VLBoundary.h"

@interface VLParametricBoundary : VLBoundary

@property NSString *parameter;
@property unsigned long min;
@property unsigned long max;

- (id) init;
- (id) initWithParameter: (NSString *)parameter min:(unsigned long)min max:(unsigned long)max;
- (id) initWithDictionary:(NSDictionary *)dictionary;
- (NSDictionary *) toDictionary;

@end
