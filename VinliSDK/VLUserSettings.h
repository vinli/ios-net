//
//  VLUserSettings.h
//  Pods
//
//  Created by Andrew Wells on 2/25/16.
//
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, VLUserSettingsUnit) {
    VLUserSettingsUnitMetric,
    VLUserSettingsUnitImperial
};

@interface VLUserSettings : NSObject

@property (readonly) NSString *unitStr;
@property (readonly) NSString *localeStr;
@property (readonly) NSString *countryCode;
@property (readonly) VLUserSettingsUnit unit;

- (instancetype)initWithDictionary:(NSDictionary *)dictionary;
- (NSDictionary *)toDictionary;

@end
