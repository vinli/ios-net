//
//  VLVehiclePager.m
//  VinliSDK
//
//  Created by Tommy Brown on 5/26/15.
//  Copyright (c) 2015 Vinli. All rights reserved.
//

#import "VLVehiclePager.h"
#import "VLVehicle.h"
#import "NSDictionary+NonNullable.h"

@implementation VLVehiclePager

- (id) initWithDictionary:(NSDictionary *)dictionary{
    return [self initWithDictionary:dictionary service:nil];
}

- (id) initWithDictionary:(NSDictionary *)dictionary service:(VLService *)service {
    return [super initWithDictionary:dictionary service:service];
}

- (NSArray *)parseJSON:(NSDictionary *)json {
    
    NSArray* jsonArray = [json vl_getArrayAttributeForKey:@"vehicles" defaultValue:nil];
    NSMutableArray *vehiclesArray = [[NSMutableArray alloc] initWithCapacity:jsonArray.count];
    
    for( NSDictionary *v in jsonArray ) {
        VLVehicle *vehicle = [[VLVehicle alloc] initWithDictionary:v];
        if (vehicle) {
            [vehiclesArray addObject:vehicle];
        }
    }
    
    if (!_vehicles) {
        _vehicles = vehiclesArray;
    } else {
        NSMutableArray *mutableVehiclesArr = [_vehicles mutableCopy];
        [mutableVehiclesArr addObjectsFromArray:vehiclesArray];
        _vehicles = [mutableVehiclesArr copy];
    }
    
    
    return [vehiclesArray copy];
}


@end
