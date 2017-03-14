//
//  VLCode.m
//  VinliSDK
//
//  Created by Andrew Wells on 11/28/16.
//  Copyright © 2016 Vinli. All rights reserved.
//

#import "VLCode.h"
#import "NSDictionary+NonNullable.h"

@implementation VLCode

- (instancetype)initWithDictionary:(NSDictionary *)json {
    if (self = [super init]) {
        if ([json vl_getDictionaryAttributeForKey:@"code" defaultValue:nil]) {
            json = json[@"code"];
        }
        
        if (json) {
            _codeId = [json vl_getStringAttributeForKey:@"id" defaultValue:nil];
            _make = [json vl_getStringAttributeForKey:@"make" defaultValue:nil];
            _system = [json vl_getStringAttributeForKey:@"system" defaultValue:nil];
            _subSystem = [json vl_getStringAttributeForKey:@"subSystem" defaultValue:nil];
            _pid = [json vl_getStringAttributeForKey:@"number" defaultValue:nil];
            _codeDescription = [json vl_getStringAttributeForKey:@"description" defaultValue:nil];
            
            _twoByte = [json vl_getDictionaryAttributeForKey:@"twoByte" defaultValue:nil];
            _threeByte = [json vl_getDictionaryAttributeForKey:@"threeByte" defaultValue:nil];
        }
    }
    return self;
}

@end

@implementation VLCodePager

- (NSArray *)parseJSON:(NSDictionary *)json {
    NSArray* jsonArr = [json vl_getArrayAttributeForKey:@"codes" defaultValue:nil];
    NSMutableArray *newCodes = [[NSMutableArray alloc] initWithCapacity:jsonArr.count];
    
    for (NSDictionary *dic in jsonArr) {
        VLCode *code = [[VLCode alloc] initWithDictionary:dic];
        if (code) {
            [newCodes addObject:code];
        }
    }
    
    if (!_codes) {
        _codes = [newCodes copy];
    }
    else {
        NSMutableArray* mutableCodes = [_codes mutableCopy];
        [mutableCodes addObjectsFromArray:newCodes];
        _codes = [mutableCodes copy];
    }
    
    return newCodes;
}

@end
