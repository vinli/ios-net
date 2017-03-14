//
//  VLDateFormatter.h
//  VinliSDK
//
//  Created by Jai Ghanekar on 3/17/16.
//  Copyright © 2016 Vinli. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface VLDateFormatter : NSObject

+ (NSDate *)initializeDateFromString:(NSString *)dateString;
+ (NSString *)stringFromDate:(NSDate *)date;

@end
