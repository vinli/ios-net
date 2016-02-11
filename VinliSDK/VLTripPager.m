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

- (void)getLatestTrips:(NSURL *)url onSuccess:(void(^)(NSArray *values, NSError *error))completion
{
    
    
    // Use NSURLComponents to parse _lastestURL
    
    // Use components to call VLService startWithHost...
    
    //make call
    
    //if (completion)
    //pass in values
    
    
    if (url)
    {
       // NSURLComponents *components = [NSURLComponents componentsWithURL:self.priorURL resolvingAgainstBaseURL:NO];
        if (self.service)
        {
//            [self.service startWithHost:components.host path:components.path queries:nil HTTPMethod:@"GET" parameters:nil token:self.service.session.accessToken onSuccess:^(NSDictionary *result, NSHTTPURLResponse *response) {
              [self.service startWithHost:self.service.session.accessToken requestUri:[url absoluteString] onSuccess:^(NSDictionary *result, NSHTTPURLResponse *response) {
                
                  NSLog(@"%@", response);
                if (result)
                {
                    //use populate method
                    NSArray *latestTrips = [self poulateTrips:result];
                    
                    if (completion)
                    {
                        completion(latestTrips, nil);
                    }
                    
                }
                
                
            } onFailure:^(NSError *error, NSHTTPURLResponse *response, NSString *message) {
                NSLog(@"Could not start with Host");
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
