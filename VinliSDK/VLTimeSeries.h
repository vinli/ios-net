//
//  VLTimeSeries.h
//  MyVinli
//
//  Created by Andrew Wells on 1/15/16.
//  Copyright © 2016 Vinli, inc. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, VLTimerSeriesSortDirection){
    VLTimerSeriesSortDirectionDescending,
    VLTimerSeriesSortDirectionAscending
};

@interface VLTimeSeries : NSObject

@property (strong, nonatomic) NSDate* since;
@property (strong, nonatomic) NSDate* until;

// Limit doesnt need to be set - Defaults to 20
@property (strong, nonatomic) NSNumber* limit;

+ (instancetype)timeSeriesLast7Days;
+ (instancetype)timeSeriesFromPreviousNumberOfWeeks:(NSInteger)numWeeks;
+ (instancetype)timeSeriesFromDate:(NSDate *)date;

- (NSDictionary *)toDictionary;

@end
