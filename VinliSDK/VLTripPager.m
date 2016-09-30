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

@dynamic priorURL, nextURL, remaining;

- (id) initWithDictionary:(NSDictionary *)dictionary
{
    return [self initWithDictionary:dictionary service:nil];
}

- (id) initWithDictionary:(NSDictionary *)dictionary service:(VLService *)service
{
    if (self = [super initWithDictionary:dictionary service:service])
    {
        if(self){

            _trips = [self poulateTrips:dictionary];
        }

    }
    
    return self;
}

- (void)getNextTrips:(void(^)(NSArray *values, NSError *error))completion
{
    
   NSURL* url = (self.priorURL) ? self.priorURL : self.nextURL; //if there is a call to getNextTrips there should be a prior or a next url
    
        if (url && self.service)
        {

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
                NSLog(@"No next or prior URL");
            }];
        }
    
    else
    {
        return;     
    }
    
}

- (NSArray *)populateTrips:(NSDictionary *)dictionary
{
    if(dictionary)
    {
        dictionary = [dictionary filterAllNSNullValues];
        
        if(dictionary[@"trips"])
        {
            NSArray *json = dictionary[@"trips"];
            NSMutableArray *tripArray = [[NSMutableArray alloc] init];
            
            for(NSDictionary *trip in json)
            {
                VLTrip *aTrip = [[VLTrip alloc] initWithDictionary:trip];
                if (aTrip)
                {
                    [tripArray addObject:aTrip];
                }
            }
            return tripArray;
        }
       
    }
    
    return [NSArray new]; //if no dictionary is passed
    
}


@end
