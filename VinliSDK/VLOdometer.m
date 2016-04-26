//
//  VLOdometer.m
//  VinliSDK
//
//  Created by Jai Ghanekar on 3/14/16.
//  Copyright © 2016 Vinli. All rights reserved.
//

#import "VLOdometer.h"
#import "NSDictionary+NonNullable.h"
#import "VLDateFormatter.h"





@interface VLOdometer()
@property (strong, nonatomic) NSDate *date;
@end





@implementation VLOdometer


- (instancetype)initWithDictionary:(NSDictionary *)dictionary {
    self = [super init];
    
    if (self) {
        if (dictionary) {
            if (dictionary[@"odometer"] != nil) {
                dictionary = dictionary[@"odometer"];
            }
            
            _odometerId = [dictionary jsonObjectForKey:@"id"];
            _vehicleId = [dictionary jsonObjectForKey:@"vehicleId"];
            _reading = [dictionary jsonObjectForKey:@"reading"];
            _dateStr = [dictionary jsonObjectForKey:@"date"];

            
            if ([dictionary objectForKey:@"links"]) {
                _vehicleURL = [NSURL URLWithString:[dictionary[@"links"]objectForKey:@"vehicle"]];
            }
            
            
            
        }
    }
    return self;
}




//used to send odometer in request

- (NSDictionary *)toDictionary:(NSString *)unit {
    NSMutableDictionary *odometer = [[NSMutableDictionary alloc] init];
    NSMutableDictionary *odometer_body = [[NSMutableDictionary alloc] init];
    odometer_body[@"reading"] = _reading;
    odometer_body[@"date"] = _dateStr;
    odometer_body[@"unit"] = unit;
    odometer[@"odometer"] = odometer_body; //convert back to a dictionary
    return odometer;
    
    
}



- (NSDate *)date {
    if (!_date) {
        _date = [VLDateFormatter initializeDateFromString:self.dateStr];
        
    }
    return _date;
}

@end