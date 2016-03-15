
//  VLDistance.m
//  VinliSDK
//
//  Created by Jai Ghanekar on 3/10/16.
//  Copyright © 2016 Vinli. All rights reserved.
//

#import "VLDistance.h"
#import "NSDictionary+NonNullable.h"





@implementation VLDistance


- (instancetype)initWithDictionary:(NSDictionary *)dictionary {
    self = [super init];
    
    if (self){
        if (dictionary) {
            if (dictionary[@"distance"] != nil) {
                dictionary = dictionary[@"distance"];
            }
            _confidenceMin = [dictionary jsonObjectForKey:@"confidenceMin"] ;
            _confidenceMax = [dictionary jsonObjectForKey:@"confidenceMax"];
            _value = [dictionary jsonObjectForKey:@"value"];
            _lastOdometer = [dictionary jsonObjectForKey:@"lastOdometerDate"];

        }
    }
    
    
    return self;
}








@end
