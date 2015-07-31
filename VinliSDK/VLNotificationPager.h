//
//  VLNotificationPager.h
//  VinliSDK
//
//  Created by Lucas Thomas on 5/28/15.
//  Copyright (c) 2015 Vinli. All rights reserved.
//

#import "VLOffsetPager.h"
#import "VLNotification.h"

@interface VLNotificationPager : VLOffsetPager

@property (readonly) NSArray *notifications;

- (id) initWithDictionary:(NSDictionary *)dictionary;

@end