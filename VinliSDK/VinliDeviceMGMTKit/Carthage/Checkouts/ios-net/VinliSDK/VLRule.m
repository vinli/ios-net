//
//  VLRule.m
//  VinliSDK
//
//  Created by Tommy Brown on 5/20/15.
//  Copyright (c) 2015 Cheng Gu. All rights reserved.
//

#import "VLRule.h"
#import "VLBoundary.h"
#import "VLParametricBoundary.h"
#import "VLRadiusBoundary.h"
#import "VLPolygonBoundary.h"
#import "NSDictionary+NonNullable.h"

@implementation VLRule

- (id) initWithName:(NSString *)name boundaries:(NSArray *)boundaries{
    self = [super init];
    if(self){
        _name = name;
        _boundaries = boundaries;
    }
    return self;
}

- (id) initWithDictionary:(NSDictionary *)dictionary{
    self = [super init];
    if(self){
        if (dictionary) {
            
            if(dictionary[@"rule"]){
                dictionary = dictionary[@"rule"];
            }
            
            _ruleId = dictionary[@"id"];
            _name = dictionary[@"name"];
            _deviceId = [dictionary vl_getStringAttributeForKey:@"deviceId" defaultValue:nil];
            _evaluated = [dictionary[@"evaluated"] boolValue];
            
            if(!_evaluated){
                _coveredState = CoveredStateNull;
            }else{
                bool covered = [dictionary[@"covered"] boolValue];
                _coveredState = (covered) ? CoveredStateTrue : CoveredStateFalse;
            }
            
            if(dictionary[@"links"]){
                _selfURL = [NSURL URLWithString:dictionary[@"links"][@"self"]];
                _eventsURL = [NSURL URLWithString:dictionary[@"links"][@"events"]];
                _subscriptionsURL = [NSURL URLWithString:dictionary[@"links"][@"subscriptions"]];
            }
            
            NSDictionary* associatedObject = [dictionary vl_getDictionaryAttributeForKey:@"object" defaultValue:nil];
            if (associatedObject && [associatedObject[@"type"] isEqualToString:@"vehicle"]) {
                _vehicleId = [associatedObject vl_getStringAttributeForKey:@"id" defaultValue:nil];
            }
            
            if(dictionary[@"boundaries"]){
                NSArray *jsonArray = dictionary[@"boundaries"];
                if(jsonArray != nil && jsonArray.count > 0){
                    NSMutableArray *boundaryArray = [[NSMutableArray alloc] init];
                    for(NSDictionary *dict in jsonArray){
                        
                        NSString *type = dict[@"type"];
                        
                        if([type isEqualToString:@"parametric"]){
                            [boundaryArray addObject:[[VLParametricBoundary alloc] initWithDictionary:dict]];
                        }else if([type isEqualToString:@"radius"]){
                            [boundaryArray addObject:[[VLRadiusBoundary alloc] initWithDictionary:dict]];
                        }else{
                            [boundaryArray addObject:[[VLPolygonBoundary alloc] initWithDictionary:dict]];
                        }
                    }
                    _boundaries = boundaryArray;
                }
            }
        }
    }
    return self;
}

- (NSDictionary *) toDictionary{
    NSMutableDictionary *dictionary = [[NSMutableDictionary alloc] init];
    NSMutableDictionary *rule = [[NSMutableDictionary alloc] init];
    rule[@"name"] = _name;
    NSMutableArray *boundaryArray = [[NSMutableArray alloc] init];
    for(VLBoundary *boundary in _boundaries){
        [boundaryArray addObject:[boundary toDictionary]];
    }
    rule[@"boundaries"] = boundaryArray;
    dictionary[@"rule"] = rule;
    return dictionary;
}

- (NSString *) description{
    return [NSString stringWithFormat: @"Rule ID:%@, Name:%@", _ruleId, _name];
}

@end
