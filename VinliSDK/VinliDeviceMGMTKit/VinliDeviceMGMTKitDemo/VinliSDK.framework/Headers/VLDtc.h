//
//  VLDtc.h
//  VinliSDK
//
//  Created by Andrew Wells on 11/29/16.
//  Copyright © 2016 Vinli. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "VLChronoPager.h"
#import "VLParsable.h"

@interface VLDtc : NSObject
@property (readonly) NSString *codeId;
@property (readonly) NSString *vehicleId;
@property (readonly) NSString *deviceId;
@property (readonly) NSString *pid;
@property (readonly) NSString *codeDescription;

@property (readonly) NSString *startTimeStr;
@property (readonly) NSString *stopTimeStr;
@property (readonly) NSDate *startTime;
@property (readonly) NSDate *stopTime;

- (instancetype)initWithDictionary:(NSDictionary *)json;

@end


@interface VLDtcPager : VLChronoPager <VLParsable>
@property (readonly) NSArray *codes;
@end
