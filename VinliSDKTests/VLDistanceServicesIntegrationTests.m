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
@property NSDictionary *distances;
@property NSDictionary *odometers;
@property NSDictionary *odometer;
@property NSDictionary *odometerTriggers;
@property NSDictionary *odometerTrigger;

@end

@implementation VLDistanceServicesIntegrationTests

- (void)setUp {
    [super setUp];
    
    _vlService = [VLTestHelper vlService];
    
    XCTestExpectation *expectationDistances = [self expectationWithDescription:@"URI call to get vehicle distances"];
    [[VLSessionManager sharedManager].service startWithHost:[VLTestHelper accessToken] requestUri:[NSString stringWithFormat:@"https://distance.vin.li/api/v1/vehicles/%@/distances", [VLTestHelper vehicleId]] onSuccess:^(NSDictionary *result, NSHTTPURLResponse *response) {
        [expectationDistances fulfill];
        self.distances = result;
    } onFailure:^(NSError *error, NSHTTPURLResponse *response, NSString *msg) {
        XCTAssertTrue(NO);
    }];
    
    XCTestExpectation *expectationOdometers = [self expectationWithDescription:@"URI call to get odometers"];
    [[VLSessionManager sharedManager].service startWithHost:[VLTestHelper accessToken] requestUri:[NSString stringWithFormat:@"https://distance.vin.li/api/v1/vehicles/%@/odometers", [VLTestHelper vehicleId]] onSuccess:^(NSDictionary *result, NSHTTPURLResponse *response) {
        [expectationOdometers fulfill];
        self.odometers = result;
    } onFailure:^(NSError *error, NSHTTPURLResponse *response, NSString *msg) {
        XCTAssertTrue(NO);
    }];
    
    XCTestExpectation *expectedOdometerWithId = [self expectationWithDescription:@"URI call to get specific odometer"];
    [[VLSessionManager sharedManager].service startWithHost:[VLTestHelper accessToken] requestUri:[NSString stringWithFormat:@"https://distance.vin.li/api/v1/odometers/%@", [VLTestHelper odometerId]] onSuccess:^(NSDictionary *result, NSHTTPURLResponse *response) {
        [expectedOdometerWithId fulfill];
        self.odometer = result;
    } onFailure:^(NSError *error, NSHTTPURLResponse *response, NSString *msg) {
        XCTAssertTrue(NO);
    }];
    
    XCTestExpectation *expectedAllOdometerTriggers = [self expectationWithDescription:@"URI call get all Odometer triggers"];
    [[VLSessionManager sharedManager].service startWithHost:[VLTestHelper accessToken] requestUri:[NSString stringWithFormat:@"https://distance.vin.li/api/v1/vehicles/%@/odometer_triggers", [VLTestHelper vehicleId]] onSuccess:^(NSDictionary *result, NSHTTPURLResponse *response) {
        [expectedAllOdometerTriggers fulfill];
        self.odometerTriggers = result;
    } onFailure:^(NSError *error, NSHTTPURLResponse *response, NSString *msg) {
        XCTAssertTrue(NO);
    }];
    
    XCTestExpectation *expectedOdometerTrigger = [self expectationWithDescription:@"URI odometer trigger"];
    [[VLSessionManager sharedManager].service startWithHost:[VLTestHelper accessToken] requestUri:[NSString stringWithFormat:@"https://distance.vin.li/api/v1/odometer_triggers/%@", [VLTestHelper odometerTriggerId]] onSuccess:^(NSDictionary *result, NSHTTPURLResponse *response) {
        [expectedOdometerTrigger fulfill];
        self.odometerTrigger = result;
    } onFailure:^(NSError *error, NSHTTPURLResponse *response, NSString *msg) {
        XCTAssertTrue(NO);
    }];
    
    [self waitForExpectationsWithTimeout:[VLTestHelper defaultTimeOut] handler:nil];
}

- (void) testENV1{
    NSArray *args = [[NSProcessInfo processInfo] arguments];
    
    NSString *thing = @"";
    
    for(int i = 0; i < args.count; i++){
        NSString *str = [args objectAtIndex:i];
        NSString *testEnv = @"TEST_ENV";
        if([str hasPrefix:testEnv]){
            thing = @"yay";
        }
    }
    
    XCTAssertTrue([thing isEqualToString:@"yay"]);
}

- (void) testENV2{
    XCTAssertTrue(getenv("TEST_ENV"));
}


- (void)testGetDistancesForVehicleWithId {
    NSDictionary *expectedJSON = [VLTestHelper cleanDictionary:self.distances];
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
    NSDictionary *expectedJSON = [VLTestHelper cleanDictionary:self.odometers];
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
    NSDictionary *expectedJSON = [VLTestHelper cleanDictionary:self.odometer[@"odometer"]];
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
    NSDictionary *expectedJSON = [VLTestHelper cleanDictionary:self.odometerTriggers];
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
    NSDictionary *expectedJSON = [VLTestHelper cleanDictionary:self.odometerTrigger[@"odometerTrigger"]];
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
