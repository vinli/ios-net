//
//  VLLocationMessagePager.m
//  VinliSDK
//
//  Created by Josh Beridon on 5/27/15.
//  Copyright (c) 2015 Vinli. All rights reserved.
//

#import "VLLocationPager.h"
#import "VLLocation.h"
#import "VLService.h"

@implementation VLLocationPager

- (id) initWithDictionary:(NSDictionary *)dictionary{
 
    return [self initWithDictionary:dictionary service:nil];
}



- (id) initWithDictionary:(NSDictionary *)dictionary service:(VLService *)service
{
    if (self = [super initWithDictionary:dictionary service:service])
    {
        _locations = [self populateLocations:dictionary];
    }
    return self;
}


- (void)getNextLocations:(void (^)(NSArray *, NSError *))completion
{
    NSURL* url = (self.priorURL) ? self.priorURL : self.nextURL; //if there is a call to getNextLocations there should be a prior or a next url
    
    if (url && self.service)
    {
        
        [self.service startWithHost:self.service.session.accessToken requestUri:[url absoluteString] onSuccess:^(NSDictionary *result, NSHTTPURLResponse *response) {
            
            NSLog(@"%@", response);
            if (result)
            {
                //use populate method
                NSArray *latestLocations = [self populateLocations:result];
                
                if (completion)
                {
                    completion(latestLocations, nil);
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

- (NSArray *)populateLocations:(NSDictionary *)dictionary
{
    if(dictionary){
        if(dictionary[@"locations"]){
            NSArray *jsonArray = dictionary[@"locations"][@"features"];
            NSMutableArray *locationsArray = [[NSMutableArray alloc] init];
            
            for(NSDictionary *location in jsonArray){
                [locationsArray addObject:[[VLLocation alloc] initWithDictionary:location]];
            }
            return locationsArray;
        }
    }
    return [NSArray new];
}

@end


