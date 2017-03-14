//
//  VLParametricFilter.m
//  VinliSDK
//
//  Created by Tommy Brown on 4/13/16.
//  Copyright © 2016 Vinli. All rights reserved.
//

#import "VLParametricFilter.h"

@implementation VLParametricFilter

#define TYPE @"parametric"

- (id) initWithParameter:(NSString *)parameter{
    return [self initWithParameter:parameter min:nil max:nil];
}

- (id) initWithDataType:(VLDataType)dataType{
    return [self initWithParameter:[VLParametricFilter stringFromDataType:dataType]];
}

- (id) initWithParameter:(NSString *)parameter min:(NSNumber *)min max:(NSNumber *)max{
    self = [super init];
    
    if(self){
        self.parameter = parameter;
        self.min = min;
        self.max = max;
    }
    
    return self;
}

- (id) initWithDataType:(VLDataType)dataType min:(NSNumber *)min max:(NSNumber *)max{
    return [self initWithParameter:[VLParametricFilter stringFromDataType:dataType] min:min max:max];
}

- (NSDictionary *) toDictionary{
    NSMutableDictionary *dictionary = [[NSMutableDictionary alloc] init];
    
    dictionary[@"type"] = @"filter";
    
    NSMutableDictionary *filterDictionary = [[NSMutableDictionary alloc] init];
    filterDictionary[@"type"] = TYPE;
    filterDictionary[@"parameter"] = self.parameter;
    
    if(self.min != nil){
        filterDictionary[@"min"] = self.min;
    }
    
    if(self.max != nil){
        filterDictionary[@"max"] = self.max;
    }
    
    dictionary[@"filter"] = filterDictionary;
    
    return dictionary;
}

+ (NSString *) stringFromDataType:(VLDataType)dataType{
    NSString *string;
    
    switch(dataType){
        case VLDataTypeRPM:
            string = @"rpm";
            break;
        case VLDataTypeVehicleSpeed:
            string = @"vehicleSpeed";
            break;
        case VLDataTypeMassAirflow:
            string = @"massAirFlow";
            break;
        case VLDataTypeCalculatedEngineLoad:
            string = @"calculatedLoadValue";
            break;
        case VLDataTypeEngineCoolantTemp:
            string = @"coolantTemp";
            break;
        case VLDataTypeThrottlePosition:
            string = @"absoluteThrottleSensorPosition";
            break;
        case VLDataTypeTimeSinceEngineStart:
            string = @"runTimeSinceEngineStart";
            break;
        case VLDataTypeFuelPressure:
            string = @"fuelPressure";
            break;
        case VLDataTypeIntakeAirTemp:
            string = @"intakeAirTemperature";
            break;
        case VLDataTypeIntakeMainifoldPressure:
            string = @"intakeManifoldPressure";
            break;
        case VLDataTypeTimingAdvance:
            string = @"timingAdvance";
            break;
        case VLDataTypeFuelRailPressure:
            string = @"fuelRailPressure";
            break;
    }
    
    return string;
}

@end
