//
//  VLUnitLocalizer.h
//  Pods
//
//  Created by Andrew Wells on 2/25/16.
//
//

#import <Foundation/Foundation.h>

#define KILOMETERS_TO_MILES 0.621371f
#define MILES_TO_KILOMETERS (1.0f / KILOMETERS_TO_MILES)
#define LITERS_TO_GALLONS_UK 0.219969f
#define LITERS_TO_GALLONS_US 0.264172f
#define GALLON_US_TO_GALLON_UK 0.832674f

#define METERS_TO_MILES (0.001f * KILOMETERS_TO_MILES)
#define MPH_TO_KPH MILES_TO_KILOMETERS
#define KPH_TO_MPH KILOMETERS_TO_MILES

extern NSString * const kVLLocalizationManagerUnitImperialUK;
extern NSString * const kVLLocalizationManagerUnitImperialUS;
extern NSString * const kVLLocalizationManagerUnitMetric;

typedef NS_ENUM(NSInteger, VLLocalizedUnitType) {
    VLLocalizedUnitTypeImperialUK,
    VLLocalizedUnitTypeMetric,
    VLLocalizedUnitTypeImperialUS
};

@interface VLUnitLocalizer : NSObject

+ (VLLocalizedUnitType)localizedUnitType;

+ (BOOL)isImperialUK;
+ (BOOL)isImperialUS;
+ (BOOL)isMetric;

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

// Returns mpg or L/100 km
+ (NSNumber *)localizedFuelEconomy:(NSNumber *)fuel;
+ (NSString *)localizedFuelEconomyUnit;
+ (NSString *)localizedFuelEconomyUnitShort;

+ (NSString *)localizedNumber:(NSNumber *)number;
+ (NSString *)localizedDecimalNumber:(NSNumber *)number maxDecimals:(NSInteger)decimals;

@end
