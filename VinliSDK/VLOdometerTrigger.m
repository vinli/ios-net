//
//  VLOdometerTrigger.m
//  VinliSDK
//
//  Created by Jai Ghanekar on 3/16/16.
//  Copyright © 2016 Vinli. All rights reserved.
//

#import "VLOdometerTrigger.h"
#import "NSDictionary+NonNullable.h"

@implementation VLOdometerTrigger

- (instancetype)initWithDictionary:(NSDictionary *)dictionary {
    self = [super init];
    if (self) {
        if (dictionary) {
            if (dictionary[@"odometerTrigger"] != nil) {
                dictionary = dictionary[@"odometerTrigger"];
            }
            
            _odometerTriggerId = [dictionary jsonObjectForKey:@"id"];
            _vehicleId = [dictionary jsonObjectForKey:@"vehicleId"];
            _odometerTriggerType = [self stringToType:[dictionary jsonObjectForKey:@"type"]];
            _threshold = [dictionary jsonObjectForKey:@"threshold"];
            _events = [dictionary jsonObjectForKey:@"events"];
            
            if ([dictionary objectForKey:@"links"]) {
                _vehicleURL = [NSURL URLWithString:[dictionary[@"links"] objectForKey:@"vehicle"]];
            }
        }
    }
    return self;
}

- (instancetype) initWithType:(VLOdometerTriggerType)type threshold:(NSNumber *)threshold unit:(VLDistanceUnit)unit{
    self = [super init];
    if(self){
        _odometerTriggerType = type;
        _threshold = threshold;
        _distanceUnit = unit;
    }
    return self;
}

//used when making the request
- (NSDictionary *)toDictionary{
    NSMutableDictionary *odometerTrigger = [[NSMutableDictionary alloc] init];
    NSMutableDictionary *body = [[NSMutableDictionary alloc] init];
    
    body[@"type"] = [self typeToString:_odometerTriggerType];
    body[@"threshold"] = _threshold;
    body[@"unit"] = [VLOdometer vlDistanceUnitAsString:_distanceUnit];
    odometerTrigger[@"odometerTrigger"] = body;
    
    return odometerTrigger;
}

- (NSString *)typeToString:(VLOdometerTriggerType)type {
    
    NSString *retval;
    
    switch (type) {
        case VLOdometerTriggerTypeFromNow:
            retval = @"from_now";
            break;
        case VLOdometerTriggerTypeMilestone:
            retval = @"milestone";
            break;
        case VLOdometerTriggerTypeSpecific:
            retval = @"specific";
            break;
        default:
            retval = @"specific";
            break;
            
    }
    return retval;
}

//handle invalid string later
- (VLOdometerTriggerType)stringToType:(NSString *)str {
    
    VLOdometerTriggerType type = 0;
    
    if ([str isEqualToString:@"from_now"]) {
        type = VLOdometerTriggerTypeFromNow;
    } else if ([str isEqualToString:@"milestone"]) {
        type = VLOdometerTriggerTypeMilestone;
    } else if ([str isEqualToString:@"specific"]) {
        type = VLOdometerTriggerTypeSpecific;
    }
    
    return type;
}

@end
