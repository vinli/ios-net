//
//  VLTripPager.m
//  VinliSDK
//
//  Created by Tommy Brown on 5/26/15.
//  Copyright (c) 2015 Vinli. All rights reserved.
//

#import "VLTripPager.h"
#import "VLService.h"

@implementation VLTripPager

- (id) initWithDictionary:(NSDictionary *)dictionary{
    return [self initWithDictionary:dictionary service:nil];
}

- (id) initWithDictionary:(NSDictionary *)dictionary service:(VLService *)service
{
    if (self = [super initWithDictionary:dictionary service:service])
    {
        if(self){
//            if(dictionary){
//                if(dictionary[@"trips"]){
//                    NSArray *json = dictionary[@"trips"];
//                    NSMutableArray *tripArray = [[NSMutableArray alloc] init];
//                    
//                    for(NSDictionary *trip in json){
//                        [tripArray addObject:[[VLTrip alloc] initWithDictionary:trip]];
//                    }
//                    
//                    _trips = tripArray;
//                }
//            }
            _trips = [self poulateTrips:dictionary];
        }

    }
    
    return self;
}

- (void)getLatestValues:(void(^)(NSArray *values, NSError *error))completion
{
    
    
    // Use NSURLComponents to parse _lastestURL
    
    // Use components to call VLService startWithHost...
    
    //make call
    
    //if (completion)
    //pass in values
    
    if (self.latestURL)
    {
        NSURLComponents *components = [NSURLComponents componentsWithURL:self.latestURL resolvingAgainstBaseURL:YES];
        if (self.service)
        {
            [self.service startWithHost:components.host path:components.path queries:nil HTTPMethod:@"GET" parameters:nil token:self.service.session.accessToken onSuccess:^(NSDictionary *result, NSHTTPURLResponse *response) {
                
                if (result)
                {
                    //use populate method
                }
                
                
            } onFailure:^(NSError *error, NSHTTPURLResponse *response, NSString *message) {
                //
            }];
        }
        else
        {
            return;
        }
    }
    else
    {
        return;
    }
    
}

- (NSArray *)poulateTrips:(NSDictionary *)dictionary
{
    if(dictionary) {
        if(dictionary[@"trips"]){
            NSArray *json = dictionary[@"trips"];
            NSMutableArray *tripArray = [[NSMutableArray alloc] init];
            
            for(NSDictionary *trip in json){
                [tripArray addObject:[[VLTrip alloc] initWithDictionary:trip]];
            }
            return tripArray;
        }
       
    }
    
    return [NSArray new]; //if no dictionary is passed
    
}


@end
