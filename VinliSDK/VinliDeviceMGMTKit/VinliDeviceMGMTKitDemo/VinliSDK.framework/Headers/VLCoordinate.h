//
//  VLCoordinate.h
//  VinliSDK
//
//  Created by Tommy Brown on 4/13/16.
//  Copyright © 2016 Vinli. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface VLCoordinate : NSObject

@property (nonatomic) float longitude;
@property (nonatomic) float latitude;

- (id) initWithLatitude:(float)latitude longitude:(float)longitude;

- (NSArray *) toArray;

@end
