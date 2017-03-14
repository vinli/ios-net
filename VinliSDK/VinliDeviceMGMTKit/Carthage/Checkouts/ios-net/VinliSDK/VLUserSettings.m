//
//  VLUserSettings.m
//  Pods
//
//  Created by Andrew Wells on 2/25/16.
//
//

#import "VLUserSettings.h"

@implementation VLUserSettings

- (instancetype)initWithDictionary:(NSDictionary *)dictionary
{
    if (self = [super init]) {
        _unitStr = dictionary[@"unit"];
        _localeStr = dictionary[@"locale"];
        
        _unit = [self getUnitType:_unitStr];
    }
    return self;
}

- (NSDictionary *)toDictionary
{
    return @{@"unit" : _unitStr, @"locale" : _localeStr ?: @"en-US"};
}

- (VLUserSettingsUnit)getUnitType:(NSString *)unitStr
{
    if ([unitStr.lowercaseString isEqualToString:@"metric"]) {
        return VLUserSettingsUnitMetric;
    }
    else if ([unitStr.lowercaseString isEqualToString:@"imperial"]) {
        return VLUserSettingsUnitImperial;
    }
    
    return VLUserSettingsUnitImperial;
}

@end
