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
@property NSDictionary *distances;
@property NSDictionary *odometers;
@property NSDictionary *odometer;
@property NSDictionary *odometerTriggers;
@property NSDictionary *odometerTrigger;
@end

@implementation VLDistanceServicesIntegrationTests

- (void)setUp {
    [super setUp];
    
    XCTestExpectation *expectationDistances = [self expectationWithDescription:@"URI call to get vehicle distances"];
    [[VLSessionManager sharedManager].service startWithHost:[VLTestHelper accessToken] requestUri:[NSString stringWithFormat:@"https://distance.vin.li/api/v1/vehicles/%@/distances", [VLTestHelper vehicleId]] onSuccess:^(NSDictionary *result, NSHTTPURLResponse *response) {
        [expectationDistances fulfill];
        self.distances = result;
    } onFailure:^(NSError *error, NSHTTPURLResponse *response, NSString *msg) {
        XCTAssertTrue(NO);
    }];
    
    [self waitForExpectationsWithTimeout:[VLTestHelper defaultTimeOut] handler:nil];

    
    
    XCTestExpectation *expectationOdometers = [self expectationWithDescription:@"URI call to get odometers"];
    [[VLSessionManager sharedManager].service startWithHost:[VLTestHelper accessToken] requestUri:[NSString stringWithFormat:@"https://distance.vin.li/api/v1/vehicles/%@/odometers", [VLTestHelper vehicleId]] onSuccess:^(NSDictionary *result, NSHTTPURLResponse *response) {
        [expectationOdometers fulfill];
        self.odometers = result;
    } onFailure:^(NSError *error, NSHTTPURLResponse *response, NSString *msg) {
        XCTAssertTrue(NO);
    }];
    
    [self waitForExpectationsWithTimeout:[VLTestHelper defaultTimeOut] handler:nil];
    
    
    
    
    
    
    XCTestExpectation *expectedOdometerWithId = [self expectationWithDescription:@"URI call to get specific odometer"];
    [[VLSessionManager sharedManager].service startWithHost:[VLTestHelper accessToken] requestUri:[NSString stringWithFormat:@"https://distance.vin.li/api/v1/odometers/%@", [VLTestHelper odometerId]] onSuccess:^(NSDictionary *result, NSHTTPURLResponse *response) {
        [expectedOdometerWithId fulfill];
        self.odometer = result;
    } onFailure:^(NSError *error, NSHTTPURLResponse *response, NSString *msg) {
        XCTAssertTrue(NO);
    }];
    
    [self waitForExpectationsWithTimeout:[VLTestHelper defaultTimeOut] handler:nil];

    
    
    
    XCTestExpectation *expectedAllOdometerTriggers = [self expectationWithDescription:@"URI call get all Odometer triggers"];
    [[VLSessionManager sharedManager].service startWithHost:[VLTestHelper accessToken] requestUri:[NSString stringWithFormat:@"https://distance.vin.li/api/v1/vehicles/%@/odometer_triggers", [VLTestHelper vehicleId]] onSuccess:^(NSDictionary *result, NSHTTPURLResponse *response) {
        [expectedAllOdometerTriggers fulfill];
        self.odometerTriggers = result;
    } onFailure:^(NSError *error, NSHTTPURLResponse *response, NSString *msg) {
        XCTAssertTrue(NO);
    }];
    
    
    
    [self waitForExpectationsWithTimeout:[VLTestHelper defaultTimeOut] handler:nil];
    
    
    XCTestExpectation *expectedOdometerTrigger = [self expectationWithDescription:@"URI odometer trigger"];
    
    [[VLSessionManager sharedManager].service startWithHost:[VLTestHelper accessToken] requestUri:[NSString stringWithFormat:@"https://distance.vin.li/api/v1/odometer_triggers/%@", [VLTestHelper odometerTriggerId]] onSuccess:^(NSDictionary *result, NSHTTPURLResponse *response) {
        [expectedOdometerTrigger fulfill];
        self.odometerTrigger = result;
    } onFailure:^(NSError *error, NSHTTPURLResponse *response, NSString *msg) {
        XCTAssertTrue(NO);
    }];
    
    
    [self waitForExpectationsWithTimeout:[VLTestHelper defaultTimeOut] handler:nil];

    
    
}


- (void)testGetDistancesForVehicleWithId {
    NSDictionary *expectedJSON = [VLTestHelper cleanDictionary:self.distances];
    XCTestExpectation *distancesExpected = [self expectationWithDescription:@"service call distances"];
    [[VLSessionManager sharedManager].service getDistancesForVehicleWithId:[VLTestHelper vehicleId] onSuccess:^(VLDistancePager *distancePager, NSHTTPURLResponse *response) {
        [distancesExpected fulfill];
        XCTAssertEqual(distancePager.distances.count, [expectedJSON[@"distances"] count]);
        VLDistance *distance = (distancePager.distances.count > 0) ? distancePager.distances[0] : nil;
        
        if (distance) {
           NSDictionary *expectedDistanceJson = [VLTestHelper cleanDictionary:expectedJSON[@"distances"][0]];
            
            
            XCTAssertEqualObjects(distance.confidenceMax, expectedDistanceJson[@"confidenceMax"]);
            XCTAssertEqualObjects(distance.confidenceMin, expectedDistanceJson[@"confidenceMin"]);
            XCTAssertEqualObjects(distance.lastOdometer, expectedDistanceJson[@"lastOdometerDate"]);
            XCTAssertEqualObjects([distance.value stringValue], [expectedDistanceJson[@"value"] stringValue]);
            
        }
        
        
    } onFailure:^(NSError *error, NSHTTPURLResponse *response, NSString *bodyString) {
        XCTAssertTrue(NO);
    }];
    
    [self waitForExpectationsWithTimeout:[VLTestHelper defaultTimeOut] handler:nil];
}


