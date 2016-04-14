//
//  VLParametricFilter.m
//  VinliSDK
//
//  Created by Tommy Brown on 4/13/16.
//  Copyright © 2016 Vinli. All rights reserved.
//

#import "VLParametricFilter.h"

@implementation VLParametricFilter

#define TYPE @"parametric"

- (id) initWithParameter:(NSString *)parameter{
    return [self initWithParameter:parameter min:nil max:nil];
}

- (id) initWithParameter:(NSString *)parameter min:(NSNumber *)min max:(NSNumber *)max{
    self = [super init];
    
    if(self){
        self.parameter = parameter;
        self.min = min;
        self.max = max;
    }
    
    return self;
}

- (NSDictionary *) toDictionary{
    NSMutableDictionary *dictionary = [[NSMutableDictionary alloc] init];
    
    dictionary[@"type"] = @"filter";
    
    NSMutableDictionary *filterDictionary = [[NSMutableDictionary alloc] init];
    filterDictionary[@"type"] = TYPE;
    filterDictionary[@"parameter"] = self.parameter;
    
    if(self.min != nil){
        filterDictionary[@"min"] = self.min;
    }
    
    if(self.max != nil){
        filterDictionary[@"max"] = self.max;
    }
    
    dictionary[@"filter"] = filterDictionary;
    
    return dictionary;
}

@end
