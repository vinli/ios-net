//
//  VLDevice.h
//  VinliSDK
//
//  Created by Cheng Gu on 8/21/14.
//  Copyright (c) 2014 Cheng Gu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface VLDevice : NSObject

@property (readonly) NSString *deviceId;
@property (readonly) NSString *name;
@property (readonly) NSString *unlockToken;
@property (readonly) NSURL *selfURL;
@property (readonly) NSURL *vehiclesURL;
@property (readonly) NSURL *latestVehicleURL;
@property (readonly) NSURL *rulesURL;
@property (readonly) NSURL *eventsURL;
@property (readonly) NSURL *subscriptionsURL;
@property (readonly) NSURL *iconURL;
@property (readonly) NSString* chipID;

- (id) initWithDictionary: (NSDictionary *) dictionary;

@end
