//
//  VLAccelData.h
//  VinliSDK
//
//  Created by Tommy Brown on 4/13/16.
//  Copyright © 2016 Vinli. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface VLAccelData : NSObject

@property (readonly) double maxX;
@property (readonly) double maxY;
@property (readonly) double maxZ;
@property (readonly) double minX;
@property (readonly) double minY;
@property (readonly) double minZ;

- (id) initWithDictionary:(NSDictionary *) dictionary;

@end
