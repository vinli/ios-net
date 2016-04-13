//
//  VLCoordinate.m
//  VinliSDK
//
//  Created by Tommy Brown on 4/13/16.
//  Copyright © 2016 Vinli. All rights reserved.
//

#import "VLCoordinate.h"

@implementation VLCoordinate

- (id) initWithLatitude:(float)latitude longitude:(float)longitude{
    self = [super init];
    
    if(self){
        self.latitude = latitude;
        self.longitude = longitude;
    }
    
    return self;
}

- (NSArray *) toArray{
    return @[[NSNumber numberWithFloat:self.longitude], [NSNumber numberWithFloat:self.latitude]];
}

@end
