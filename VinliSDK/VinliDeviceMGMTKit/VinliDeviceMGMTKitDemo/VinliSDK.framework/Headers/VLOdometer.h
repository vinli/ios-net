//
//  VLOdometer.h
//  VinliSDK
//
//  Created by Jai Ghanekar on 3/14/16.
//  Copyright © 2016 Vinli. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, VLDistanceUnit){
    VLDistanceUnitMeters = 0,
    VLDistanceUnitKilometers,
    VLDistanceUnitMiles
};

@interface VLOdometer : NSObject

@property (readonly) NSString *odometerId;
@property (readonly) NSString *vehicleId;
@property NSNumber *reading;
@property NSString *dateStr;
@property VLDistanceUnit distanceUnit;
@property (readonly) NSURL *vehicleURL;
@property (readonly, nonatomic) NSDate *date;

- (instancetype)initWithDictionary:(NSDictionary *)dictionary;
- (instancetype) initWithReading:(NSNumber *)reading dateStr:(NSString *)dateStr unit:(VLDistanceUnit)unit;

- (NSDictionary *)toDictionary;

+ (NSString *) vlDistanceUnitAsString:(VLDistanceUnit) distanceUnit;

@end
