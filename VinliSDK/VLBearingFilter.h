//
//  BearingFilter.h
//  ios_intl_demo
//
//  Created by Tommy Brown on 6/7/16.
//  Copyright © 2016 Vinli. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface VLBearingFilter : NSObject

- (void) addBearing:(double)bearing atTimestamp:(long)posixTimestamp;
- (double) filteredBearing;

@end
