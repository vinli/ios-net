//
//  VLParametricBoundary.m
//  VinliSDK
//
//  Created by Tommy Brown on 6/8/15.
//  Copyright (c) 2015 Vinli. All rights reserved.
//

#import "VLParametricBoundary.h"

@implementation VLParametricBoundary

- (id) init{
    self = [super initWithType:@"parametric"];
    if(self){
    }
    return self;
}

- (id) initWithParameter:(NSString *)parameter min:(unsigned long)min max:(unsigned long)max{
    self = [super initWithType:@"parametric"];
    if(self){
        _parameter = parameter;
        _min = min;
        _max = max;
    }
    return self;
}

- (id) initWithDictionary:(NSDictionary *)dictionary{
    self = [super initWithDictionary:dictionary];
    if(self){
        _parameter = dictionary[@"parameter"];
        
        if(dictionary[@"min"]){
            _min = [dictionary[@"min"] longValue];
        } else{
            _min = NSNotFound;
        }
        
        if(dictionary[@"max"]){
            _max = [dictionary[@"max"] longValue];
        } else{
            _max = NSNotFound;
        }
    }
    return self;
}

- (NSDictionary *) toDictionary{
    NSMutableDictionary *dictionary = (NSMutableDictionary *) [super toDictionary];
    
    dictionary[@"parameter"] = _parameter;
    
    if(_min != NSNotFound){
        dictionary[@"min"] = [NSNumber numberWithUnsignedLong:_min];
    }
    
    if(_max != NSNotFound){
        dictionary[@"max"] = [NSNumber numberWithUnsignedLong:_max];
    }
    
    return dictionary;
}

- (NSString *) description{
    return [NSString stringWithFormat:@"Parameter: %@, Min: %lu, Max: %lu", _parameter, _min, _max];
}

@end
