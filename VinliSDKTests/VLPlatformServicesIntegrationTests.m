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


@interface VLPlatformServicesIntegrationTests : XCTestCase {
    NSDictionary *devices;
    NSDictionary *vehicles;
    VLDevice *firstDevice;
    NSDictionary *latestVehicle;
    NSDictionary *specificDevice;
}

@property VLService *vlService;

@end

@implementation VLPlatformServicesIntegrationTests

- (void)setUp {
    [super setUp];
    
    _vlService = [VLTestHelper vlService];
    
    XCTestExpectation *expectation = [self expectationWithDescription:@"getting devices call"];
    [_vlService startWithHost:[VLTestHelper accessToken] requestUri:@"https://platform.vin.li/api/v1/devices" onSuccess:^(NSDictionary *result, NSHTTPURLResponse *response) {
        devices = result;
        [expectation fulfill];
    } onFailure:^(NSError *error, NSHTTPURLResponse *response, NSString *msg) {
        XCTAssertTrue(NO);
        [expectation fulfill];
    } ];
    
    XCTestExpectation *expectationv = [self expectationWithDescription:@"getting vehicles call"];
    [_vlService startWithHost:[VLTestHelper accessToken] requestUri:[NSString stringWithFormat:@"https://platform.vin.li/api/v1/devices/%@/vehicles", [VLTestHelper deviceId]] onSuccess:^(NSDictionary *result, NSHTTPURLResponse *response) {
        vehicles = result;
        [expectationv fulfill];
    } onFailure:^(NSError *error, NSHTTPURLResponse *response, NSString *msg) {
        XCTAssertTrue(NO);
        [expectationv fulfill];
    } ];
    
    XCTestExpectation *deviceExpectation = [self expectationWithDescription:@"get devices with sessionManager"];
    [_vlService getDevicesOnSuccess:^(VLDevicePager *devicePager, NSHTTPURLResponse *response) {
        firstDevice = (devicePager.devices.count > 0) ? devicePager.devices[0] : nil;
        [deviceExpectation fulfill];
    } onFailure:^(NSError *error, NSHTTPURLResponse *response, NSString *bodyString) {
        XCTAssertTrue(NO);
        [deviceExpectation fulfill];
    }];
    
    XCTestExpectation *expectationLV = [self expectationWithDescription:@"URI to get the latest vehicle"];
    [_vlService startWithHost:[VLTestHelper accessToken] requestUri:[NSString stringWithFormat:@"https://platform.vin.li/api/v1/devices/%@/vehicles/_latest", [VLTestHelper deviceId]] onSuccess:^(NSDictionary *result, NSHTTPURLResponse *response) {
        latestVehicle = result;
        [expectationLV fulfill];
    } onFailure:^(NSError *error, NSHTTPURLResponse *response, NSString *msg) {
        XCTAssertTrue(NO);
        [expectationLV fulfill];
    }];
    
    XCTestExpectation *expectationDevice = [self expectationWithDescription:@"get specific device"];
    [_vlService startWithHost:[VLTestHelper accessToken] requestUri:[NSString stringWithFormat:@"https://platform.vin.li/api/v1/devices/%@", [VLTestHelper deviceId]] onSuccess:^(NSDictionary *result, NSHTTPURLResponse *response) {
        [expectationDevice fulfill];
        specificDevice = result;
    } onFailure:^(NSError *error, NSHTTPURLResponse *response, NSString *msg) {
        XCTAssertTrue(NO);
        [expectationDevice fulfill];
    }];
    
    [self waitForExpectationsWithTimeout:[VLTestHelper defaultTimeOut] handler:nil];
}

- (void)tearDown {
    [super tearDown];
}

- (void)testGetAllDevices {
    NSDictionary *expectedJSON = devices;
    
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
    NSDictionary *expectedJSON = vehicles;
    
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
    NSDictionary *expectedJSON = [VLTestHelper cleanDictionary:latestVehicle[@"vehicle"]];
    
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
    NSDictionary *expectedJSON = specificDevice;
    
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
