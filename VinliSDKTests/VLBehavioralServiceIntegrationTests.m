//
//  VLBehavioralServiceIntegrationTests.m
//  VinliSDK
//
//  Created by Andrew Wells on 11/21/16.
//  Copyright © 2016 Vinli. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "VLService.h"
#import "VLTestHelper.h"

@interface VLBehavioralServiceIntegrationTests : XCTestCase
@property VLService *vlService;
@end

@implementation VLBehavioralServiceIntegrationTests

- (void)setUp {
    [super setUp];
    _vlService = [VLTestHelper vlService];
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)_validateReportCard:(VLReportCard *)reportCard {
    XCTAssertNotNil(reportCard.reportId, "Report Card must have id");
    XCTAssertNotNil(reportCard.deviceId, "Report Card must have device id");
    XCTAssertNotNil(reportCard.vehicleId, "Report Card must have vehicle id");
    XCTAssertNotNil(reportCard.tripId, @"Report Card must have trip id");
}

- (void)testGetReportCardsWithDeviceId {
    if(![VLTestHelper deviceId])
    {
        XCTAssertTrue(NO);
        return;
    }
    
    XCTestExpectation *expectedReportCards = [self expectationWithDescription:[NSString stringWithFormat:@"getting the report cards with deviceId %@", [VLTestHelper deviceId]]];
    [_vlService getReportCardsForDeviceWithId:[VLTestHelper deviceId] timeSeries:nil onSuccess:^(VLReportCardPager *reportCardPager, NSHTTPURLResponse *response) {
        XCTAssertNotNil(reportCardPager, @"ReportCardPager should not be nil");
        XCTAssertNotNil(reportCardPager.reportCards, @"ReportCards should not be nil");
        XCTAssertTrue(reportCardPager.reportCards.count > 0, @"There should be report cards returned");
        
        for (VLReportCard *reportCard in reportCardPager.reportCards) {
            [self _validateReportCard:reportCard];
            XCTAssertEqualObjects([VLTestHelper deviceId], reportCard.deviceId, @"Report card should match device id from request");
        }
        
        [expectedReportCards fulfill];
    } onFailure:^(NSError *error, NSHTTPURLResponse *response, NSString *bodyString) {
        XCTAssertTrue(NO);
        [expectedReportCards fulfill];
    }];
    
    [self waitForExpectationsWithTimeout:[VLTestHelper defaultTimeOut] handler:nil];
}

- (void)testGetReportCardsWithVehicleId {
    if (![VLTestHelper vehicleId]) {
        XCTAssertTrue(NO);
        return;
    }
    
    XCTestExpectation *expectedReportCards = [self expectationWithDescription:[NSString stringWithFormat:@"getting the report cards with vehicleId %@", [VLTestHelper vehicleId]]];
    [_vlService getReportCardsForVehicleWithId:[VLTestHelper vehicleId] timeSeries:nil onSuccess:^(VLReportCardPager* reportCardPager, NSHTTPURLResponse *response) {
        XCTAssertNotNil(reportCardPager, @"ReportCardPager should not be nil");
        XCTAssertNotNil(reportCardPager.reportCards, @"ReportCards should not be nil");
        XCTAssertTrue(reportCardPager.reportCards.count > 0, @"There should be report cards returned");
        
        for (VLReportCard *reportCard in reportCardPager.reportCards) {
            [self _validateReportCard:reportCard];
            XCTAssertEqualObjects([VLTestHelper vehicleId], reportCard.vehicleId, @"Report card should match vehicle id from request");
        }

        [expectedReportCards fulfill];
    } onFailure:^(NSError *error, NSHTTPURLResponse *response, NSString *bodyString) {
        XCTAssertTrue(NO);
        [expectedReportCards fulfill];
    }];
    
   [self waitForExpectationsWithTimeout:[VLTestHelper defaultTimeOut] handler:nil];
}

