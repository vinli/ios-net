//
//  VLOdometerPager.m
//  VinliSDK
//
//  Created by Jai Ghanekar on 3/14/16.
//  Copyright © 2016 Vinli. All rights reserved.
//

#import "VLOdometerPager.h"
#import "VLOdometer.h"


@implementation VLOdometerPager




- (instancetype) initWithDictionary:(NSDictionary *)dictionary {
    return [self initWithDictionary:dictionary service:nil];
}




- (instancetype)initWithDictionary:(NSDictionary *)dictionary service:(VLService *)service {
    if (self = [super initWithDictionary:dictionary service:service]) {
        if (self) {
            _odometers = [self populateOdometers:dictionary];
        }
        
    }
    return self;
}



- (NSArray *)populateOdometers:(NSDictionary *)dictionary {
    if (dictionary) {
        if (dictionary[@"odometers"]) {
            NSArray *json = dictionary[@"odometers"];
            NSMutableArray *odometerArray = [[NSMutableArray alloc]init];
            
            for (NSDictionary *odometer in json) {
                [odometerArray addObject:[[VLOdometer alloc]initWithDictionary:odometer]];
            }
            return odometerArray;
        }
    }
    return [NSArray new];
}




@end
