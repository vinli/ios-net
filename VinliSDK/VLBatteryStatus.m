//
//  VLBatteryStatus.m
//  VinliSDK
//
//  Created by Tommy Brown on 9/22/16.
//  Copyright © 2016 Vinli. All rights reserved.
//

#import "VLBatteryStatus.h"
#import "NSDictionary+NonNullable.h"

@implementation VLBatteryStatus

- (instancetype)initWithDictionary:(NSDictionary *)dictionary{
	
	if (self = [super init]) {
		if (dictionary) {
			if ([dictionary isKindOfClass:[NSNull class]]) {
				return nil;
			}
			
			dictionary = [dictionary filterAllNSNullValues];
			
			if (dictionary.allKeys.count == 0) {
				return nil;
			}
			
			if ([dictionary objectForKey:@"batteryStatus"]) {
				NSString *rawStatus = dictionary[@"batteryStatus"][@"status"];
				
				if ([rawStatus isEqualToString:@"green"]) {
					_status = VLBatteryStatusColorGreen;
				} else if([rawStatus isEqualToString:@"yellow"]) {
					_status = VLBatteryStatusColorYellow;
				} else if([rawStatus isEqualToString:@"red"]) {
					_status = VLBatteryStatusColorRed;
				}
				
				_timestamp = dictionary[@"batteryStatus"][@"timestamp"];
			}
		}
	}
	return self;
}

@end
