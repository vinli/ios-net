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



@interface VLPlatformServicesIntegrationTests : XCTestCase {
        
}

@end



@implementation VLPlatformServicesIntegrationTests

- (void)setUp {
    [super setUp];
    
    
    
}

- (void)tearDown {
    [super tearDown];
    
}

- (void)testGetAllDevices {
    NSDictionary *expectedJSON = @{}; //this will be the calls raw json
    
    XCTestExpectation *expectation = [self expectationWithDescription:@"get all devices"];
    
   [[VLSessionManager sharedManager].service getDevicesOnSuccess:^(VLDevicePager *devicePager, NSHTTPURLResponse *response) {
       
       [expectation fulfill];
       XCTAssertEqual(devicePager.devices.count, [expectedJSON[@"devices"] count]);
       XCTAssertEqual([[devicePager.devices objectAtIndex:0] deviceId], expectedJSON[@"devices"][0][@"id"]);
       XCTAssertEqual([[devicePager.devices objectAtIndex:0] selfURL].absoluteString, expectedJSON[@"devices"][0][@"links"][@"self"]);
       XCTAssertEqual(devicePager.total, [expectedJSON[@"meta"][@"pagination"][@"total"] unsignedIntegerValue]);

       
   } onFailure:^(NSError *error, NSHTTPURLResponse *response, NSString *bodyString) {
       XCTAssertTrue(NO);
   }];
    
  [self waitForExpectationsWithTimeout:0.5 handler:nil];
}


- (void)testGetLatestVehicleWithDeviceId {
    NSDictionary *expectedJSON = @{}; //add in raw json
    [[VLSessionManager sharedManager].service getDevicesOnSuccess:^(VLDevicePager *devicePager, NSHTTPURLResponse *response) {
        VLDevice *device = (devicePager.devices.count > 0) ? devicePager.devices[0] : nil;
        [[VLSessionManager sharedManager].service getVehiclesForDeviceWithId:device.deviceId onSuccess:^(VLVehiclePager *vehiclePager, NSHTTPURLResponse *response) {
            VLVehicle *vehicle = (vehiclePager.vehicles.count > 0) ? vehiclePager.vehicles[0] : nil;
            XCTAssertEqual(vehicle.make, expectedJSON[@"vehicle"][@"make"]);
        } onFailure:^(NSError *error, NSHTTPURLResponse *response, NSString *bodyString) {
            XCTAssertTrue(NO);
        }];
        
    } onFailure:nil];
}







@end
