//
//  VLDateFormatter.m
//  VinliSDK
//
//  Created by Jai Ghanekar on 3/17/16.
//  Copyright © 2016 Vinli. All rights reserved.
//

#import "VLDateFormatter.h"

static NSDateFormatter* isoStringToDateFormatter;
static NSDateFormatter* isoDateToStringFormatter;

@implementation VLDateFormatter

+ (NSDate *)initializeDateFromString:(NSString *)dateString {
	NSArray *formats = @[
		@"yyyy-MM-dd'T'HH:mm:ss.SSSZZZZ'",
		@"yyyy-MM-dd'T'HH:mm:ss'Z'",
		@"yyyy-MM-dd'T'HH:mm:ss.'Z'",
		@"yyyy-MM-dd'T'HH:mm:ss.S'Z'",
		@"yyyy-MM-dd'T'HH:mm:ss.SS'Z'",
		@"yyyy-MM-dd'T'HH:mm:ss.SSS'Z'",
		@"yyyy-MM-dd'T'HH:mm:ss.SSSS'Z'",
		@"yyyy-MM-dd'T'HH:mm:ss.SSSSS'Z'",
		@"yyyy-MM-dd'T'HH:mm:ss.SSSSSS'Z'",
	];

	[self initializeStringToDateFormatter];

	for (NSString *format in formats) {
		[isoStringToDateFormatter setDateFormat:format];
		NSDate *date = [isoStringToDateFormatter dateFromString:dateString];
		if (date) {
			return date;
		}
	}

	return nil;
}

+ (NSString *)stringFromDate:(NSDate *)date {
	[self initializeDateToStringFormatter];
	NSString *strDate = [isoDateToStringFormatter stringFromDate:date];
	return strDate;
}

+ (void)initializeStringToDateFormatter {
	if (isoStringToDateFormatter) {
		return;
	}
	NSInteger seconds = [[NSTimeZone systemTimeZone] secondsFromGMT];
	isoStringToDateFormatter = [[NSDateFormatter alloc] init];
	[isoStringToDateFormatter setLocale:[NSLocale localeWithLocaleIdentifier:@"en_US_POSIX"]];
	[isoStringToDateFormatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss.SSSZZZZ'"];
	[isoStringToDateFormatter setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:seconds]];
}

+ (void)initializeDateToStringFormatter {
	if (isoDateToStringFormatter) {
		return;
	}
	isoDateToStringFormatter = [[NSDateFormatter alloc] init];
	[isoDateToStringFormatter setLocale:[NSLocale localeWithLocaleIdentifier:@"en_US_POSIX"]];
	[isoDateToStringFormatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"];
	[isoDateToStringFormatter setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:0]]; // Prevent adjustment to user's local time zone.
}

@end
