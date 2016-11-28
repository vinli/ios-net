//
//  VLSnapshot.m
//  VinliSDK
//
//  Created by Josh Beridon on 5/29/15.
//  Copyright (c) 2015 Vinli. All rights reserved.
//

#import "VLSnapshot.h"
#import "VLDateFormatter.h"
#import "NSDictionary+NonNullable.h"

@implementation VLSnapshot

- (id) initWithDictionary:(NSDictionary *)dictionary fields:(NSString *)fields{
    self = [super init];
    if(self){
        if(dictionary){
            if(dictionary[@"snapshot"] != nil){
                dictionary = dictionary[@"snapshot"];
            }
            
            _snapShotId = [dictionary vl_getStringAttributeForKey:@"id" defaultValue:nil];
            
            _timeStampStr = [dictionary vl_getStringAttributeForKey:@"timestamp" defaultValue:nil];
            if (_timeStampStr.length > 0) {
                _timeStamp = [VLDateFormatter initializeDateFromString:_timeStampStr];
            }
            
            _data = [dictionary vl_getDictionaryAttributeForKey:@"data" defaultValue:nil];
        }
    }
    return self;
}

@end


//"id": "d175a650-e6c5-4dc6-9c10-984851b506dc",
//"timestamp": "2016-11-28T16:09:42.473Z",
//"data": {
//    "vehicleSpeed": 0,
//    "rpm": 643.75
//},
//"links": {
//    "self": "https://telemetry-dev.vin.li/api/v1/messages/d175a650-e6c5-4dc6-9c10-984851b506dc"
//}
