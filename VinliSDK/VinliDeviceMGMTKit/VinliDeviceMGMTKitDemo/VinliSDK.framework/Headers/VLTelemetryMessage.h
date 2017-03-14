//
//  VLTelemetryMessage.h
//  VinliSDK
//
//  Created by Tommy Brown on 5/21/15.
//  Copyright (c) 2015 Cheng Gu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface VLTelemetryMessage : NSObject

@property (readonly) NSString *messageId;
@property (readonly) NSString *timestamp;
@property (readonly) NSString *locationType;
@property (readonly) double latitude;
@property (readonly) double longitude;
@property (readonly) NSDictionary *data;

- (id) initWithDictionary: (NSDictionary *) dictionary;

@end
