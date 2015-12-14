//
//  VLRadiusBoundary.h
//  VinliSDK
//
//  Created by Tommy Brown on 6/8/15.
//  Copyright (c) 2015 Vinli. All rights reserved.
//

#import "VLBoundary.h"

@interface VLRadiusBoundary : VLBoundary

@property double longitude;
@property double latitude;
@property double radius;

- (id) init;
- (id) initWithRadius: (double) radius latitude:(double)latitude longitude:(double) longitude;
- (id) initWithDictionary:(NSDictionary *)dictionary;
- (NSDictionary *) toDictionary;

@end
