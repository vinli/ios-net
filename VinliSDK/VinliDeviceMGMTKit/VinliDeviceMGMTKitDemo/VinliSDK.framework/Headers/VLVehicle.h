//
//  VLVehicle.h
//  VinliSDK
//
//  Created by Tommy Brown on 5/21/15.
//  Copyright (c) 2015 Cheng Gu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface VLVehicle : NSObject

@property (readonly) NSString *vehicleId;
@property (readonly) NSString *year;
@property (readonly) NSString *make;
@property (readonly) NSString *model;
@property (readonly) NSString *trim;
@property (readonly) NSString *vin;
@property (readonly) NSString *name;

- (id) initWithDictionary: (NSDictionary *) dictionary;
- (NSDictionary *)toDictionary;

@end
