//
//  VLOdometer.h
//  VinliSDK
//
//  Created by Jai Ghanekar on 3/14/16.
//  Copyright © 2016 Vinli. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface VLOdometer : NSObject
@property (readonly) NSString *odometerId;
@property (readonly) NSString *vehicleId;
@property (readonly) NSNumber *reading;
@property (readonly) NSString *dateStr;
@property (readonly) NSURL *vehicleURL;


- (instancetype)initWithDictionary:(NSDictionary *)dictionary;
- (NSDictionary *)toDictionary;




@end
