//
//  VLReportCardPagerTests.m
//  VinliSDK
//
//  Created by Andrew Wells on 11/23/16.
//  Copyright © 2016 Vinli. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "VLService.h"
#import "VLTestHelper.h"

@interface VLReportCardPagerTests : XCTestCase
@property (strong, nonatomic) VLService* service;
@end

@implementation VLReportCardPagerTests

- (void)setUp {
    [super setUp];
    //VLSession *session = [[VLSession alloc] initWithAccessToken:[VLTestHelper accessToken]];
    self.service = [VLTestHelper vlService]; //[[VLService alloc] initWithSession:session];
}

- (void)tearDown {
    [super tearDown];
}

- (void)testGetNextAscending {
    
    XCTestExpectation* expectation = [self expectationWithDescription:@"Get Report Cards"];
    
    VLTimeSeries* timeSeries = [VLTimeSeries timeSeries];
    timeSeries.sortOrder = VLTimerSeriesSortDirectionAscending;
    timeSeries.limit = @(1);
    
    [self.service getReportCardsForDeviceWithId:[VLTestHelper deviceId] timeSeries:timeSeries onSuccess:^(VLReportCardPager *reportCardPager, NSHTTPURLResponse *response) {
        XCTAssertNotNil(reportCardPager, @"Should return a reportCardPager");
        XCTAssertEqual(reportCardPager.reportCards.count, 1, @"Expecting to be returned 1 report card when limit set to one");
        [reportCardPager getNext:^(NSArray *newValues, NSError *error) {
            XCTAssertTrue(reportCardPager.reportCards.count > 1, @"Report cards should be greater than 1 after calling getNext");
            NSLog(@"Report Cards: %@", reportCardPager.reportCards);
            [expectation fulfill];
        }];
        
    } onFailure:^(NSError *error, NSHTTPURLResponse *response, NSString *bodyString) {
        NSLog(@"Failed to retrieve report cards with error: %@\nResponse: %@", error, response);
        XCTAssertTrue(NO);
        [expectation fulfill];
    }];
    
    [self waitForExpectationsWithTimeout:[VLTestHelper defaultTimeOut] handler:nil];
    
}

- (void)testGetNextDescending {
    XCTestExpectation* expectation = [self expectationWithDescription:@"Get Report Cards"];
    
    VLTimeSeries* timeSeries = [VLTimeSeries timeSeries];
    timeSeries.sortOrder = VLTimerSeriesSortDirectionDescending;
    timeSeries.limit = @(1);
    
    [self.service getReportCardsForDeviceWithId:[VLTestHelper deviceId] timeSeries:timeSeries onSuccess:^(VLReportCardPager *reportCardPager, NSHTTPURLResponse *response) {
        XCTAssertNotNil(reportCardPager, @"Should return a reportCardPager");
        XCTAssertEqual(reportCardPager.reportCards.count, 1, @"Expecting to be returned 1 report card when limit set to one");
        [reportCardPager getNext:^(NSArray *newValues, NSError *error) {
            XCTAssertTrue(reportCardPager.reportCards.count > 1, @"Report cards should be greater than 1 after calling getNext");
            //NSLog(@"Report Cards: %@", reportCardPager.reportCards);
            [expectation fulfill];
        }];
        
    } onFailure:^(NSError *error, NSHTTPURLResponse *response, NSString *bodyString) {
        NSLog(@"Failed to retrieve report cards with error: %@\nResponse: %@", error, response);
        XCTAssertTrue(NO);
        [expectation fulfill];
    }];
    
    [self waitForExpectationsWithTimeout:[VLTestHelper defaultTimeOut] handler:nil];
    
}

@end