- (void)testGetOverallReportCardWithDeviceId {
    if(![VLTestHelper deviceId])
    {
        XCTAssertTrue(NO);
        return;
    }
    
    XCTestExpectation *expectedReportCard = [self expectationWithDescription:[NSString stringWithFormat:@"getting the report card with deviceId %@", [VLTestHelper deviceId]]];
    [_vlService getOverallReportCardForDeviceWithId:[VLTestHelper deviceId] timeSeries:nil onSuccess:^(VLOverallReportCard *overallReportCard, NSHTTPURLResponse *response) {
        XCTAssertNotNil(overallReportCard, @"Overall Report Card should not be nil");
        XCTAssertNotNil(overallReportCard.overallGrade, @"Overall Report card overall grade should not be nil");
        XCTAssertTrue(overallReportCard.tripSampleSize > 0, @"Overall Report Card should have a non zero trip sample size");
        [expectedReportCard fulfill];
    } onFailure:^(NSError *error, NSHTTPURLResponse *response, NSString *bodyString) {
        XCTAssertTrue(NO);
        [expectedReportCard fulfill];
    }];
    
    [self waitForExpectationsWithTimeout:[VLTestHelper defaultTimeOut] handler:nil];
}

- (void)testGetReportCardForTripWithId {
    if(![VLTestHelper tripId])
    {
        XCTAssertTrue(NO);
        return;
    }
    
    XCTestExpectation *expectedTripReportCard = [self expectationWithDescription:[NSString stringWithFormat:@"getting the report card with tripId %@", [VLTestHelper tripId]]];
    [_vlService getReportCardForTripWithId:[VLTestHelper tripId] onSuccess:^(VLReportCard *reportCard, NSHTTPURLResponse *response) {
        XCTAssertNotNil(reportCard, @"Report card should not be nil");
        [self _validateReportCard:reportCard];
        XCTAssertEqualObjects([VLTestHelper tripId], reportCard.tripId, @"Report card should match trip id from request");
        [expectedTripReportCard fulfill];
    } onFailure:^(NSError *error, NSHTTPURLResponse *response, NSString *bodyString) {
        XCTAssertTrue(NO);
        [expectedTripReportCard fulfill];
    }];
    
    [self waitForExpectationsWithTimeout:[VLTestHelper defaultTimeOut] handler:nil];
}

- (void)testGetReportCardWithId {
    if (![VLTestHelper reportCardId]) {
        XCTAssertTrue(NO);
        return;
    }
    
    XCTestExpectation *expectedReportCard = [self expectationWithDescription:[NSString stringWithFormat:@"getting the report card with id %@", [VLTestHelper reportCardId]]];
    [_vlService getReportCardWithId:[VLTestHelper reportCardId] onSuccess:^(VLReportCard *reportCard, NSHTTPURLResponse *response) {
        XCTAssertNotNil(reportCard, @"Report card should not be nil");
        [self _validateReportCard:reportCard];
        XCTAssertEqualObjects(reportCard.reportId, [VLTestHelper reportCardId], @"Report card should id");
        XCTAssertEqualObjects(reportCard.deviceId, @"82ea8053-aff0-4f51-b075-bd90fbec9d41", @"Report card should match deviceId");
        XCTAssertEqualObjects(reportCard.vehicleId, @"ec67a76e-8acb-4c8f-8db8-4300201714a0", @"Report card should match vehicleId");
        XCTAssertEqualObjects(reportCard.tripId, @"61c561b2-85b9-4779-8e55-1d163d96ad85", @"Report card should match tripId");
        XCTAssertEqualObjects(reportCard.grade, @"A", @"Report card should match grade");
        
        [expectedReportCard fulfill];
    } onFailure:^(NSError *error, NSHTTPURLResponse *response, NSString *bodyString) {
        XCTAssertTrue(NO);
        [expectedReportCard fulfill];
    }];
    
    [self waitForExpectationsWithTimeout:[VLTestHelper defaultTimeOut] handler:nil];

}

@end
