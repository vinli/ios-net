//
//  Bearing.h
//  ios_intl_demo
//
//  Created by Tommy Brown on 6/7/16.
//  Copyright © 2016 Vinli. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface VLBearing : NSObject

@property (nonatomic) double bearing;
@property (nonatomic) long timestamp;

- (id) initWithBearing:(double)bearing timestamp:(long)timestamp;

@end
