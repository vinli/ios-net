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
    if(!_vlService){
        XCTAssertTrue(NO);
        return;
    }
    
    XCTestExpectation *expectation = [self expectationWithDescription:@"get all devices"];
   [_vlService getDevicesOnSuccess:^(VLDevicePager *devicePager, NSHTTPURLResponse *response) {
       XCTAssertTrue(devicePager.devices.count > 0);
       XCTAssertTrue(devicePager.total > 0);
       
       for(VLDevice *device in devicePager.devices){
           XCTAssertTrue(device.deviceId != nil && [device.deviceId isKindOfClass:[NSString class]] && device.deviceId.length > 0);
           XCTAssertTrue(device.name != nil && [device.name isKindOfClass:[NSString class]]);
       }
       [expectation fulfill];
   } onFailure:^(NSError *error, NSHTTPURLResponse *response, NSString *bodyString) {
       XCTAssertTrue(NO);
       [expectation fulfill];
   }];
    
  [self waitForExpectationsWithTimeout:[VLTestHelper defaultTimeOut] handler:nil];
}

- (void)testAllVehicleWithDeviceId {
    if(![VLTestHelper deviceId]){
        XCTAssertTrue(NO);
        return;
    }
    
    XCTestExpectation *vehicleExpecation = [self expectationWithDescription:@"Expecting vehicles"];
        [_vlService getVehiclesForDeviceWithId:[VLTestHelper deviceId] onSuccess:^(VLVehiclePager *vehiclePager, NSHTTPURLResponse *response) {
            XCTAssertTrue(vehiclePager.vehicles.count > 0);
            XCTAssertTrue(vehiclePager.total > 0);
            
            for(VLVehicle *vehicle in vehiclePager.vehicles){
                XCTAssertTrue(vehicle.vehicleId != nil && [vehicle.vehicleId isKindOfClass:[NSString class]] && vehicle.vehicleId.length > 0);
                XCTAssertTrue(vehicle.vin != nil && [vehicle.vin isKindOfClass:[NSString class]] && vehicle.vin.length > 0);
            }
            [vehicleExpecation fulfill];
        } onFailure:^(NSError *error, NSHTTPURLResponse *response, NSString *bodyString) {
            XCTAssertTrue(NO);
            [vehicleExpecation fulfill];
        }];
    
    [self waitForExpectationsWithTimeout:[VLTestHelper defaultTimeOut] handler:nil];
}

- (void)testGetLastestVehicleWithDeviceId {
    if(![VLTestHelper deviceId]){
        XCTAssertTrue(NO);
        return;
    }
    
    XCTestExpectation *expectedLatestVehicle = [self expectationWithDescription:@"service call for latest vehicles"];
    [_vlService getLatestVehicleForDeviceWithId:[VLTestHelper deviceId] onSuccess:^(VLVehicle *vehicle, NSHTTPURLResponse *response) {
        XCTAssertTrue(vehicle.vehicleId != nil && [vehicle.vehicleId isKindOfClass:[NSString class]] && vehicle.vehicleId.length > 0);
        XCTAssertTrue(vehicle.vin != nil && [vehicle.vin isKindOfClass:[NSString class]] && vehicle.vin.length > 0);
        [expectedLatestVehicle fulfill];
    } onFailure:^(NSError *error, NSHTTPURLResponse *response, NSString *bodyString) {
        XCTAssertTrue(NO);
        [expectedLatestVehicle fulfill];
    }];
    
    [self waitForExpectationsWithTimeout:[VLTestHelper defaultTimeOut] handler:nil];
}

- (void)testGetDeviceWithId {
    if(![VLTestHelper deviceId]){
        XCTAssertTrue(NO);
        return;
    }
    
    XCTestExpectation *singleDeviceExpectation = [self expectationWithDescription:@"service call for a single device"];
    [_vlService getDeviceWithId:[VLTestHelper deviceId] onSuccess:^(VLDevice *device, NSHTTPURLResponse *response) {
        XCTAssertTrue(device.deviceId != nil && [device.deviceId isKindOfClass:[NSString class]] && device.deviceId.length > 0);
        XCTAssertTrue(device.name != nil && [device.name isKindOfClass:[NSString class]]);
        [singleDeviceExpectation fulfill];
    } onFailure:^(NSError *error, NSHTTPURLResponse *response, NSString *bodyString) {
        XCTAssertTrue(NO);
        [singleDeviceExpectation fulfill];
    } ];
    
    [self waitForExpectationsWithTimeout:[VLTestHelper defaultTimeOut] handler:nil];
}

@end
