//
//  VLDistanceServicesIntegrationTests.m
//  VinliSDK
//
//  Created by Jai Ghanekar on 3/11/16.
//  Copyright © 2016 Vinli. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "VLTestHelper.h"
#import "VLService.h"
#import "VLSessionManager.h"
#import "VLDistance.h"
#import "VLDistancePager.h"


@interface VLDistanceServicesIntegrationTests : XCTestCase

@property VLService *vlService;

@end

@implementation VLDistanceServicesIntegrationTests

- (void)setUp {
    [super setUp];
    
    _vlService = [VLTestHelper vlService];
}

- (void)testGetDistancesForVehicleWithId {
    NSDictionary *expectedJSON = [VLTestHelper getAllDistancesJSON];
    
    if(![VLTestHelper vehicleId]){
        XCTAssertTrue(NO);
        return;
    }
    
    XCTestExpectation *distancesExpected = [self expectationWithDescription:@"service call distances"];
    [_vlService getDistancesForVehicleWithId:[VLTestHelper vehicleId] onSuccess:^(VLDistancePager *distancePager, NSHTTPURLResponse *response) {
        XCTAssertEqual(distancePager.distances.count, [expectedJSON[@"distances"] count]);
        VLDistance *distance = (distancePager.distances.count > 0) ? distancePager.distances[0] : nil;
        
        if (distance) {
           NSDictionary *expectedDistanceJson = [VLTestHelper cleanDictionary:expectedJSON[@"distances"][0]];
            
            XCTAssertEqualObjects(distance.confidenceMax, expectedDistanceJson[@"confidenceMax"]);
            XCTAssertEqualObjects(distance.confidenceMin, expectedDistanceJson[@"confidenceMin"]);
            XCTAssertEqualObjects(distance.lastOdometer, expectedDistanceJson[@"lastOdometerDate"]);
            XCTAssertEqualObjects([distance.value stringValue], [expectedDistanceJson[@"value"] stringValue]);
        }
        
        [distancesExpected fulfill];
    } onFailure:^(NSError *error, NSHTTPURLResponse *response, NSString *bodyString) {
        XCTAssertTrue(NO);
        [distancesExpected fulfill];
    }];
    
    [self waitForExpectationsWithTimeout:[VLTestHelper defaultTimeOut] handler:nil];
}

- (void)testGetOdometersForVehicleId {
    NSDictionary *expectedJSON = [VLTestHelper getAllOdometersJSON];
    
    if(![VLTestHelper vehicleId]){
        XCTAssertTrue(NO);
        return;
    }
    
    XCTestExpectation *expectedOdometers = [self expectationWithDescription:@"Service Call to odometers"];
    [_vlService getOdometersForVehicleWithId:[VLTestHelper vehicleId] onSuccess:^(VLOdometerPager *odometerPager, NSHTTPURLResponse *response) {
        XCTAssertEqual(odometerPager.odometers.count, [expectedJSON[@"odometers"] count]);
        [expectedOdometers fulfill];
    } onFailure:^(NSError *error, NSHTTPURLResponse *response, NSString *bodyString) {
        XCTAssertTrue(NO);
        [expectedOdometers fulfill];
    }];
    
    [self waitForExpectationsWithTimeout:[VLTestHelper defaultTimeOut] handler:nil];
}

- (void)testGetOdometerWithId {
    NSDictionary *expectedJSON = [VLTestHelper getOdometerJSON];
    
    if(![VLTestHelper odometerId]){
        XCTAssertTrue(NO);
        return;
    }
    
    XCTestExpectation *odometerExpected = [self expectationWithDescription:@"Service call for odometer"];
    [_vlService getOdometerWithId:[VLTestHelper odometerId] onSuccess:^(VLOdometer *odometer, NSHTTPURLResponse *response) {
        XCTAssertEqualObjects(odometer.odometerId, expectedJSON[@"id"]);
        XCTAssertEqualObjects(odometer.vehicleId, expectedJSON[@"vehicleId"]);
        XCTAssertEqualObjects([odometer.reading stringValue], [expectedJSON[@"reading"] stringValue]);
        XCTAssertEqualObjects(odometer.dateStr, expectedJSON[@"date"]);
        XCTAssertEqualObjects([odometer.vehicleURL absoluteString], expectedJSON[@"links"][@"vehicle"]);
        [odometerExpected fulfill];
    } onFailure:^(NSError *error, NSHTTPURLResponse *response, NSString *bodyString) {
        XCTAssertTrue(NO);
        [odometerExpected fulfill];
    }];
    
    [self waitForExpectationsWithTimeout:[VLTestHelper defaultTimeOut] handler:nil];
}

- (void)testGetOdometerTriggerForVehicleWithId {
    NSDictionary *expectedJSON = [VLTestHelper getAllOdometerTriggersJSON];
    
    if(![VLTestHelper vehicleId]){
        XCTAssertTrue(NO);
        return;
    }
    
    XCTestExpectation *odometerTriggersExpected = [self expectationWithDescription:@"expectedOdometerPagers"];
    [_vlService getOdometerTriggersForVehicleWithId:[VLTestHelper vehicleId] onSucess:^(VLOdometerTriggerPager *odometerTriggerPager, NSHTTPURLResponse *response) {
        XCTAssertEqual(odometerTriggerPager.odometerTriggers.count, [expectedJSON[@"odometerTriggers"] count]);
        [odometerTriggersExpected fulfill];
    } onFailure:^(NSError *error, NSHTTPURLResponse *response, NSString *bodyString) {
        XCTAssertTrue(NO);
        [odometerTriggersExpected fulfill];
    }];
    
    [self waitForExpectationsWithTimeout:[VLTestHelper defaultTimeOut] handler:nil];
}

- (void)testGetOdometerTriggerWithId {
    NSDictionary *expectedJSON = [VLTestHelper getOdometerTriggerJSON];
    
    if(![VLTestHelper odometerTriggerId]){
        XCTAssertTrue(NO);
        return;
    }
    
    XCTestExpectation *odometerTriggerExpected = [self expectationWithDescription:@"service call to odometertrigger"];
    [_vlService getOdometerTriggerWithId:[VLTestHelper odometerTriggerId] onSuccess:^(VLOdometerTrigger *odometerTrigger, NSHTTPURLResponse *response) {
        XCTAssertEqualObjects(odometerTrigger.odometerTriggerId, expectedJSON[@"id"]);
        XCTAssertEqualObjects(odometerTrigger.vehicleId, expectedJSON[@"vehicleId"]);
        //XCTAssertEqualObjects(odometerTrigger.odometerTriggerType, expression2, ...);
        XCTAssertEqualObjects([odometerTrigger.threshold stringValue], [expectedJSON[@"threshold"] stringValue]);
        XCTAssertEqualObjects([odometerTrigger.events stringValue], [expectedJSON[@"events"] stringValue]);
        XCTAssertEqualObjects([odometerTrigger.vehicleURL absoluteString], expectedJSON[@"links"][@"vehicle"]);
        [odometerTriggerExpected fulfill];
    } onFailure:^(NSError *error, NSHTTPURLResponse *response, NSString *bodyString) {
         XCTAssertTrue(NO);
        [odometerTriggerExpected fulfill];
    }];
    
    [self waitForExpectationsWithTimeout:[VLTestHelper defaultTimeOut] handler:nil];
}

- (void)tearDown {
    [super tearDown];
}

@end
