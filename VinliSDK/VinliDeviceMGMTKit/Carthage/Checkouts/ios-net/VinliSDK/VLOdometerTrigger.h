//
//  VLOdometerTrigger.h
//  VinliSDK
//
//  Created by Jai Ghanekar on 3/16/16.
//  Copyright © 2016 Vinli. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "VLOdometer.h"

typedef NS_ENUM(NSInteger, VLOdometerTriggerType) {
    VLOdometerTriggerTypeSpecific,
    VLOdometerTriggerTypeFromNow,
    VLOdometerTriggerTypeMilestone
};

@interface VLOdometerTrigger : NSObject

@property (readonly) NSString *odometerTriggerId;
@property (readonly) NSString *vehicleId;
@property VLOdometerTriggerType odometerTriggerType;
@property NSNumber *threshold;
@property VLDistanceUnit distanceUnit;
@property (readonly) NSNumber *events;
@property (readonly) NSURL *vehicleURL;

- (instancetype)initWithDictionary:(NSDictionary *)dictionary;
- (instancetype) initWithType:(VLOdometerTriggerType)type threshold:(NSNumber *)threshold unit:(VLDistanceUnit) unit;

- (NSDictionary *)toDictionary;

@end



