//
//  VLLocationMessage.h
//  VinliSDK
//
//  Created by Josh Beridon on 5/27/15.
//  Copyright (c) 2015 Vinli. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface VLLocation : NSObject

@property (readonly) NSString *locationType;

@property (readonly) NSString *geometryType;
@property (readonly) double longitude;
@property (readonly) double latitude;

@property (readonly) NSString *locationId;
@property (readonly) NSString *timeStampStr;
@property (readonly) NSDate *timeStamp;

@property (readonly) NSDictionary *properties;

- (id) initWithDictionary: (NSDictionary *) dictionary;

@end
