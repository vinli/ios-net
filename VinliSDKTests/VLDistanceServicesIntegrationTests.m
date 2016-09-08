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
    if(![VLTestHelper vehicleId]){
        XCTAssertTrue(NO);
        return;
    }
    
    XCTestExpectation *distancesExpected = [self expectationWithDescription:@"service call distances"];
    [_vlService getDistancesForVehicleWithId:[VLTestHelper vehicleId] onSuccess:^(VLDistancePager *distancePager, NSHTTPURLResponse *response) {
        XCTAssertTrue(distancePager.distances.count > 0);
        
        for(VLDistance *distance in distancePager.distances){
            XCTAssertTrue(distance.confidenceMin != nil && [distance.confidenceMin isKindOfClass:[NSNumber class]]);
            XCTAssertTrue(distance.confidenceMax != nil && [distance.confidenceMax isKindOfClass:[NSNumber class]]);
            XCTAssertTrue(distance.value != nil && [distance.value isKindOfClass:[NSNumber class]]);
            XCTAssertTrue(distance.lastOdometer != nil && [distance.lastOdometer isKindOfClass:[NSString class]] && distance.lastOdometer.length > 0);
        }
        
        [distancesExpected fulfill];
    } onFailure:^(NSError *error, NSHTTPURLResponse *response, NSString *bodyString) {
        XCTAssertTrue(NO);
        [distancesExpected fulfill];
    }];
    
    [self waitForExpectationsWithTimeout:[VLTestHelper defaultTimeOut] handler:nil];
}

- (void)testGetOdometersForVehicleId {
    if(![VLTestHelper vehicleId]){
        XCTAssertTrue(NO);
        return;
    }
    
    XCTestExpectation *expectedOdometers = [self expectationWithDescription:@"Service Call to odometers"];
    [_vlService getOdometersForVehicleWithId:[VLTestHelper vehicleId] onSuccess:^(VLOdometerPager *odometerPager, NSHTTPURLResponse *response) {
        XCTAssertTrue(odometerPager.odometers.count > 0);
        XCTAssertTrue(odometerPager.since != nil && [odometerPager.since isKindOfClass:[NSString class]] && odometerPager.since.length > 0);
        XCTAssertTrue(odometerPager.until != nil && [odometerPager.until isKindOfClass:[NSString class]] && odometerPager.until.length > 0);
        
        for(VLOdometer *odometer in odometerPager.odometers){
            XCTAssertTrue(odometer.odometerId != nil && [odometer.odometerId isKindOfClass:[NSString class]] && odometer.odometerId.length > 0);
            XCTAssertTrue(odometer.vehicleId != nil && [odometer.vehicleId isKindOfClass:[NSString class]] && odometer.vehicleId.length > 0);
            XCTAssertTrue(odometer.reading != nil && [odometer.reading isKindOfClass:[NSNumber class]]);
            XCTAssertTrue(odometer.dateStr != nil && [odometer.dateStr isKindOfClass:[NSString class]] && odometer.dateStr.length > 0);
        }
        
        [expectedOdometers fulfill];
    } onFailure:^(NSError *error, NSHTTPURLResponse *response, NSString *bodyString) {
        XCTAssertTrue(NO);
        [expectedOdometers fulfill];
    }];
    
    [self waitForExpectationsWithTimeout:[VLTestHelper defaultTimeOut] handler:nil];
}

- (void)testGetOdometerWithId {
    if(![VLTestHelper odometerId]){
        XCTAssertTrue(NO);
        return;
    }
    
    XCTestExpectation *odometerExpected = [self expectationWithDescription:@"Service call for odometer"];
    [_vlService getOdometerWithId:[VLTestHelper odometerId] onSuccess:^(VLOdometer *odometer, NSHTTPURLResponse *response) {
        XCTAssertTrue(odometer.odometerId != nil && [odometer.odometerId isKindOfClass:[NSString class]] && odometer.odometerId.length > 0);
        XCTAssertTrue(odometer.vehicleId != nil && [odometer.vehicleId isKindOfClass:[NSString class]] && odometer.vehicleId.length > 0);
        XCTAssertTrue(odometer.reading != nil && [odometer.reading isKindOfClass:[NSNumber class]]);
        XCTAssertTrue(odometer.dateStr != nil && [odometer.dateStr isKindOfClass:[NSString class]] && odometer.dateStr.length > 0);
        [odometerExpected fulfill];
    } onFailure:^(NSError *error, NSHTTPURLResponse *response, NSString *bodyString) {
        XCTAssertTrue(NO);
        [odometerExpected fulfill];
    }];
    
    [self waitForExpectationsWithTimeout:[VLTestHelper defaultTimeOut] handler:nil];
}

- (void)testGetOdometerTriggerForVehicleWithId {
    if(![VLTestHelper vehicleId]){
        XCTAssertTrue(NO);
        return;
    }
    
    XCTestExpectation *odometerTriggersExpected = [self expectationWithDescription:@"expectedOdometerPagers"];
    [_vlService getOdometerTriggersForVehicleWithId:[VLTestHelper vehicleId] onSucess:^(VLOdometerTriggerPager *odometerTriggerPager, NSHTTPURLResponse *response) {
        XCTAssertTrue(odometerTriggerPager.odometerTriggers.count > 0);
        XCTAssertTrue(odometerTriggerPager.since != nil && [odometerTriggerPager.since isKindOfClass:[NSString class]] && odometerTriggerPager.since.length > 0);
        XCTAssertTrue(odometerTriggerPager.until != nil && [odometerTriggerPager.until isKindOfClass:[NSString class]] && odometerTriggerPager.until.length > 0);
        
        for(VLOdometerTrigger *odometerTrigger in odometerTriggerPager.odometerTriggers){
            XCTAssertTrue(odometerTrigger.odometerTriggerId != nil && [odometerTrigger.odometerTriggerId isKindOfClass:[NSString class]] && odometerTrigger.odometerTriggerId.length > 0);
            XCTAssertTrue(odometerTrigger.vehicleId != nil && [odometerTrigger.vehicleId isKindOfClass:[NSString class]] && odometerTrigger.vehicleId.length > 0);
            XCTAssertTrue(odometerTrigger.threshold != nil && [odometerTrigger.threshold isKindOfClass:[NSNumber class]]);
        }
        [odometerTriggersExpected fulfill];
    } onFailure:^(NSError *error, NSHTTPURLResponse *response, NSString *bodyString) {
        XCTAssertTrue(NO);
        [odometerTriggersExpected fulfill];
    }];
    
    [self waitForExpectationsWithTimeout:[VLTestHelper defaultTimeOut] handler:nil];
}

- (void)testGetOdometerTriggerWithId {
    if(![VLTestHelper odometerTriggerId]){
        XCTAssertTrue(NO);
        return;
    }
    
    XCTestExpectation *odometerTriggerExpected = [self expectationWithDescription:@"service call to odometertrigger"];
    [_vlService getOdometerTriggerWithId:[VLTestHelper odometerTriggerId] onSuccess:^(VLOdometerTrigger *odometerTrigger, NSHTTPURLResponse *response) {
        XCTAssertTrue(odometerTrigger.odometerTriggerId != nil && [odometerTrigger.odometerTriggerId isKindOfClass:[NSString class]] && odometerTrigger.odometerTriggerId.length > 0);
        XCTAssertTrue(odometerTrigger.vehicleId != nil && [odometerTrigger.vehicleId isKindOfClass:[NSString class]] && odometerTrigger.vehicleId.length > 0);
        XCTAssertTrue(odometerTrigger.threshold != nil && [odometerTrigger.threshold isKindOfClass:[NSNumber class]]);
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
