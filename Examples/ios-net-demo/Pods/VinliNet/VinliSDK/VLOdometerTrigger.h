//
//  VLOdometerTrigger.h
//  VinliSDK
//
//  Created by Jai Ghanekar on 3/16/16.
//  Copyright © 2016 Vinli. All rights reserved.
//

#import <Foundation/Foundation.h>


typedef NS_ENUM(NSInteger, VLOdometerTriggerType) {
    VLOdometerTriggerTypeSpecific,
    VLOdometerTriggerTypeFromNow,
    VLOdometerTriggerTypeMilestone
};



@interface VLOdometerTrigger : NSObject
@property (readonly) NSString *odometerTriggerId;
@property (readonly) NSString *vehicleId;
@property (readonly) VLOdometerTriggerType odometerTriggerType;
@property (readonly) NSNumber *threshold;
@property (readonly) NSNumber *events;
@property (readonly) NSURL *vehicleURL;


- (instancetype)initWithDictionary:(NSDictionary *)dictionary;

- (NSDictionary *)toDictionary:(NSString *)unit;

@end



