//
//  VLUnitLocalizer.m
//  Pods
//
//  Created by Andrew Wells on 2/25/16.
//
//

#import "VLUnitLocalizer.h"

static NSString * const kVLLocalizationManagerUnitImperial =      @"imperial";
static NSString * const kVLLocalizationManagerUnitMetric =        @"metric";

static NSNumberFormatter* numberFormatter;
static NSNumberFormatter* decimalNumberFormatter;

static VLLocalizedUnitType localizedUnitType;

@implementation VLUnitLocalizer

+ (VLLocalizedUnitType)localizedUnitType
{
    return localizedUnitType;
}

+ (void)initialize
{
    numberFormatter =  [[NSNumberFormatter alloc] init];
    [numberFormatter setMaximumFractionDigits:0];
    [numberFormatter setLocale:[NSLocale currentLocale]];
    
    decimalNumberFormatter = [[NSNumberFormatter alloc] init];
    [decimalNumberFormatter setNumberStyle:NSNumberFormatterDecimalStyle];
    [decimalNumberFormatter setLocale:[NSLocale currentLocale]];
    [decimalNumberFormatter setRoundingMode:NSNumberFormatterRoundHalfUp];

}

+ (NSString *)getUnitTypeStr:(VLLocalizedUnitType)type
{
    if (type == VLLocalizedUnitTypeMetric) {
        return @"metric";
    }
    else if (type == VLLocalizedUnitTypeImperial) {
        return @"imperial";
    }
    
    return @"imperial";
}

+ (void)setLocalizedUnitWithUnitString:(NSString *)unitStr
{
    if (!unitStr) {
        return;
    }
    
    NSString* unitToEvaluate = unitStr.lowercaseString;
    if ([unitToEvaluate isEqualToString:kVLLocalizationManagerUnitImperial]) {
        localizedUnitType = VLLocalizedUnitTypeImperial;
    }
    else if ([unitToEvaluate isEqualToString:kVLLocalizationManagerUnitMetric])
    {
        localizedUnitType = VLLocalizedUnitTypeMetric;
    }
}

+ (BOOL)isImperial
{
    return localizedUnitType == VLLocalizedUnitTypeImperial;
}

#pragma mark - Distance

+ (NSNumber *)localizedDistance:(NSNumber *)distance
{
    if (self.isImperial) {
        return @([distance doubleValue] * METERS_TO_MILES);
    }
    
    return @([distance doubleValue] / 1000.0f);
}

+ (NSString *)localizedDistanceUnit
{
    if (self.isImperial) {
        return  NSLocalizedString(@"mile", @"");
    }
    
    return NSLocalizedString(@"kilometer", @"");
}

+ (NSString *)localizedDistanceUnitPlural
{
    if (self.isImperial) {
        return  NSLocalizedString(@"miles", @"");
    }
    
    return NSLocalizedString(@"kilometers", @"");
}

+ (NSString *)localizedDistanceUnitPluralShort
{
    if (self.isImperial) {
        return  NSLocalizedString(@"mi", @"");
    }
    
    return NSLocalizedString(@"km", @"");
}

#pragma mark - Speed

+ (NSNumber *)localizedSpeed:(NSNumber *)speed
{
    if (self.isImperial) {
        return @([speed doubleValue] * KILOMETERS_TO_MILES);
    }
    return speed;
}

+ (NSString *)localizedSpeedUnit
{
    if (self.isImperial) {
        return  NSLocalizedString(@"miles per hour", @"");
    }
    
    return NSLocalizedString(@"kilometers per hour", @"");
}

+ (NSString *)localizedSpeedUnitShort
{
    if (self.isImperial) {
        return  NSLocalizedString(@"Mi/h", @"");
    }
    
    return NSLocalizedString(@"Km/h", @"");
}

+ (NSString *)localizedSpeedUnitShortLettersOnly
{
    if (self.isImperial) {
        return  NSLocalizedString(@"mph", @"");
    }
    
    return NSLocalizedString(@"kph", @"");
}

+ (NSString *)localizedUnitForLocale
{
    NSLocale *locale = [NSLocale currentLocale];
    BOOL isMetric = [[locale objectForKey:NSLocaleUsesMetricSystem] boolValue];
    return [self getUnitTypeStr:isMetric ? VLLocalizedUnitTypeMetric : VLLocalizedUnitTypeImperial];
}

#pragma mark - Liquid Capacity

+ (NSNumber *)localizedLiquidCapacity:(NSNumber *)capacity
{
    if (self.isImperial) {
        return @([capacity doubleValue] * LITERS_TO_GALLONS);
    }
    return capacity;
}

+ (NSString *)localizedLiquidCapacityUnit
{
    if (self.isImperial) {
        return NSLocalizedString(@"gallon", @"");
    }
    return NSLocalizedString(@"liter", @"");
}

+ (NSString *)localizedLiquidCapacityUnitShort
{
    if (self.isImperial) {
        return NSLocalizedString(@"gal", @"");
    }
    return NSLocalizedString(@"L", @"");
}

+ (NSString *)localizedLiquidCapacityUnitPlural
{
    if (self.isImperial) {
        return NSLocalizedString(@"gallons", @"");
    }
    return NSLocalizedString(@"liters", @"");
}

#pragma mark - Fuel Economy

+ (NSNumber *)localizedFuelEconomy:(NSNumber *)fuel
{
    // We get this value in imperial form from the back end
    if (!self.isImperial) {
        return [NSNumber numberWithFloat:[VLUnitLocalizer mpgToKmPer100:fuel.floatValue]];
    }
    
    return fuel;
}

+ (NSString *)localizedFuelEconomyUnit {
    
    if (self.isImperial) {
        return NSLocalizedString(@"miles per gallon", @"");
    }
    
    return NSLocalizedString(@"liters per 100 kilometers", @"");
}

+ (NSString *)localizedFuelEconomyUnitShort {
    if (self.isImperial) {
        return NSLocalizedString(@"mpg", @"");
    }
    
    return NSLocalizedString(@"L/100 km", @"");
}

+ (CGFloat)mpgToKmPer100:(CGFloat)mpg
{
    return (100.0f * 3.785411784f) / (1.609344f * mpg);
}

#pragma mark - Numbers

+ (NSString *)localizedNumber:(NSNumber *)number
{
    return [numberFormatter stringFromNumber:number];
}

+ (NSString *)localizedDecimalNumber:(NSNumber *)number maxDecimals:(NSInteger)decimals
{
    NSString* retVal;
    @synchronized(decimalNumberFormatter) {
        [decimalNumberFormatter setMaximumFractionDigits:decimals];
        retVal = [decimalNumberFormatter stringFromNumber:number];
        [decimalNumberFormatter setMaximumFractionDigits:0];
    }
    return retVal;
}


@end
