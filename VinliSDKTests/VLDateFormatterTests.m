//
//  VLDateFormatterTests.m
//  VinliSDKTests
//
//  Created by Shawn Casey on 4/9/20.
//  Copyright © 2020 Vinli. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "VLDateFormatter.h"

@interface VLDateFormatterTests : XCTestCase

@end

@implementation VLDateFormatterTests

- (void)test_dateFormatter_nullString {
	XCTAssertNil([VLDateFormatter initializeDateFromString:nil]);
	XCTAssertNil([VLDateFormatter initializeDateFromString:@""]);
}

@end
