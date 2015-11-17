//
//  VLNotificationPage.m
//  VinliSDK
//
//  Created by Lucas Thomas on 5/28/15.
//  Copyright (c) 2015 Vinli. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "VLNotificationPager.h"

@implementation VLNotificationPager

- (id) initWithDictionary:(NSDictionary *)dictionary{
    self = [super initWithDictionary:dictionary];
    if(self){
        if(dictionary){
            if(dictionary[@"notifications"]){
                NSArray *json = dictionary[@"notifications"];
                NSMutableArray *notificationArray = [[NSMutableArray alloc] init];
                
                for(NSDictionary *notification in json){
                    if (notification) {
                        [notificationArray addObject:[[VLNotification alloc] initWithDictionary:notification]];
                    }
                }
                
                _notifications = notificationArray;
            }
        }
    }
    return self;
}

@end