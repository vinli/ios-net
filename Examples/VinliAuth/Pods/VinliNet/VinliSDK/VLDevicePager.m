//
//  VLDevicePager.m
//  VinliSDK
//
//  Created by Josh Beridon on 5/28/15.
//  Copyright (c) 2015 Vinli. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "VLDevicePager.h"

@implementation VLDevicePager

- (id) initWithDictionary:(NSDictionary *)dictionary{
    self = [super initWithDictionary:dictionary];
    if(self){
        if(dictionary){
            if(dictionary[@"devices"]){
                NSArray *json = dictionary[@"devices"];
                NSMutableArray *deviceArray = [[NSMutableArray alloc] init];
                
                for(NSDictionary *device in json){
                    [deviceArray addObject:[[VLDevice alloc] initWithDictionary:device]];
                }
                
                _devices = deviceArray;
            }
        }
    }
    return self;
}

@end
