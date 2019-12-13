//
//  VLUnitLocalizer.m
//  Pods
//
//  Created by Andrew Wells on 2/25/16.
//
//

#import "VLUnitLocalizer.h"

NSString * const kVLLocalizationManagerUnitImperialUK =    @"imperial";
NSString * const kVLLocalizationManagerUnitImperialUS =    @"imperial_us";
NSString * const kVLLocalizationManagerUnitMetric =        @"metric";

static NSNumberFormatter *numberFormatter;
static NSNumberFormatter *decimalNumberFormatter;

static VLLocalizedUnitType localizedUnitType;

@implementation VLUnitLocalizer

+ (VLLocalizedUnitType)localizedUnitType {
	return localizedUnitType;
}

+ (void)initialize {
	numberFormatter = [[NSNumberFormatter alloc] init];
	[numberFormatter setMaximumFractionDigits:0];
	[numberFormatter setLocale:[NSLocale currentLocale]];
	
	decimalNumberFormatter = [[NSNumberFormatter alloc] init];
	[decimalNumberFormatter setNumberStyle:NSNumberFormatterDecimalStyle];
	[decimalNumberFormatter setLocale:[NSLocale currentLocale]];
	[decimalNumberFormatter setRoundingMode:NSNumberFormatterRoundHalfUp];
}

+ (NSString *)getUnitTypeStr:(VLLocalizedUnitType)type {
	if (type == VLLocalizedUnitTypeMetric) {
		return kVLLocalizationManagerUnitMetric;
	} else if (type == VLLocalizedUnitTypeImperialUK) {
		return kVLLocalizationManagerUnitImperialUK;
	} else if (type == VLLocalizedUnitTypeImperialUS) {
		return kVLLocalizationManagerUnitImperialUS;
	}
	
	return kVLLocalizationManagerUnitImperialUK;
}

+ (void)setLocalizedUnitWithUnitString:(NSString *)unitStr {
	if (!unitStr) {
		return;
	}
	
	NSString* unitToEvaluate = unitStr.lowercaseString;
	if ([unitToEvaluate isEqualToString:kVLLocalizationManagerUnitImperialUK.lowercaseString]) {
		localizedUnitType = VLLocalizedUnitTypeImperialUK;
	} else if ([unitToEvaluate isEqualToString:kVLLocalizationManagerUnitImperialUS.lowercaseString]) {
		localizedUnitType = VLLocalizedUnitTypeImperialUS;
	} else if ([unitToEvaluate isEqualToString:kVLLocalizationManagerUnitMetric.lowercaseString]) {
		localizedUnitType = VLLocalizedUnitTypeMetric;
	}
}

+ (BOOL)isImperialUK {
	return localizedUnitType == VLLocalizedUnitTypeImperialUK;
}

+ (BOOL)isImperialUS {
	return localizedUnitType == VLLocalizedUnitTypeImperialUS;
}

+ (BOOL)isMetric {
	return localizedUnitType == VLLocalizedUnitTypeMetric;
}

#pragma mark - Distance

+ (NSNumber *)localizedDistance:(NSNumber *)distance {
	if (self.isImperialUK || self.isImperialUS) {
		return @([distance doubleValue] * METERS_TO_MILES);
	}
	
	return @([distance doubleValue] / 1000.0f);
}

+ (NSString *)localizedDistanceUnit {
	if (self.isImperialUK || self.isImperialUS) {
		return NSLocalizedString(@"mile", @"");
	}
	
	return NSLocalizedString(@"kilometer", @"");
}

+ (NSString *)localizedDistanceUnitPlural {
	if (self.isImperialUK || self.isImperialUS) {
		return NSLocalizedString(@"miles", @"");
	}
	
	return NSLocalizedString(@"kilometers", @"");
}

+ (NSString *)localizedDistanceUnitPluralShort {
	if (self.isImperialUK || self.isImperialUS) {
		return  NSLocalizedString(@"mi", @"");
	}
	
	return NSLocalizedString(@"km", @"");
}

#pragma mark - Speed

