//
//  VLVehiclePager.m
//  VinliSDK
//
//  Created by Tommy Brown on 5/26/15.
//  Copyright (c) 2015 Vinli. All rights reserved.
//

#import "VLVehiclePager.h"
#import "VLVehicle.h"

@implementation VLVehiclePager

- (id) initWithDictionary:(NSDictionary *)dictionary{
    return [self initWithDictionary:dictionary service:nil];
}

- (id) initWithDictionary:(NSDictionary *)dictionary service:(VLService *)service
{
    if (self = [super initWithDictionary:dictionary service:service])
    {
        if(dictionary){
            if(dictionary[@"vehicles"]){
                
                NSArray *jsonArray = dictionary[@"vehicles"];
                NSMutableArray *vehiclesArray = [[NSMutableArray alloc] init];
                
                for(NSDictionary *vehicle in jsonArray){
                    [vehiclesArray addObject:[[VLVehicle alloc] initWithDictionary:vehicle]];
                }
                
                _vehicles = vehiclesArray;
            }
        }
    }
    return self;
}





@end
