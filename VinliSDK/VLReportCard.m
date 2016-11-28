//
//  VLReportCard.m
//  VinliSDK
//
//  Created by Andrew Wells on 11/16/16.
//  Copyright © 2016 Vinli. All rights reserved.
//

#import "VLReportCard.h"
#import "NSDictionary+NonNullable.h"


@implementation VLReportCard

- (instancetype)initWithDictionary:(NSDictionary *)json {
    if (self = [super init]) {
        _reportId = [json vl_getStringAttributeForKey:@"id"];
        _deviceId = [json vl_getStringAttributeForKey:@"deviceId"];
        _vehicleId = [json vl_getStringAttributeForKey:@"vehicleId"];
        _tripId = [json vl_getStringAttributeForKey:@"tripId"];
        _grade = [json vl_getStringAttributeForKey:@"grade"];
    }
    return self;
}

- (NSString *)description {
    return [NSString stringWithFormat:@"%@\n id: %@\n deviceId: %@\n vehicleId: %@\n tripId: %@\n grade: %@", [super description], _reportId, _deviceId, _vehicleId, _tripId, _grade ];
}

@end

@implementation VLOverallReportCard

- (instancetype)initWithDictionary:(NSDictionary *)json {
    if (self = [super init]) {
        _overallGrade = [json[@"reportCard"] vl_getStringAttributeForKey:@"overallGrade" defaultValue:nil];
        _tripSampleSize = [json vl_getNumberAttributeForKey:@"tripSampleSize" defaultValue:@(0)];
        _gradeCount = [json vl_getDictionaryAttributeForKey:@"gradeCount"];
    }
    
    return self;
}

- (NSString *)description {
    return [NSString stringWithFormat:@"%@\n overallGrade: %@\n tripSampleSize: %@\n gradeCount: %@", [super description], _overallGrade, _tripSampleSize, _gradeCount];
}

@end
