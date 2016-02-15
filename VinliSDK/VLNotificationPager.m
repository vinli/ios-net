//
//  VLNotificationPage.m
//  VinliSDK
//
//  Created by Lucas Thomas on 5/28/15.
//  Copyright (c) 2015 Vinli. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "VLNotificationPager.h"
#import "VLService.h"

@implementation VLNotificationPager

- (id) initWithDictionary:(NSDictionary *)dictionary{
    return [self initWithDictionary:dictionary service:nil];
}

- (id) initWithDictionary:(NSDictionary *)dictionary service:(VLService *)service
{
    if (self = [super initWithDictionary:dictionary service:service])
    {
        _notifications =  [self populateNotifications:dictionary];
    }
    return self;
}


- (void)getNextNotifications:(void (^)(NSArray *, NSError *))completion
{
    NSURL* url = (self.priorURL) ? self.priorURL : self.nextURL; //if there is a call to getNextEvents there should be a prior or a next url
    
    if (url && self.service)
    {
        
        [self.service startWithHost:self.service.session.accessToken requestUri:[url absoluteString] onSuccess:^(NSDictionary *result, NSHTTPURLResponse *response) {
            
            NSLog(@"%@", response);
            if (result)
            {
                //use populate method
                NSArray *latestNotifications = [self populateNotifications:result];
                
                if (completion)
                {
                    completion(latestNotifications, nil);
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


- (NSArray *)populateNotifications:(NSDictionary *)dictionary
{
    if(dictionary){
        if(dictionary[@"notifications"]){
            NSArray *json = dictionary[@"notifications"];
            NSMutableArray *notificationArray = [[NSMutableArray alloc] init];
            
            for(NSDictionary *notification in json){
                if (notification) {
                    [notificationArray addObject:[[VLNotification alloc] initWithDictionary:notification]];
                }
            }
            
           return notificationArray;
        }
    }
    return [NSArray new];
}

@end