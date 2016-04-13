//
//  VLGeometryFilter.m
//  VinliSDK
//
//  Created by Tommy Brown on 4/13/16.
//  Copyright © 2016 Vinli. All rights reserved.
//

#import "VLGeometryFilter.h"

@implementation VLGeometryFilter

#define TYPE @"geometry"

- (id) initWithDirection:(GeometryDirection)direction coordinates:(NSArray *)coordinateList{
    return [self initWithDirection:direction coordinates:coordinateList deviceId:nil];
}

- (id) initWithDirection:(GeometryDirection)direction coordinates:(NSArray *)coordinateList deviceId:(NSString *)deviceId{
    self = [super init];
    
    if(self){
        self.direction = direction;
        self.coordinateList = coordinateList;
        self.deviceId = deviceId;
    }
    
    return self;
}

- (NSDictionary *) toDictionary{
    NSMutableDictionary *dictionary = [[NSMutableDictionary alloc] init];
    
    dictionary[@"type"] = @"filter";
    
    if(self.deviceId != nil){
        dictionary[@"deviceId"] = self.deviceId;
    }
    
    NSMutableDictionary *filterDictionary = [[NSMutableDictionary alloc] init];
    
    filterDictionary[@"type"] = TYPE;
    filterDictionary[@"direction"] = [self stringFromDirection:self.direction];
    
    NSMutableDictionary *geometryDictionary = [[NSMutableDictionary alloc] init];
    
    geometryDictionary[@"type"] = @"Polygon";
    
    NSMutableArray *coordArray = [[NSMutableArray alloc] init];
    
    // GeoJSON requires the first coordinate and the last coordinate in a polygon to be the same.
    NSMutableArray *mutableCoordinates = [self.coordinateList mutableCopy];
    if(self.coordinateList && self.coordinateList.count > 0){
        VLCoordinate *firstCoord = self.coordinateList.firstObject;
        VLCoordinate *lastCoord = self.coordinateList.lastObject;
        
        if(!(firstCoord.latitude == lastCoord.latitude && firstCoord.longitude == lastCoord.longitude)){
            [mutableCoordinates addObject:[[VLCoordinate alloc] initWithLatitude:firstCoord.latitude longitude:firstCoord.longitude]];
        }
    }
    
    for(VLCoordinate *coordinate in mutableCoordinates){
        [coordArray addObject:[coordinate toArray]];
    }
    
    NSMutableArray *coordArrayWrapper = [[NSMutableArray alloc] init];
    [coordArrayWrapper addObject:coordArray];
    
    geometryDictionary[@"coordinates"] = coordArrayWrapper;
    
    filterDictionary[@"geometry"] = geometryDictionary;
    dictionary[@"filter"] = filterDictionary;
    
    return dictionary;
}

- (NSString *) stringFromDirection:(GeometryDirection) direction{
    NSString *string = nil;
    switch(direction){
        case GeometryDirectionInside:
            string = @"inside";
            break;
        case GeometryDirectionOutside:
            string = @"outside";
            break;
    }
    return string;
}

@end
