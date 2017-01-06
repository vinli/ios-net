//
//  VLDtc.m
//  VinliSDK
//
//  Created by Andrew Wells on 11/29/16.
//  Copyright © 2016 Vinli. All rights reserved.
//

#import "VLDtc.h"
#import "NSDictionary+NonNullable.h"
#import "VLDateFormatter.h"

@implementation VLDtc {
    NSDate *_startTime;
    NSDate *_stopTime;
}

- (instancetype)initWithDictionary:(NSDictionary *)json {
    if (self = [super init]) {
        _codeId = [json vl_getStringAttributeForKey:@"id" defaultValue:nil];
        _vehicleId = [json vl_getStringAttributeForKey:@"vehicleId" defaultValue:nil];
        _deviceId = [json vl_getStringAttributeForKey:@"deviceId" defaultValue:nil];
        _pid = [json vl_getStringAttributeForKey:@"number" defaultValue:nil];
        _codeDescription = [json vl_getStringAttributeForKey:@"description" defaultValue:nil];
        
        _startTimeStr = [json vl_getStringAttributeForKey:@"start" defaultValue:nil];
        _stopTimeStr = [json vl_getStringAttributeForKey:@"stop" defaultValue:nil];
    }
    
    return self;
}


- (NSDate *)stopTime {
    if (!_stopTime) {
        _stopTime = [VLDateFormatter initializeDateFromString:self.stopTimeStr];
    }
    return _stopTime;
}


- (NSDate *)startTime {
    if (!_startTime) {
        _startTime = [VLDateFormatter initializeDateFromString:self.startTimeStr];
    }
    return _startTime;
}
@end


@implementation VLDtcPager

- (NSArray *)parseJSON:(NSDictionary *)json {
    NSArray *jsonArr = [json vl_getArrayAttributeForKey:@"codes" defaultValue:nil];
    NSMutableArray *newCodes = [[NSMutableArray alloc] initWithCapacity:jsonArr.count];
    for (NSDictionary *dic in jsonArr) {
        VLDtc *dtc = [[VLDtc alloc] initWithDictionary:dic];
        if (dtc) {
            [newCodes addObject:dtc];
        }
    }
    
    if (!_codes) {
        _codes = [newCodes copy];
    }
    else {
        NSMutableArray* mutableCodes = [_codes mutableCopy];
        [mutableCodes addObjectsFromArray:newCodes];
        _codes = [mutableCodes copy];
    }
    
    return newCodes;
}

@end


