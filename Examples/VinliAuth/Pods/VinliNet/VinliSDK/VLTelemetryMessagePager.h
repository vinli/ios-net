//
//  VLTelemetryMessagePager.h
//  VinliSDK
//
//  Created by Josh Beridon on 5/26/15.
//  Copyright (c) 2015 Vinli. All rights reserved.
//

#import "VLChronoPager.h"

@interface VLTelemetryMessagePager : VLChronoPager

@property (readonly) NSArray *messages;

- (id) initWithDictionary:(NSDictionary *)dictionary;

@end



