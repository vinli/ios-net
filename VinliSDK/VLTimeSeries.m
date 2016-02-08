//
//  VLTimeSeries.m
//  MyVinli
//
//  Created by Andrew Wells on 1/15/16.
//  Copyright © 2016 Vinli, inc. All rights reserved.
//

#import "VLTimeSeries.h"

static NSDateFormatter* isoDateFormatter;


@implementation VLTimeSeries

+ (void)initialize
{
    isoDateFormatter = [[NSDateFormatter alloc] init];
    NSLocale *enUSPOSIXLocale = [NSLocale localeWithLocaleIdentifier:@"en_US_POSIX"];
    [isoDateFormatter setLocale:enUSPOSIXLocale];
    [isoDateFormatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ssZZZZZ"];
}

+ (instancetype)timeSeriesFromPreviousNumberOfWeeks:(NSInteger)numWeeks
{
    NSCalendar *calendar = [NSCalendar currentCalendar];
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

+ (instancetype)timeSeriesFromDate:(NSDate *)date
{
    VLTimeSeries* timeSeries = [VLTimeSeries new];
    timeSeries.until = date;
    return timeSeries;
}

- (NSDictionary *)toDictionary
{
    NSMutableDictionary* retVal = [NSMutableDictionary new];
    if (self.since) {
        NSString* sinceDateStr = [isoDateFormatter stringFromDate:self.since];
        if (sinceDateStr.length > 0) {
            [retVal setObject:sinceDateStr forKey:@"since"];
        }
    }
    
    if (self.until) {
        NSString* untilDateStr = [isoDateFormatter stringFromDate:self.until];
        if (untilDateStr.length > 0) {
            [retVal setObject:untilDateStr forKey:@"until"];
        }
    }
    
    if (self.limit) {
        [retVal setObject:self.limit forKey:@"limit"];
    }
    
    return [retVal copy];
}

@end
