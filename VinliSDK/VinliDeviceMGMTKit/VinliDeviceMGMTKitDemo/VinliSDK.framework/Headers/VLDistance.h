//
//  VLDistance.h
//  VinliSDK
//
//  Created by Jai Ghanekar on 3/10/16.
//  Copyright © 2016 Vinli. All rights reserved.
//

#import <Foundation/Foundation.h>




@interface VLDistance : NSObject
@property (readonly) NSNumber *confidenceMin;
@property (readonly) NSNumber *confidenceMax;
@property (readonly) NSNumber *value;
@property (readonly) NSString *lastOdometer;


- (instancetype) initWithDictionary: (NSDictionary *)dictionary;


@end
