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


@interface VLPlatformServicesIntegrationTests : XCTestCase {
    NSDictionary *devices;
    NSDictionary *vehicles;
    NSString *accessToken;
    VLDevice *firstDevice;
}

@end



@implementation VLPlatformServicesIntegrationTests

- (void)setUp {
    [super setUp];
    accessToken = @"HbZ_1S2vdywJk72iuPofm816fRhmYgRhT0OTwpyQX0okmDElQ7J8p5W_sKNUr8iE";
    XCTestExpectation *expectation = [self expectationWithDescription:@"getting devices call"];
    [[VLSessionManager sharedManager].service startWithHost:accessToken requestUri:@"https://platform.vin.li/api/v1/devices" onSuccess:^(NSDictionary *result, NSHTTPURLResponse *response) {
        [expectation fulfill];
        devices = result;
        XCTAssertTrue(YES);
    } onFailure:^(NSError *error, NSHTTPURLResponse *response, NSString *msg) {
        XCTAssertTrue(NO);
    } ];
    
    [self waitForExpectationsWithTimeout:0.5 handler:nil];
    
    XCTestExpectation *expectationv = [self expectationWithDescription:@"getting vehicles call"];

    [[VLSessionManager sharedManager].service startWithHost:accessToken requestUri:@"https://platform.vin.li/api/v1/devices/d47ef610-c7b9-44ac-9a41-39f9c6056de5/vehicles" onSuccess:^(NSDictionary *result, NSHTTPURLResponse *response) {
        [expectationv fulfill];
        vehicles = result;
        XCTAssertTrue(YES);
    } onFailure:^(NSError *error, NSHTTPURLResponse *response, NSString *msg) {
        XCTAssertTrue(NO);
    } ];
    
    [self waitForExpectationsWithTimeout:0.5 handler:nil];
    
    
    
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
    
    [self waitForExpectationsWithTimeout:0.5 handler:nil];
    

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
    
  [self waitForExpectationsWithTimeout:0.5 handler:nil];
}


- (void)testGetLatestVehicleWithDeviceId {
    //using this method to just test vehicles no redundant calls
    NSDictionary *expectedJSON = vehicles; //add in raw json
    XCTestExpectation *vehicleExpecation = [self expectationWithDescription:@"Expecting vehicles"];
        [[VLSessionManager sharedManager].service getVehiclesForDeviceWithId:firstDevice.deviceId onSuccess:^(VLVehiclePager *vehiclePager, NSHTTPURLResponse *response) {
            [vehicleExpecation fulfill];
            VLVehicle *vehicle = (vehiclePager.vehicles.count > 0) ? vehiclePager.vehicles[0] : nil;
            XCTAssertEqualObjects(vehicle.make, expectedJSON[@"vehicles"][0][@"make"]);
        } onFailure:^(NSError *error, NSHTTPURLResponse *response, NSString *bodyString) {
            XCTAssertTrue(NO);
        }];
    [self waitForExpectationsWithTimeout:0.5 handler:nil];

}







@end
