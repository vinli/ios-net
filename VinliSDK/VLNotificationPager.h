//
//  VLNotificationPager.h
//  VinliSDK
//
//  Created by Lucas Thomas on 5/28/15.
//  Copyright (c) 2015 Vinli. All rights reserved.
//

#import "VLChronoPager.h"
#import "VLNotification.h"

@interface VLNotificationPager : VLChronoPager

@property (readonly) NSArray *notifications;

- (id) initWithDictionary:(NSDictionary *)dictionary;
- (id)initWithDictionary:(NSDictionary *)dictionary service:(VLService *)service;

- (void)getNextNotifications:(void (^)(NSArray *values, NSError *error))completion;

- (NSArray *)populateNotifications:(NSDictionary *)dictionary;





@end