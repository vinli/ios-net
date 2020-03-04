//
//  VLBatteryStatus.h
//  VinliSDK
//
//  Created by Tommy Brown on 9/22/16.
//  Copyright © 2016 Vinli. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, VLBatteryStatusColor) {
	VLBatteryStatusColorInvalid,
	VLBatteryStatusColorGreen,
	VLBatteryStatusColorYellow,
	VLBatteryStatusColorRed
};

@interface VLBatteryStatus : NSObject

@property (readonly) VLBatteryStatusColor status;
@property (readonly, nonatomic) NSString *timestamp;

- (instancetype)initWithDictionary:(NSDictionary *)dictionary;

@end
