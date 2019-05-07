//
//  VLTripPager.m
//  VinliSDK
//
//  Created by Tommy Brown on 5/26/15.
//  Copyright (c) 2015 Vinli. All rights reserved.
//

#import "VLTripPager.h"
#import "VLService.h"

#import "NSDictionary+NonNullable.h"

@interface VLTripPager()
@property (strong, nonatomic) NSURL* priorURL;
@property (strong, nonatomic) NSURL* nextURL;
@property (assign, readwrite) NSInteger remainingTrips;
@property (readwrite) unsigned long remaining;

@end

@implementation VLTripPager

@dynamic priorURL, nextURL, remaining;

- (instancetype)initWithDictionary:(NSDictionary *)dictionary service:(VLService *)service
{
    if (self = [super initWithDictionary:dictionary service:service])
    {
        _trips = [NSMutableArray arrayWithArray:[self populateTrips:dictionary]];
    }
    
    return self;
}

- (void)getNextTrips:(void (^)(NSArray<VLTrip *> * _Nullable nextTrips, NSError * _Nullable))completion
{
    if (!self.service)
    {
        NSError *error = [NSError errorWithDomain:@"Needs authentication in order to get next set of trips" code:NSURLErrorUserAuthenticationRequired userInfo:nil];
        
        if (completion)
        {
            completion(nil, error);
            return;
        }
    }
    
    if (self.remaining == 0)
    {
        if (self.priorURL || self.nextURL)
        {
            // Error
            NSError *error = [NSError errorWithDomain:@"If there are zero remaining trips, the pager should not have any next or prior links." code:NSURLErrorUnknown userInfo:nil];
            
            if (completion)
            {
                completion(nil, error);
            }
            return;
        }
        
        // Since there are zero remaining trips and there are no links to query the next set of trips we should return an empty array
        if (completion)
        {
            completion([NSArray new], nil);
        }
        return;
    }
    
   NSURL* url = (self.priorURL) ? self.priorURL : self.nextURL;
    
        if (url && self.service)
        {
              [self.service startWithHost:self.service.session.accessToken requestUri:[url absoluteString] onSuccess:^(NSDictionary *result, NSHTTPURLResponse *response) {
                  
                  result = [result filterAllNSNullValues];
                  
                  NSDictionary* paginationDict = [result valueForKeyPath:@"meta.pagination"];
                  
                  NSNumber *remainingTrips = (NSNumber *)paginationDict[@"remaining"];
                  self.remaining = remainingTrips.unsignedIntegerValue;
                  
                  NSDictionary* links = paginationDict[@"links"];
                  
                  if (links)
                  {
                      NSString* priorStr = links[@"prior"];
                      self.priorURL = priorStr.length > 0 ? [NSURL URLWithString:priorStr] : nil;
                      NSString* nextStr = links[@"next"];
                      self.nextURL = nextStr.length > 0 ? [NSURL URLWithString:nextStr] : nil;
                  }
            
                if (result)
                {
                    NSArray *latestTrips = [self populateTrips:result];
                    
                    if (latestTrips.count > 0)
                    {
                        [self.trips addObjectsFromArray:latestTrips];
                    }
                    
                    if (completion)
                    {
                        completion(latestTrips, nil);
                    }
                    
                }
                
            } onFailure:^(NSError *error, NSHTTPURLResponse *response, NSString *message) {
                
                if (completion)
                {
                    completion(nil, error);
                }
            }];
        }
}

- (NSArray *)populateTrips:(NSDictionary *)dictionary
{
    if (dictionary)
    {
        dictionary = [dictionary filterAllNSNullValues];
        
        if (dictionary[@"trips"])
        {
            NSArray *json = dictionary[@"trips"];
            NSMutableArray *tripArray = [[NSMutableArray alloc] init];
            
            for (NSDictionary *trip in json)
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

- (NSArray *)parseJSON:(NSDictionary *)json {
    return [self populateTrips:json];
}


@end
