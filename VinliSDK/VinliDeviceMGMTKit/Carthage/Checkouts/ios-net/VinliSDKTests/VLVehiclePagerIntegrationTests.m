//
//  VLVehiclePagerIntegrationTests.m
//  VinliSDK
//
//  Created by Andrew Wells on 12/7/16.
//  Copyright © 2016 Vinli. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "VLTestHelper.h"

@interface VLVehiclePagerIntegrationTests : XCTestCase
@property (weak, nonatomic) VLService *service;
@end

@implementation VLVehiclePagerIntegrationTests

- (void)setUp {
    [super setUp];
    self.service = [VLTestHelper vlService];
}

- (void)tearDown {
    [super tearDown];
}

- (void)testGetNext {
    
    XCTestExpectation *expectation = [self expectationWithDescription:@"Get vehicles"];
    [self.service getVehiclesForDeviceWithId:[VLTestHelper deviceId] limit:@(1) offset:@(0) onSuccess:^(VLVehiclePager *vehiclePager, NSHTTPURLResponse *response) {
        XCTAssertNotNil(vehiclePager);
        XCTAssertTrue(vehiclePager.vehicles.count == 1);
        [vehiclePager getNext:^(NSArray *newValues, NSError *error) {
            XCTAssertNil(error);
            XCTAssertTrue(newValues.count == 1);
            XCTAssertTrue(vehiclePager.vehicles.count == 2);
            [expectation fulfill];
        }];
    } onFailure:^(NSError *error, NSHTTPURLResponse *response, NSString *bodyString) {
        NSLog(@"Failed to get vehicles with error: %@", error);
        XCTFail();
        [expectation fulfill];
    }];
    
    [self waitForExpectationsWithTimeout:[VLTestHelper defaultTimeOut] handler:nil];
}

- (void)testGetLast {
    XCTestExpectation *expectation = [self expectationWithDescription:@"Get vehicles"];
    [self.service getVehiclesForDeviceWithId:[VLTestHelper deviceId] limit:@(1) offset:@(0) onSuccess:^(VLVehiclePager *vehiclePager, NSHTTPURLResponse *response) {
        XCTAssertNotNil(vehiclePager);
        XCTAssertTrue(vehiclePager.vehicles.count == 1);
        [vehiclePager getFirst:^(VLVehicle* vehicle, NSError *error) {
            XCTAssertNil(error);
            XCTAssertNotNil(vehicle);
            VLVehicle *firstPagerVehicle = vehiclePager.vehicles.firstObject;
            XCTAssertEqualObjects(vehicle.vehicleId, firstPagerVehicle.vehicleId);
            [expectation fulfill];
        }];
    } onFailure:^(NSError *error, NSHTTPURLResponse *response, NSString *bodyString) {
        NSLog(@"Failed to get vehicles with error: %@", error);
        XCTFail();
        [expectation fulfill];
    }];
    
    [self waitForExpectationsWithTimeout:[VLTestHelper defaultTimeOut] handler:nil];
}

- (void)testGetFirst {
    XCTestExpectation *expectation = [self expectationWithDescription:@"Get vehicles"];
    [self.service getVehiclesForDeviceWithId:[VLTestHelper deviceId] limit:@(1) offset:@(0) onSuccess:^(VLVehiclePager *vehiclePager, NSHTTPURLResponse *response) {
        XCTAssertNotNil(vehiclePager);
        XCTAssertTrue(vehiclePager.vehicles.count == 1);
        [vehiclePager getLast:^(VLVehicle* vehicle, NSError *error) {
            XCTAssertNil(error);
            XCTAssertNotNil(vehicle);
            [expectation fulfill];
        }];
    } onFailure:^(NSError *error, NSHTTPURLResponse *response, NSString *bodyString) {
        NSLog(@"Failed to get vehicles with error: %@", error);
        XCTFail();
        [expectation fulfill];
    }];
    
    [self waitForExpectationsWithTimeout:[VLTestHelper defaultTimeOut] handler:nil];
}


@end
