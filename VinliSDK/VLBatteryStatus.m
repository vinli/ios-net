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

- (instancetype) initWithDictionary:(NSDictionary *)dictionary{
    self = [super init];
    if(self){
        if(dictionary)
        {
            if([dictionary isKindOfClass:[NSNull class]])
            {
                self = nil;
                return nil;
            }
            
            dictionary = [dictionary filterAllNSNullValues];
            
            if([dictionary objectForKey:@"batteryStatus"] != nil){
                if(dictionary[@"batteryStatus"] == [NSNull null]){
                    self = nil;
                    return nil;
                }
                dictionary = dictionary[@"batteryStatus"];
            }
            
            if(!dictionary){
                self = nil;
            } else {
                NSString *rawStatus = dictionary[@"status"];
                
                if([rawStatus isEqualToString:@"green"]){
                    _status = VLBatteryStatusColorGreen;
                } else if([rawStatus isEqualToString:@"yellow"]){
                    _status = VLBatteryStatusColorYellow;
                } else if([rawStatus isEqualToString:@"red"]){
                    _status = VLBatteryStatusColorRed;
                }
                
                _timestamp = dictionary[@"timestamp"];
            }
        }
    }
    return self;
}

@end
