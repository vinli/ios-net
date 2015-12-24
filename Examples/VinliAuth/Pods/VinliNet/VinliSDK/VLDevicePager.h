//
//  VLDevicePager.h
//  VinliSDK
//
//  Created by Josh Beridon on 5/28/15.
//  Copyright (c) 2015 Vinli. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "VLOffsetPager.h"
#import "VLDevice.h"

@interface VLDevicePager : VLOffsetPager

@property (readonly) NSArray *devices;

- (id) initWithDictionary:(NSDictionary *)dictionary;

@end
