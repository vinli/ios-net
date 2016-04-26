//
//  VLSnapshotPager.m
//  VinliSDK
//
//  Created by Josh Beridon on 5/29/15.
//  Copyright (c) 2015 Vinli. All rights reserved.
//

#import "VLSnapshotPager.h"
#import "VLSnapshot.h"
#import "VLService.h"

@implementation VLSnapshotPager

- (id) initWithDictionary:(NSDictionary *)dictionary fields:(NSString *)fields{
    
    return [self initWithDictionary:dictionary service:nil fields:fields];
}

- (id)initWithDictionary:(NSDictionary *)dictionary service:(VLService *)service fields:(NSString *)fields
{
    if (self = [super initWithDictionary:dictionary service:service])
    {

        _snapshots = [self populateSnapshots:dictionary fields:fields];
    }
    return self;
}


- (NSArray *)populateSnapshots:(NSDictionary *)dictionary fields:(NSString *)fields
{
    if(dictionary){
        if(dictionary[@"snapshots"]) {
            NSArray *jsonArray = dictionary[@"snapshots"];
            NSMutableArray *snapshotsArray = [[NSMutableArray alloc] init];
            for(NSDictionary *snapshot in jsonArray){
                [snapshotsArray addObject:[[VLSnapshot alloc] initWithDictionary:snapshot fields:fields]];
            }
            
            return snapshotsArray;
        }
    }
    return [NSArray new];
}


- (void)getNextSnapshots:(void (^)(NSArray *, NSError *))completion
{
    NSURL* url = (self.priorURL) ? self.priorURL : self.nextURL; //if there is a call to getNextSnapshots there should be a prior or a next url
    
    if (url && self.service)
    {
        
        [self.service startWithHost:self.service.session.accessToken requestUri:[url absoluteString] onSuccess:^(NSDictionary *result, NSHTTPURLResponse *response) {
            
            NSLog(@"%@", response);
            if (result)
            {
                //use populate method
                
                NSArray *latestSnapshots = [self populateSnapshots:result fields:nil]; //should this be nil? 
                
                if (completion)
                {
                    completion(latestSnapshots, nil);
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




@end
