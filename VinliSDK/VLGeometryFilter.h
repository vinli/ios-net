//
//  VLGeometryFilter.h
//  VinliSDK
//
//  Created by Tommy Brown on 4/13/16.
//  Copyright © 2016 Vinli. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "VLCoordinate.h"

@interface VLGeometryFilter : NSObject

typedef NS_ENUM(NSInteger, GeometryDirection){
    GeometryDirectionInside = 0,
    GeometryDirectionOutside
};

@property (nonatomic) GeometryDirection direction;
@property (nonatomic, strong) NSArray *coordinateList;

- (id) initWithDirection:(GeometryDirection)direction coordinates:(NSArray *)coordinateList;

- (NSDictionary *) toDictionary;

@end