+ (NSNumber *)localizedSpeed:(NSNumber *)speed {
	if (self.isImperialUK || self.isImperialUS) {
		return @([speed doubleValue] * KILOMETERS_TO_MILES);
	}
	return speed;
}

+ (NSString *)localizedSpeedUnit {
	if (self.isImperialUK || self.isImperialUS) {
		return NSLocalizedString(@"miles per hour", @"");
	}
	
	return NSLocalizedString(@"kilometers per hour", @"");
}

+ (NSString *)localizedSpeedUnitShort {
	if (self.isImperialUK || self.isImperialUS) {
		return NSLocalizedString(@"Mi/h", @"");
	}
	
	return NSLocalizedString(@"Km/h", @"");
}

+ (NSString *)localizedSpeedUnitShortLettersOnly {
	if (self.isImperialUK || self.isImperialUS) {
		return  NSLocalizedString(@"mph", @"");
	}
	
	return NSLocalizedString(@"kph", @"");
}

#pragma mark - Liquid Capacity

+ (NSNumber *)localizedLiquidCapacity:(NSNumber *)capacity {
	if (self.isImperialUK) {
		return @([capacity doubleValue] * LITERS_TO_GALLONS_UK);
	} else if (self.isImperialUS) {
		return @([capacity doubleValue] * LITERS_TO_GALLONS_US);
	}
	
	return capacity;
}

+ (NSString *)localizedLiquidCapacityUnit {
	if (self.isImperialUK || self.isImperialUS) {
		return NSLocalizedString(@"gallon", @"");
	}
	return NSLocalizedString(@"liter", @"");
}

+ (NSString *)localizedLiquidCapacityUnitShort {
	if (self.isImperialUK || self.isImperialUS) {
		return NSLocalizedString(@"gal", @"");
	}
	return NSLocalizedString(@"L", @"");
}

+ (NSString *)localizedLiquidCapacityUnitPlural {
	if (self.isImperialUK || self.isImperialUS) {
		return NSLocalizedString(@"gallons", @"");
	}
	return NSLocalizedString(@"liters", @"");
}

#pragma mark - Fuel Economy

// We get this value in Imperial US from the back end
+ (NSNumber *)localizedFuelEconomy:(NSNumber *)fuel {
	if (self.isImperialUK) {
		return [NSNumber numberWithFloat:[VLUnitLocalizer mpgUKFrom:fuel.floatValue]];
	} else if (self.isMetric) {
		return [NSNumber numberWithFloat:[VLUnitLocalizer litersPer100KmFrom:fuel.floatValue]];
	}
	
	return fuel;
}

+ (NSString *)localizedFuelEconomyUnit {
	if (self.isImperialUK || self.isImperialUS) {
		return NSLocalizedString(@"miles per gallon", @"");
	}
	
	return NSLocalizedString(@"liters per 100 kilometers", @"");
}

+ (NSString *)localizedFuelEconomyUnitShort {
	if (self.isImperialUK || self.isImperialUS) {
		return NSLocalizedString(@"mpg", @"");
	}
	
	return NSLocalizedString(@"L/100 km", @"");
}

+ (float)litersPer100KmFrom:(float)mpgImperialUS {
	if (mpgImperialUS < 0.01f) {
		// Avoid division by 0
		return 0.0f;
	} else {
		return 100.0f * KILOMETERS_TO_MILES / (LITERS_TO_GALLONS_US * mpgImperialUS);
	}
}

+ (float)mpgUKFrom:(float)mpgImperialUS {
	return mpgImperialUS / GALLON_US_TO_GALLON_UK;
}

#pragma mark - Numbers

+ (NSString *)localizedNumber:(NSNumber *)number {
	return [numberFormatter stringFromNumber:number];
}

+ (NSString *)localizedDecimalNumber:(NSNumber *)number maxDecimals:(NSInteger)decimals {
	NSString* retVal;
	@synchronized(decimalNumberFormatter) {
		[decimalNumberFormatter setMaximumFractionDigits:decimals];
		retVal = [decimalNumberFormatter stringFromNumber:number];
		[decimalNumberFormatter setMaximumFractionDigits:0];
	}
	return retVal;
}

@end

