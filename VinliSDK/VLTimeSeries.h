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
@property (assign, nonatomic) VLTimerSeriesSortDirection sortOrder;

// Limit doesnt need to be set - Defaults to 20
@property (strong, nonatomic) NSNumber* limit;

+ (instancetype)timeSeriesLast7Days;
+ (instancetype)timeSeriesFromPreviousNumberOfWeeks:(NSInteger)numWeeks;
+ (instancetype)timeSeriesFromDate:(NSDate *)date;
+ (instancetype)timeSeriesFromDate:(NSDate *)date until:(NSDate *)until;


- (void)setOrder:(NSInteger)order;
- (NSDictionary *)toDictionary;

@end
