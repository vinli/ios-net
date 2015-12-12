//
//  VLLocationMessagePager.m
//  VinliSDK
//
//  Created by Josh Beridon on 5/27/15.
//  Copyright (c) 2015 Vinli. All rights reserved.
//

#import "VLLocationPager.h"
#import "VLLocation.h"

@implementation VLLocationPager

- (id) initWithDictionary:(NSDictionary *)dictionary{
    self = [super initWithDictionary:dictionary];
    if(self){
        if(dictionary){
            if(dictionary[@"locations"]){
                NSArray *jsonArray = dictionary[@"locations"][@"features"];
                NSMutableArray *locationsArray = [[NSMutableArray alloc] init];
                
                for(NSDictionary *location in jsonArray){
                    [locationsArray addObject:[[VLLocation alloc] initWithDictionary:location]];
                }
                _locations = locationsArray;
            }
        }
    }
    return self;
}
@end


