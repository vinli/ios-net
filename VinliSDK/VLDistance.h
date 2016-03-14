//
//  VLDistance.h
//  VinliSDK
//
//  Created by Jai Ghanekar on 3/10/16.
//  Copyright © 2016 Vinli. All rights reserved.
//

#import <Foundation/Foundation.h>




@interface VLDistance : NSObject
@property NSNumber *confidenceMin;
@property NSNumber *confidenceMax;
@property NSNumber *value;
@property NSDate *lastOdometerDate;

- (instancetype) initWithDictionary: (NSDictionary *)dictionary;


@end
