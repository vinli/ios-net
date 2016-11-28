//
//  VLSnapshot.h
//  VinliSDK
//
//  Created by Josh Beridon on 5/29/15.
//  Copyright (c) 2015 Vinli. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface VLSnapshot : NSObject

@property (readonly) NSString *snapShotId;
@property (readonly) NSString *timeStampStr;
@property (readonly) NSDate *timeStamp;
@property (readonly) NSDictionary *data;

- (id) initWithDictionary: (NSDictionary *) dictionary fields:(NSString *)fields;

@end
