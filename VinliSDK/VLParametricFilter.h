//
//  VLParametricFilter.h
//  VinliSDK
//
//  Created by Tommy Brown on 4/13/16.
//  Copyright © 2016 Vinli. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface VLParametricFilter : NSObject

typedef NS_ENUM(NSInteger, VLDataType){
    VLDataTypeRPM = 0,
    VLDataTypeVehicleSpeed,
    VLDataTypeMassAirflow,
    VLDataTypeCalculatedEngineLoad,
    VLDataTypeEngineCoolantTemp,
    VLDataTypeThrottlePosition,
    VLDataTypeTimeSinceEngineStart,
    VLDataTypeFuelPressure,
    VLDataTypeIntakeAirTemp,
    VLDataTypeIntakeMainifoldPressure,
    VLDataTypeTimingAdvance,
    VLDataTypeFuelRailPressure
};

@property (nonatomic, strong) NSString *parameter;
@property (nonatomic) NSNumber *min;
@property (nonatomic) NSNumber *max;

- (id) initWithParameter:(NSString *) parameter;
- (id) initWithDataType:(VLDataType) dataType;
- (id) initWithParameter:(NSString *) parameter min:(NSNumber *) min max:(NSNumber *) max;
- (id) initWithDataType:(VLDataType) dataType min:(NSNumber *) min max:(NSNumber *) max;

- (NSDictionary *) toDictionary;

@end
