//
//  VLTimeSeries.m
//  MyVinli
//
//  Created by Andrew Wells on 1/15/16.
//  Copyright © 2016 Vinli, inc. All rights reserved.
//

#import "VLTimeSeries.h"
#import "VLDateFormatter.h"




@implementation VLTimeSeries



+ (instancetype)timeSeriesFromPreviousNumberOfWeeks:(NSInteger)numWeeks
{
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDateComponents *comps = [NSDateComponents new];
    comps.weekOfYear = - numWeeks;
    NSDate *previousWeekOfCurrentDate = [calendar dateByAddingComponents:comps toDate:[NSDate date] options:0];
    
    //NSDateComponents *components = [calendar components:NSMonthCalendarUnit|NSDayCalendarUnit fromDate:date];
    
    VLTimeSeries* timeSeries = [VLTimeSeries new];
    timeSeries.since = previousWeekOfCurrentDate;
    
    return timeSeries;

}

+ (instancetype)timeSeriesLast7Days
{
    return [VLTimeSeries timeSeriesFromPreviousNumberOfWeeks:1];
}


+ (instancetype)timeSeriesFromDate:(NSDate *)date until:(NSDate *)until
{
    VLTimeSeries *timeSeries = [VLTimeSeries new];
    
    timeSeries.since = date;
    timeSeries.until = until;
    return timeSeries;
    
}


+ (instancetype)timeSeriesFromDate:(NSDate *)date
{
//    VLTimeSeries* timeSeries = [VLTimeSeries new];
//  //  timeSeries.until = date; //should this be since as well
    
    NSDate *now = [NSDate date];
    VLTimeSeries *timeSeries = [VLTimeSeries timeSeriesFromDate:date until:now];
    return timeSeries;
}


- (void)setOrder:(NSInteger)order
{
    self.sortOrder = order;
}

- (NSDictionary *)toDictionary
{
    NSMutableDictionary* retVal = [NSMutableDictionary new];
    if (self.since) {
        NSString* sinceDateStr = [VLDateFormatter stringFromDate:self.since];
        if (sinceDateStr.length > 0) {
            [retVal setObject:sinceDateStr forKey:@"since"];
        }
    }
    
    if (self.until) {
        NSString* untilDateStr = [VLDateFormatter stringFromDate:self.until];
        if (untilDateStr.length > 0) {
            [retVal setObject:untilDateStr forKey:@"until"];
        }
    }
    
    if (self.limit) {
        [retVal setObject:self.limit forKey:@"limit"];
    }
    
    if (self.sortOrder) {
        if (self.sortOrder == VLTimerSeriesSortDirectionAscending) {
            [retVal setObject:@"asc" forKey:@"sortDir"]; //make a bit more clean later
        }
    }
    
    
    return [retVal copy];
}

@end
