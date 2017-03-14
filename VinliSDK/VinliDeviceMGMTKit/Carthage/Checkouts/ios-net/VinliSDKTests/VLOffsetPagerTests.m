//
//  VLOffsetPagerTests.m
//  VinliSDK
//
//  Created by Andrew Wells on 11/29/16.
//  Copyright © 2016 Vinli. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "VLService.h"
#import "VLTestHelper.h"

@interface VLOffsetPagerTests : XCTestCase
@property (weak, nonatomic) VLService *service;
//@property (weak, nonatomic)
@end

@implementation VLOffsetPagerTests

- (void)setUp {
    [super setUp];
    self.service = [VLTestHelper vlService];
}

- (void)tearDown {
    [super tearDown];
}

- (void)testOffsetGetNext {
    XCTestExpectation *expectation = [self expectationWithDescription:@"Get Codes"];
    [self.service getCodesWithPID:@"P0001" limit:@(1) offset:@(0) onSuccess:^(VLCodePager *codePager, NSHTTPURLResponse *response) {
        XCTAssertNotNil(codePager);
        XCTAssertTrue(codePager.codes.count == 1);
        
        [codePager getNext:^(NSArray *newValues, NSError *error) {
            XCTAssertNil(error);
            [expectation fulfill];
        }];
        
    } onFailure:^(NSError *error, NSHTTPURLResponse *response, NSString *bodyString) {
        NSLog(@"Failed to get codes with error: %@", error);
        XCTAssertTrue(NO);
        [expectation fulfill];
    }];
    
    [self waitForExpectationsWithTimeout:[VLTestHelper defaultTimeOut] handler:nil];
}

- (void)testOffsetGetFirst {
    XCTestExpectation *expectation = [self expectationWithDescription:@"Get Codes"];
    VLTimeSeries* timeSeries = [VLTimeSeries new];
    timeSeries.limit = @(1);
    [self.service getDtcsForVehicleWithId:[VLTestHelper vehicleId] timeSeries:timeSeries onSuccess:^(VLDtcPager *dtcPager, NSHTTPURLResponse *response) {
        [expectation fulfill];
    } onFailure:^(NSError *error, NSHTTPURLResponse *response, NSString *bodyString) {
        NSLog(@"Failed to get Dtcs with error: %@", error);
        XCTAssertTrue(NO);
        [expectation fulfill];
    }];
    
    [self waitForExpectationsWithTimeout:[VLTestHelper defaultTimeOut] handler:nil];
}

- (void)testOffsetGetLast {
    XCTestExpectation *expectation = [self expectationWithDescription:@"Get Codes"];
    VLTimeSeries* timeSeries = [VLTimeSeries new];
    timeSeries.limit = @(1);
    [self.service getDtcsForVehicleWithId:[VLTestHelper vehicleId] timeSeries:timeSeries onSuccess:^(VLDtcPager *dtcPager, NSHTTPURLResponse *response) {
        [expectation fulfill];
    } onFailure:^(NSError *error, NSHTTPURLResponse *response, NSString *bodyString) {
        NSLog(@"Failed to get Dtcs with error: %@", error);
        XCTAssertTrue(NO);
        [expectation fulfill];
    }];
    
    [self waitForExpectationsWithTimeout:[VLTestHelper defaultTimeOut] handler:nil];
}


- (void)testGetNext {
    
    XCTestExpectation *expectation = [self expectationWithDescription:@"Get Dtcs"];
    VLTimeSeries* timeSeries = [VLTimeSeries new];
    timeSeries.limit = @(1);
    [self.service getDtcsForVehicleWithId:[VLTestHelper vehicleId] timeSeries:timeSeries onSuccess:^(VLDtcPager *dtcPager, NSHTTPURLResponse *response) {
        [expectation fulfill];
    } onFailure:^(NSError *error, NSHTTPURLResponse *response, NSString *bodyString) {
        NSLog(@"Failed to get Dtcs with error: %@", error);
        XCTAssertTrue(NO);
        [expectation fulfill];
    }];
    
    [self waitForExpectationsWithTimeout:[VLTestHelper defaultTimeOut] handler:nil];
}

- (void)testGetFirst {
    XCTestExpectation *expectation = [self expectationWithDescription:@"Get Dtcs"];
    VLTimeSeries* timeSeries = [VLTimeSeries new];
    timeSeries.limit = @(1);
    [self.service getDtcsForVehicleWithId:[VLTestHelper vehicleId] timeSeries:timeSeries onSuccess:^(VLDtcPager *dtcPager, NSHTTPURLResponse *response) {
        [expectation fulfill];
    } onFailure:^(NSError *error, NSHTTPURLResponse *response, NSString *bodyString) {
        NSLog(@"Failed to get Dtcs with error: %@", error);
        XCTAssertTrue(NO);
        [expectation fulfill];
    }];
    
    [self waitForExpectationsWithTimeout:[VLTestHelper defaultTimeOut] handler:nil];
}

- (void)testGetLast {
    XCTestExpectation *expectation = [self expectationWithDescription:@"Get Dtcs"];
    VLTimeSeries* timeSeries = [VLTimeSeries new];
    timeSeries.limit = @(1);
    [self.service getDtcsForVehicleWithId:[VLTestHelper vehicleId] timeSeries:timeSeries onSuccess:^(VLDtcPager *dtcPager, NSHTTPURLResponse *response) {
        [expectation fulfill];
    } onFailure:^(NSError *error, NSHTTPURLResponse *response, NSString *bodyString) {
        NSLog(@"Failed to get Dtcs with error: %@", error);
        XCTAssertTrue(NO);
        [expectation fulfill];
    }];
    
    [self waitForExpectationsWithTimeout:[VLTestHelper defaultTimeOut] handler:nil];
}

@end