//we still need methods for Post and delete testing



- (void)testGetOdometersForVehicleId {
    NSDictionary *expectedJSON = [VLTestHelper cleanDictionary:self.odometers];
    XCTestExpectation *expectedOdometers = [self expectationWithDescription:@"Service Call to odometers"];
    
    //make the call
    [[VLSessionManager sharedManager].service getOdometersForVehicleWithId:[VLTestHelper vehicleId] onSuccess:^(VLOdometerPager *odometerPager, NSHTTPURLResponse *response) {
        [expectedOdometers fulfill];
        XCTAssertEqual(odometerPager.odometers.count, [expectedJSON[@"odometers"] count]);
    } onFailure:^(NSError *error, NSHTTPURLResponse *response, NSString *bodyString) {
        XCTAssertTrue(NO);
    }];
    
     [self waitForExpectationsWithTimeout:[VLTestHelper defaultTimeOut] handler:nil];
    
}


- (void)testGetOdometerWithId {
    NSDictionary *expectedJSON = [VLTestHelper cleanDictionary:self.odometer[@"odometer"]];
    XCTestExpectation *odometerExpected = [self expectationWithDescription:@"Service call for odometer"];
    [[VLSessionManager sharedManager].service getOdometerWithId:[VLTestHelper odometerId] onSuccess:^(VLOdometer *odometer, NSHTTPURLResponse *response) {
        [odometerExpected fulfill];
        XCTAssertEqualObjects(odometer.odometerId, expectedJSON[@"id"]);
        XCTAssertEqualObjects(odometer.vehicleId, expectedJSON[@"vehicleId"]);
        XCTAssertEqualObjects([odometer.reading stringValue], [expectedJSON[@"reading"] stringValue]);
        XCTAssertEqualObjects(odometer.dateStr, expectedJSON[@"date"]);
        XCTAssertEqualObjects([odometer.vehicleURL absoluteString], expectedJSON[@"links"][@"vehicle"]);
        
    } onFailure:^(NSError *error, NSHTTPURLResponse *response, NSString *bodyString) {
        XCTAssertTrue(NO);
    }];
    
    [self waitForExpectationsWithTimeout:[VLTestHelper defaultTimeOut] handler:nil];

    
}


- (void)testGetOdometerTriggerForVehicleWithId {
    NSDictionary *expectedJSON = [VLTestHelper cleanDictionary:self.odometerTriggers];
    XCTestExpectation *odometerTriggersExpected = [self expectationWithDescription:@"expectedOdometerPagers"];
    [[VLSessionManager sharedManager].service getOdometerTriggersForVehicleWithId:[VLTestHelper vehicleId] onSucess:^(VLOdometerTriggerPager *odometerTriggerPager, NSHTTPURLResponse *response) {
        [odometerTriggersExpected fulfill];
        XCTAssertEqual(odometerTriggerPager.odometerTriggers.count, [expectedJSON[@"odometerTriggers"] count]);
        
    } onFailure:^(NSError *error, NSHTTPURLResponse *response, NSString *bodyString) {
        XCTAssertTrue(NO);
    }];
    
    [self waitForExpectationsWithTimeout:[VLTestHelper defaultTimeOut] handler:nil];
    
}

- (void)testGetOdometerTriggerWithId {
    NSDictionary *expectedJSON = [VLTestHelper cleanDictionary:self.odometerTrigger[@"odometerTrigger"]];
    XCTestExpectation *odometerTriggerExpected = [self expectationWithDescription:@"service call to odometertrigger"];
    [[VLSessionManager sharedManager].service getOdometerTriggerWithId:[VLTestHelper odometerTriggerId] onSuccess:^(VLOdometerTrigger *odometerTrigger, NSHTTPURLResponse *response) {
        [odometerTriggerExpected fulfill];
        XCTAssertEqualObjects(odometerTrigger.odometerTriggerId, expectedJSON[@"id"]);
        XCTAssertEqualObjects(odometerTrigger.vehicleId, expectedJSON[@"vehicleId"]);
        //XCTAssertEqualObjects(odometerTrigger.odometerTriggerType, expression2, ...);
        XCTAssertEqualObjects([odometerTrigger.threshold stringValue], [expectedJSON[@"threshold"] stringValue]);
        XCTAssertEqualObjects([odometerTrigger.events stringValue], [expectedJSON[@"events"] stringValue]);
        XCTAssertEqualObjects([odometerTrigger.vehicleURL absoluteString], expectedJSON[@"links"][@"vehicle"]);
        
    } onFailure:^(NSError *error, NSHTTPURLResponse *response, NSString *bodyString) {
         XCTAssertTrue(NO);
    }];
    [self waitForExpectationsWithTimeout:[VLTestHelper defaultTimeOut] handler:nil];
}








- (void)tearDown {
    [super tearDown];
}



@end
