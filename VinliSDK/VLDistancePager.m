//
//  VLDistancePager.m
//  VinliSDK
//
//  Created by Jai Ghanekar on 3/10/16.
//  Copyright © 2016 Vinli. All rights reserved.
//

#import "VLDistancePager.h"
#import "VLDistance.h"
#import "VLService.h"

@implementation VLDistancePager

- (instancetype) initWithDictionary:(NSDictionary *)dictionary {
   return [self initWithDictionary:dictionary service:nil];
}



- (instancetype)initWithDictionary:(NSDictionary *)dictionary service:(VLService *)service {
    if (self = [super initWithDictionary:dictionary service:nil])
    {
        if (self) {
            _distances = [self populateDistances:dictionary];
        }
    }
    
    return self;
}


- (NSArray *)populateDistances:(NSDictionary *)dictionary {
    if (dictionary) {
        if (dictionary[@"distances"]) {
            NSArray *json = dictionary[@"distances"];
            NSMutableArray *distancesArray = [[NSMutableArray alloc]init];
            
            for (NSDictionary *distance in json) {
                [distancesArray addObject:[[VLDistance alloc] initWithDictionary:distance]];
            }
            return distancesArray;
        }
    }
    return [NSArray new];
}



@end
