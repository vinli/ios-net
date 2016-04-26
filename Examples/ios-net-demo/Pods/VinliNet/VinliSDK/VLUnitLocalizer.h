//
//  VLUnitLocalizer.h
//  Pods
//
//  Created by Andrew Wells on 2/25/16.
//
//

#import <Foundation/Foundation.h>

#define KILOMETERS_TO_MILES 0.621371f
#define METERS_TO_MILES 0.000621371f
#define LITERS_TO_GALLONS 0.264172f
#define MPG_TO_KML 0.425144f

#define MPH_TO_KPH 1.60934f
#define KPH_TO_MPH 0.621371f


typedef NS_ENUM(NSInteger, VLLocalizedUnitType) {
    VLLocalizedUnitTypeImperial,
    VLLocalizedUnitTypeMetric
};

@interface VLUnitLocalizer : NSObject

+ (VLLocalizedUnitType)localizedUnitType;

+ (BOOL)isImperial;

+ (NSString *)getUnitTypeStr:(VLLocalizedUnitType)type;

+ (void)setLocalizedUnitWithUnitString:(NSString *)unitStr;

// Returns kilometeres or miles
+ (NSNumber *)localizedDistance:(NSNumber *)distance;

+ (NSString *)localizedDistanceUnit;
+ (NSString *)localizedDistanceUnitPlural;
+ (NSString *)localizedDistanceUnitPluralShort;

// Returns mph or kph
+ (NSNumber *)localizedSpeed:(NSNumber *)speed;
+ (NSString *)localizedSpeedUnit;
+ (NSString *)localizedSpeedUnitShort;
+ (NSString *)localizedSpeedUnitShortLettersOnly;

// Returns gallons or liters
+ (NSNumber *)localizedLiquidCapacity:(NSNumber *)capacity;
+ (NSString *)localizedLiquidCapacityUnit;
+ (NSString *)localizedLiquidCapacityUnitShort;
+ (NSString *)localizedLiquidCapacityUnitPlural;

// Returns mpg or kml
//+ (NSNumber *)localizedFuelEconomy:(NSNumber *)fuel distance:(NSNumber *)distance;
+ (NSString *)localizedFuelEconomyUnit;
+ (NSString *)localizedFuelEconomyUnitShort;


+ (NSString *)localizedUnitForLocale;

+ (NSString *)localizedNumber:(NSNumber *)number;
+ (NSString *)localizedDecimalNumber:(NSNumber *)number maxDecimals:(NSInteger)decimals;

@end
