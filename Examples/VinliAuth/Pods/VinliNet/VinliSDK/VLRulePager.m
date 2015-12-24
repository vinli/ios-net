//
//  VLRulePager.m
//  VinliSDK
//
//  Created by Tommy Brown on 5/26/15.
//  Copyright (c) 2015 Vinli. All rights reserved.
//

#import "VLRulePager.h"

@implementation VLRulePager

- (id) initWithDictionary:(NSDictionary *)dictionary{
    self = [super initWithDictionary:dictionary];
    if(self){
        if(dictionary){
            if(dictionary[@"rules"]){
                NSArray *json = dictionary[@"rules"];
                NSMutableArray *rulesArray = [[NSMutableArray alloc] init];
                
                for(NSDictionary *rule in json){
                    [rulesArray addObject:[[VLRule alloc] initWithDictionary:rule]];
                }
                
                _rules = rulesArray;
            }
        }
    }
    return self;
}

@end
