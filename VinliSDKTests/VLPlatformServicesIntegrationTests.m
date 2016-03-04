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


@interface VLPlatformServicesIntegrationTests : XCTestCase {
    NSDictionary *devices;
    NSDictionary *vehicles;
    NSString *accessToken;
    VLDevice *firstDevice;
    NSDictionary *latestVehicle;
    NSString *deviceId;
    NSDictionary *specificDevice;
    NSTimeInterval defaultTimeOut;
    
}

@end



@implementation VLPlatformServicesIntegrationTests

- (void)setUp {
    [super setUp];
    accessToken = @"HbZ_1S2vdywJk72iuPofm816fRhmYgRhT0OTwpyQX0okmDElQ7J8p5W_sKNUr8iE";
    deviceId = @"ba89372f-74f4-43c8-a4fd-b8f24699426e";
    defaultTimeOut = 5.0;
    XCTestExpectation *expectation = [self expectationWithDescription:@"getting devices call"];
    [[VLSessionManager sharedManager].service startWithHost:accessToken requestUri:@"https://platform.vin.li/api/v1/devices" onSuccess:^(NSDictionary *result, NSHTTPURLResponse *response) {
        [expectation fulfill];
        devices = result;
        XCTAssertTrue(YES);
    } onFailure:^(NSError *error, NSHTTPURLResponse *response, NSString *msg) {
        XCTAssertTrue(NO);
    } ];
    
    [self waitForExpectationsWithTimeout:defaultTimeOut handler:nil];
    
    XCTestExpectation *expectationv = [self expectationWithDescription:@"getting vehicles call"];

    [[VLSessionManager sharedManager].service startWithHost:accessToken requestUri:[NSString stringWithFormat:@"https://platform.vin.li/api/v1/devices/%@/vehicles",deviceId] onSuccess:^(NSDictionary *result, NSHTTPURLResponse *response) {
        [expectationv fulfill];
        vehicles = result;
        XCTAssertTrue(YES);
    } onFailure:^(NSError *error, NSHTTPURLResponse *response, NSString *msg) {
        XCTAssertTrue(NO);
    } ];
    
    [self waitForExpectationsWithTimeout:defaultTimeOut handler:nil];
    
    
    
    XCTestExpectation *deviceExpectation = [self expectationWithDescription:@"get devices with sessionManager"];
    [[VLSessionManager sharedManager].service getDevicesOnSuccess:^(VLDevicePager *devicePager, NSHTTPURLResponse *response) {
        [deviceExpectation fulfill];
        firstDevice = (devicePager.devices.count > 0) ? devicePager.devices[0] : nil;
        if (firstDevice) {
            XCTAssertTrue(YES);
        }
    } onFailure:^(NSError *error, NSHTTPURLResponse *response, NSString *bodyString) {
        XCTAssertTrue(NO);
    }];
    
    [self waitForExpectationsWithTimeout:defaultTimeOut handler:nil];
    
    
    
    XCTestExpectation *expectationLV = [self expectationWithDescription:@"URI to get the latest vehicle"];
    [[VLSessionManager sharedManager].service startWithHost:accessToken requestUri:[NSString stringWithFormat:@"https://platform.vin.li/api/v1/devices/%@/vehicles/_latest", deviceId] onSuccess:^(NSDictionary *result, NSHTTPURLResponse *response) {
        [expectationLV fulfill];
        latestVehicle = result;
        XCTAssertTrue(YES);
    } onFailure:^(NSError *error, NSHTTPURLResponse *response, NSString *msg) {
        XCTAssertTrue(NO);
    }];
    
    [self waitForExpectationsWithTimeout:defaultTimeOut handler:nil];
    
    
    XCTestExpectation *expectationDevice = [self expectationWithDescription:@"get specific device"];
    [[VLSessionManager sharedManager].service startWithHost:accessToken requestUri:[NSString stringWithFormat:@"https://platform.vin.li/api/v1/devices/%@", deviceId] onSuccess:^(NSDictionary *result, NSHTTPURLResponse *response) {
        [expectationDevice fulfill];
        specificDevice = result;
    } onFailure:^(NSError *error, NSHTTPURLResponse *response, NSString *msg) {
        XCTAssertTrue(NO);
    }];
    [self waitForExpectationsWithTimeout:defaultTimeOut handler:nil];
    
    

}



