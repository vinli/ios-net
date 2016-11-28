//
//  VLReportCard.h
//  VinliSDK
//
//  Created by Andrew Wells on 11/16/16.
//  Copyright © 2016 Vinli. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface VLReportCard : NSObject
@property (readonly) NSString *reportId;
@property (readonly) NSString *deviceId;
@property (readonly) NSString *vehicleId;
@property (readonly) NSString *tripId;
@property (readonly) NSString *grade;


- (instancetype)initWithDictionary:(NSDictionary *)json;

@end

@interface VLOverallReportCard : NSObject
@property (readonly) NSString *overallGrade;
@property (readonly) NSNumber *tripSampleSize;
@property (readonly) NSDictionary *gradeCount;

- (instancetype)initWithDictionary:(NSDictionary *)json;

@end
