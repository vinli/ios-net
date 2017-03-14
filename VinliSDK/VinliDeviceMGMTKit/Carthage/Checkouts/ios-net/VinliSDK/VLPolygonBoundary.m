//
//  VLPolygonBoundary.m
//  VinliSDK
//
//  Created by Josh Beridon on 6/8/15.
//  Copyright (c) 2015 Vinli. All rights reserved.
//

#import "VLPolygonBoundary.h"
#import "NSDictionary+NonNullable.h"

@implementation VLPolygonBoundary

- (id) init{
    self = [super initWithType:@"polygon"];
    if(self){
    }
    return self;
}

- (id) initWithCoordinates:(NSArray *)coordinates{
    self = [super initWithType:@"polygon"];
    if(self){
        _coordinates = coordinates;
    }
    return self;
}

- (id) initWithDictionary:(NSDictionary *)dictionary{
    self = [super initWithDictionary:dictionary];
    if(self){
        NSArray *coordContainerArray = [dictionary vl_getArrayAttributeForKey:@"coordinates" defaultValue:nil];
        NSArray *coordsArray = coordContainerArray.firstObject;
        if (coordsArray) {
        _coordinates = coordsArray;
        }
    }
    return self;
}

- (NSDictionary *) toDictionary{
    NSMutableDictionary *dictionary = (NSMutableDictionary *) [super toDictionary];
    if (_coordinates) {
        dictionary[@"coordinates"] = @[_coordinates];
    }
    return dictionary;
}

- (NSString *) description{
    return [NSString stringWithFormat:@"Coordinates: %@", _coordinates];
}

@end