- (void)tearDown {
    [super tearDown];
    
}

- (void)testGetAllDevices {
    NSDictionary *expectedJSON = devices; //this will be the calls raw json
    
    XCTestExpectation *expectation = [self expectationWithDescription:@"get all devices"];
    
   [[VLSessionManager sharedManager].service getDevicesOnSuccess:^(VLDevicePager *devicePager, NSHTTPURLResponse *response) {
       
       [expectation fulfill];
       XCTAssertEqual(devicePager.devices.count, [expectedJSON[@"devices"] count]);
       XCTAssertEqualObjects([[devicePager.devices objectAtIndex:0] deviceId], expectedJSON[@"devices"][0][@"id"]);
       XCTAssertEqualObjects([[devicePager.devices objectAtIndex:0] selfURL].absoluteString, expectedJSON[@"devices"][0][@"links"][@"self"]);
       XCTAssertEqual(devicePager.total, [expectedJSON[@"meta"][@"pagination"][@"total"] unsignedIntegerValue]);

       
   } onFailure:^(NSError *error, NSHTTPURLResponse *response, NSString *bodyString) {
       XCTAssertTrue(NO);
   }];
    
  [self waitForExpectationsWithTimeout:defaultTimeOut handler:nil];
}


- (void)testAllVehicleWithDeviceId {
    //using this method to just test vehicles no redundant calls
    NSDictionary *expectedJSON = vehicles; //add in raw json
    XCTestExpectation *vehicleExpecation = [self expectationWithDescription:@"Expecting vehicles"];
        [[VLSessionManager sharedManager].service getVehiclesForDeviceWithId:deviceId onSuccess:^(VLVehiclePager *vehiclePager, NSHTTPURLResponse *response) {
            [vehicleExpecation fulfill];
            //VLVehicle *vehicle = (vehiclePager.vehicles.count > 0) ? vehiclePager.vehicles[0] : nil;
            //XCTAssertEqualObjects(vehicle.make, expectedJSON[@"vehicles"][0][@"make"]);
        } onFailure:^(NSError *error, NSHTTPURLResponse *response, NSString *bodyString) {
            XCTAssertTrue(NO);
        }];
    [self waitForExpectationsWithTimeout:defaultTimeOut handler:nil];

}

- (void)testGetLastestVehicleWithDeviceId {
    NSDictionary *expectedJSON = latestVehicle;
    XCTestExpectation *expectedLatestVehicle = [self expectationWithDescription:@"service call for latest vehicles"];
    [[VLSessionManager sharedManager].service getLatestVehicleForDeviceWithId:deviceId onSuccess:^(VLVehicle *vehicle, NSHTTPURLResponse *response) {
        [expectedLatestVehicle fulfill];
        //XCTAssertEqual(vehicle.make, expectedJSON[@"vehicle"][@"make"]);
        XCTAssertTrue(YES);
    } onFailure:^(NSError *error, NSHTTPURLResponse *response, NSString *bodyString) {
        XCTAssertTrue(NO);
    }];
    [self waitForExpectationsWithTimeout:defaultTimeOut handler:nil];
    
}


- (void)testGetDeviceWithId {
    NSDictionary *expectedJSON = specificDevice;
    XCTestExpectation *singleDeviceExpectation = [self expectationWithDescription:@"service call for a single device"];
    [[VLSessionManager sharedManager].service getDeviceWithId:deviceId onSuccess:^(VLDevice *device, NSHTTPURLResponse *response) {
        [singleDeviceExpectation fulfill];
        XCTAssertEqualObjects(device.deviceId, expectedJSON[@"device"][@"id"]);
        XCTAssertEqualObjects(device.selfURL.absoluteString, expectedJSON[@"device"][@"links"][@"self"]);
    } onFailure:^(NSError *error, NSHTTPURLResponse *response, NSString *bodyString) {
        XCTAssertTrue(NO);
    } ];
    [self waitForExpectationsWithTimeout:defaultTimeOut handler:nil];
}










@end
