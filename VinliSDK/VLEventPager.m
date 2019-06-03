//
//  VLEventPager.m
//  VinliSDK
//
//  Created by Lucas Thomas on 5/27/15.
//  Copyright (c) 2015 Vinli. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "VLEventPager.h"
#import "VLEvent.h"
#import "VLService.h"

@implementation VLEventPager : VLChronoPager;

- (id)initWithDictionary:(NSDictionary *)dictionary{
    return [self initWithDictionary:dictionary service:nil];
}

- (id)initWithDictionary:(NSDictionary *)dictionary service:(VLService *)service {
    if (self = [super initWithDictionary:dictionary service:service]) {
        _events =  [self parseJSON:dictionary];
    }
    return self;
}

- (void)getNextEvents:(void (^)(NSArray *, NSError *))completion {
    NSURL *url = self.priorURL ?: self.nextURL; //if there is a call to getNextEvents there should be a prior or a next url
    
    if (url && self.service) {
        [self.service startWithHost:self.service.session.accessToken requestUri:[url absoluteString] onSuccess:^(NSDictionary *result, NSHTTPURLResponse *response) {
            if (result) {
                //use populate method
                NSArray *latestEvents = [self parseJSON:result];
                
                if (completion) {
                    completion(latestEvents, nil);
                }
            }
        } onFailure:^(NSError *error, NSHTTPURLResponse *response, NSString *message) {
            NSLog(@"No next or prior URL");
        }];
    }
}

- (NSArray *)parseJSON:(NSDictionary *)dictionary {
    NSArray *ret =@[];
    if (dictionary && dictionary[@"events"]) {
        NSArray *json = dictionary[@"events"];
        NSMutableArray *events = [[NSMutableArray alloc] init];
        
        for (NSDictionary *event in json) {
            [events addObject:[[VLEvent alloc] initWithDictionary:event]];
        }
        
        ret = [NSArray arrayWithArray:events];
    }
    
    return ret;
}

@end
