//
//  Bearing.m
//  ios_intl_demo
//
//  Created by Tommy Brown on 6/7/16.
//  Copyright © 2016 Vinli. All rights reserved.
//

#import "VLBearing.h"

@implementation VLBearing

- (id) initWithBearing:(double)bearing timestamp:(long)timestamp{
    self = [super init];
    
    if(self){
        _bearing = bearing;
        _timestamp = timestamp;
    }
    
    return self;
}

@end
