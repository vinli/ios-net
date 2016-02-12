//
//  VLTelemetryMessagePager.m
//  VinliSDK
//
//  Created by Josh Beridon on 5/26/15.
//  Copyright (c) 2015 Vinli. All rights reserved.
//

#import "VLTelemetryMessagePager.h"
#import "VLTelemetryMessage.h"
#import "VLService.h"

@implementation VLTelemetryMessagePager

- (id) initWithDictionary:(NSDictionary *)dictionary{

    return [self initWithDictionary:dictionary service:nil];
}

- (id)initWithDictionary:(NSDictionary *)dictionary service:(VLService *)service
{
    if (self = [super initWithDictionary:dictionary service:service])
    {
        _messages = [self populateMessages:dictionary];
    }
    return self;
}


- (void)getNextMessages:(void (^)(NSArray *, NSError *))completion
{
    NSURL* url = (self.priorURL) ? self.priorURL : self.nextURL; //if there is a call to getNextEvents there should be a prior or a next url
    
    if (url && self.service)
    {
        
        [self.service startWithHost:self.service.session.accessToken requestUri:[url absoluteString] onSuccess:^(NSDictionary *result, NSHTTPURLResponse *response) {
            
            NSLog(@"%@", response);
            if (result)
            {
                //use populate method
                NSArray *latestMessages = [self populateMessages:result];
                
                if (completion)
                {
                    completion(latestMessages, nil);
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


- (NSArray *)populateMessages:(NSDictionary *)dictionary
{
    if(dictionary){
        if(dictionary[@"messages"]){
            NSArray *jsonArray = dictionary[@"messages"];
            NSMutableArray *messagesArray = [[NSMutableArray alloc] init];
            for(NSDictionary *message in jsonArray){
                [messagesArray addObject:[[VLTelemetryMessage alloc] initWithDictionary:message]];
            }
            return messagesArray;
        }
    }
    return [NSArray new];
}





@end
