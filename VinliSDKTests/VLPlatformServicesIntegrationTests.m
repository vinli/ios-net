//
//  VLPlatformServicesIntegrationTests.m
//  VinliSDK
//
//  Created by Jai Ghanekar on 2/18/16.
//  Copyright © 2016 Vinli. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "VLService.h"
#import "VLSessionManager.h"
#import "VLDevice.h"
#import "VLVehicle.h"
#import "VLTestHelper.h"


@interface VLPlatformServicesIntegrationTests : XCTestCase

@property VLService *vlService;

@end

@implementation VLPlatformServicesIntegrationTests

- (void)setUp {
    [super setUp];
    
    _vlService = [VLTestHelper vlService];
}

- (void)tearDown {
    [super tearDown];
}

- (void)testGetAllDevices {
    NSDictionary *expectedJSON = [VLTestHelper getAllDevicesJSON];
    
    if(!_vlService){
        XCTAssertTrue(NO);
        return;
    }
    
    XCTestExpectation *expectation = [self expectationWithDescription:@"get all devices"];
   [_vlService getDevicesOnSuccess:^(VLDevicePager *devicePager, NSHTTPURLResponse *response) {
       XCTAssertEqual(devicePager.devices.count, [expectedJSON[@"devices"] count]);
       XCTAssertEqualObjects([[devicePager.devices objectAtIndex:0] deviceId], expectedJSON[@"devices"][0][@"id"]);
       XCTAssertEqualObjects([[devicePager.devices objectAtIndex:0] selfURL].absoluteString, expectedJSON[@"devices"][0][@"links"][@"self"]);
       XCTAssertEqual(devicePager.total, [expectedJSON[@"meta"][@"pagination"][@"total"] unsignedIntegerValue]);
       [expectation fulfill];
   } onFailure:^(NSError *error, NSHTTPURLResponse *response, NSString *bodyString) {
       XCTAssertTrue(NO);
       [expectation fulfill];
   }];
    
  [self waitForExpectationsWithTimeout:[VLTestHelper defaultTimeOut] handler:nil];
}

- (void)testAllVehicleWithDeviceId {
    NSDictionary *expectedJSON = [VLTestHelper getAllVehiclesJSON:@"2ad86caa-5a30-429e-80b8-80bc3da5efe6"];
    
    if(![VLTestHelper deviceId]){
        XCTAssertTrue(NO);
        return;
    }
    
    XCTestExpectation *vehicleExpecation = [self expectationWithDescription:@"Expecting vehicles"];
        [_vlService getVehiclesForDeviceWithId:[VLTestHelper deviceId] onSuccess:^(VLVehiclePager *vehiclePager, NSHTTPURLResponse *response) {
            VLVehicle *vehicle = (vehiclePager.vehicles.count > 0) ? vehiclePager.vehicles[0] : nil;
            XCTAssertEqualObjects(vehicle.make, expectedJSON[@"vehicles"][0][@"make"]);
            [vehicleExpecation fulfill];
        } onFailure:^(NSError *error, NSHTTPURLResponse *response, NSString *bodyString) {
            XCTAssertTrue(NO);
            [vehicleExpecation fulfill];
        }];
    
    [self waitForExpectationsWithTimeout:[VLTestHelper defaultTimeOut] handler:nil];
}

- (void)testGetLastestVehicleWithDeviceId {
    NSDictionary *expectedJSON = [VLTestHelper getVehicleJSON:@"2ad86caa-5a30-429e-80b8-80bc3da5efe6"];
    
    if(![VLTestHelper deviceId]){
        XCTAssertTrue(NO);
        return;
    }
    
    XCTestExpectation *expectedLatestVehicle = [self expectationWithDescription:@"service call for latest vehicles"];
    [_vlService getLatestVehicleForDeviceWithId:[VLTestHelper deviceId] onSuccess:^(VLVehicle *vehicle, NSHTTPURLResponse *response) {
        XCTAssertEqualObjects(vehicle.vehicleId, expectedJSON[@"id"]);
        XCTAssertEqualObjects(vehicle.year, expectedJSON[@"year"]);
        XCTAssertEqualObjects(vehicle.make, expectedJSON[@"make"]);
        XCTAssertEqualObjects(vehicle.model, expectedJSON[@"model"]);
        XCTAssertEqualObjects(vehicle.trim, expectedJSON[@"trim"]);
        XCTAssertEqualObjects(vehicle.vin, expectedJSON[@"vin"]);
        XCTAssertEqualObjects(vehicle.name, expectedJSON[@"name"]);
        [expectedLatestVehicle fulfill];
    } onFailure:^(NSError *error, NSHTTPURLResponse *response, NSString *bodyString) {
        XCTAssertTrue(NO);
        [expectedLatestVehicle fulfill];
    }];
    
    [self waitForExpectationsWithTimeout:[VLTestHelper defaultTimeOut] handler:nil];
}

- (void)testGetDeviceWithId {
    NSDictionary *expectedJSON = [VLTestHelper getDeviceJSON:@"2ad86caa-5a30-429e-80b8-80bc3da5efe6"];
    
    if(![VLTestHelper deviceId]){
        XCTAssertTrue(NO);
        return;
    }
    
    XCTestExpectation *singleDeviceExpectation = [self expectationWithDescription:@"service call for a single device"];
    [_vlService getDeviceWithId:[VLTestHelper deviceId] onSuccess:^(VLDevice *device, NSHTTPURLResponse *response) {
        XCTAssertEqualObjects(device.deviceId, expectedJSON[@"device"][@"id"]);
        XCTAssertEqualObjects(device.selfURL.absoluteString, expectedJSON[@"device"][@"links"][@"self"]);
        [singleDeviceExpectation fulfill];
    } onFailure:^(NSError *error, NSHTTPURLResponse *response, NSString *bodyString) {
        XCTAssertTrue(NO);
        [singleDeviceExpectation fulfill];
    } ];
    
    [self waitForExpectationsWithTimeout:[VLTestHelper defaultTimeOut] handler:nil];
}

@end
