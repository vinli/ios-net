//
//  VLChronoPager.m
//  VinliSDK
//
//  Created by Tommy Brown on 5/26/15.
//  Copyright (c) 2015 Vinli. All rights reserved.
//

#import "VLChronoPager.h"
#import "VLService.h"

@implementation VLChronoPager

- (id) initWithDictionary:(NSDictionary *)dictionary {
    
    return [self initWithDictionary:dictionary service:nil];
}

- (id) initWithDictionary:(NSDictionary *)dictionary service:(VLService *)service
{

    
    if (self = [super initWithDictionary:dictionary service:service]) {
        if(dictionary && dictionary[@"meta"] && dictionary[@"meta"][@"pagination"]){
            _remaining = [dictionary[@"meta"][@"pagination"][@"remaining"] unsignedLongValue];//tbd this maybe should be remainingCount.
            _until = dictionary[@"meta"][@"pagination"][@"until"];
            _since = dictionary[@"meta"][@"pagination"][@"since"];
            if(dictionary[@"meta"][@"pagination"][@"links"]){
                _latestURL = [NSURL URLWithString:dictionary[@"meta"][@"pagination"][@"links"][@"latest"]];
                _priorURL = [NSURL URLWithString:dictionary[@"meta"][@"pagination"][@"links"][@"prior"]];
            }
        }

    }
    return self;
}




@end
