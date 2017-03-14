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

typedef NS_ENUM(NSInteger, VLGeometryDirection){
    VLGeometryDirectionInside = 0,
    VLGeometryDirectionOutside
};

@property (nonatomic) VLGeometryDirection direction;
@property (nonatomic, strong) NSArray *coordinateList;

- (id) initWithDirection:(VLGeometryDirection)direction coordinates:(NSArray *)coordinateList;

- (NSDictionary *) toDictionary;

@end
