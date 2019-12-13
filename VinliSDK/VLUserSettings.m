//
//  VLUserSettings.m
//  Pods
//
//  Created by Andrew Wells on 2/25/16.
//
//

#import "VLUserSettings.h"
#import "VLUnitLocalizer.h"

@implementation VLUserSettings

- (instancetype)initWithDictionary:(NSDictionary *)dictionary {
	if (self = [super init]) {
		_unitStr = dictionary[@"unit"];
		_localeStr = dictionary[@"locale"];
		_countryCode = dictionary[@"country"];
		_unit = [self getUnitType:_unitStr];
	}
	return self;
}

- (NSDictionary *)toDictionary {
	return @{ @"unit": _unitStr,
						@"locale": _localeStr ?: @"en-US",
						@"country": _countryCode ?: @"" };
}

- (VLUserSettingsUnit)getUnitType:(NSString *)unitStr {
	if ([unitStr.lowercaseString isEqualToString:kVLLocalizationManagerUnitMetric.lowercaseString]) {
		return VLUserSettingsUnitMetric;
	} else if ([unitStr.lowercaseString isEqualToString:kVLLocalizationManagerUnitImperialUK.lowercaseString]) {
		return VLUserSettingsUnitImperialUK;
	} else if ([unitStr.lowercaseString isEqualToString:kVLLocalizationManagerUnitImperialUS.lowercaseString]) {
		return VLUserSettingsUnitImperialUS;
	}
	
	return VLUserSettingsUnitImperialUK;
}

@end
