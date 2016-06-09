//
//  BearingCalculator.h
//  ios_intl_demo
//
//  Created by Tommy Brown on 6/7/16.
//  Copyright © 2016 Vinli. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "VLLocation.h"

@interface BearingCalculator : NSObject

- (void) addCoordinate:(VLLocation *)coordinate atTimestamp:(NSString *)timestamp;
- (double) currentBearing;

@end
