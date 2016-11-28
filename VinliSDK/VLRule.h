//
//  VLRule.h
//  VinliSDK
//
//  Created by Tommy Brown on 5/20/15.
//  Copyright (c) 2015 Cheng Gu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "VLBoundary.h"

typedef NS_ENUM(NSInteger, CoveredState){
    CoveredStateTrue,
    CoveredStateFalse,
    CoveredStateNull
};

@interface VLRule : NSObject

@property  NSString *name;
@property  NSArray *boundaries;

@property (readonly) NSString *ruleId;
@property (readonly) NSString *deviceId;
@property (readonly) NSString *vehicleId;
@property (readonly) BOOL evaluated;
@property (readonly) CoveredState coveredState;

@property (readonly) NSURL *selfURL;
@property (readonly) NSURL *eventsURL;
@property (readonly) NSURL *subscriptionsURL;

- (id) initWithName: (NSString *) name boundaries:(NSArray *)boundaries;
- (id) initWithDictionary: (NSDictionary *) dictionary;

- (NSDictionary *) toDictionary;

@end
