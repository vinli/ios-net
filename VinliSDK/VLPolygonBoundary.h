//
//  VLPolygonBoundary.h
//  VinliSDK
//
//  Created by Josh Beridon on 6/8/15.
//  Copyright (c) 2015 Vinli. All rights reserved.
//

#import "VLBoundary.h"

@interface VLPolygonBoundary : VLBoundary

@property NSArray *coordinates;

- (id) init;
- (id) initWithCoordinates:(NSArray *)coordinates;
- (id) initWithDictionary:(NSDictionary *)dictionary;
- (NSDictionary *) toDictionary;

@end
