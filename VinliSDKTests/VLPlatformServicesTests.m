//
//  VLPlatformServicesTests.m
//  VinliSDK
//
//  Created by Tommy Brown on 5/22/15.
//  Copyright (c) 2015 Vinli. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>
#import <OCMock/OCMock.h>
#import "VLService.h"
#import "VLTestHelper.h"

@interface VLPlatformServicesTests : XCTestCase{
    VLService *connection;
    NSString * deviceId;
}
@end

@implementation VLPlatformServicesTests

- (void)setUp {
    [super setUp];
    connection = [[VLService alloc] init];
    [connection useSession:[[VLSession alloc] initWithAccessToken:@"TEST"]];
    deviceId = @"11111111-2222-3333-4444-555555555555";
}

- (void)tearDown {
    [super tearDown];
}

- (void) testGetAllDevices{
    id mockConnection = OCMPartialMock(connection);
    
    NSDictionary *expectedJSON = [VLTestHelper getAllDevicesJSON];
    
    [[[mockConnection expect] andDo:^(NSInvocation *invocation) {
        
        NSDictionary *devices = [expectedJSON copy];
        
        NSHTTPURLResponse *response = [[NSHTTPURLResponse alloc] initWithURL:[NSURL new] statusCode:200 HTTPVersion:nil headerFields:nil];
        
        void (^successBlock)(NSDictionary *result, NSHTTPURLResponse *response) = nil;
        
        [invocation getArgument:&successBlock atIndex:8];
        
        successBlock(devices, response);
        
    }] startWithHost:[OCMArg any] path:[OCMArg any] queries:[OCMArg any] HTTPMethod:[OCMArg any] parameters:[OCMArg any] token:[OCMArg any] onSuccess:[OCMArg any] onFailure:[OCMArg any]];
    
    [connection getDevicesOnSuccess:^(VLDevicePager *devicePager, NSHTTPURLResponse *response) {
        
        XCTAssertEqual(devicePager.devices.count, [expectedJSON[@"devices"] count]);
        XCTAssertEqual([[devicePager.devices objectAtIndex:0] deviceId], expectedJSON[@"devices"][0][@"id"]);
        XCTAssertEqual([[devicePager.devices objectAtIndex:0] selfURL].absoluteString, expectedJSON[@"devices"][0][@"links"][@"self"]);
        XCTAssertEqual(devicePager.total, [expectedJSON[@"meta"][@"pagination"][@"total"] unsignedIntegerValue]);
        
    } onFailure:^(NSError *error, NSHTTPURLResponse *response, NSString *bodyString) {
        XCTAssertTrue(NO);
    }];
}

- (void) testGetLatestVehicleWithDeviceId{
    id mockConnection = OCMPartialMock(connection);
    
    NSDictionary *expectedJSON = [VLTestHelper getVehicleJSON:deviceId];
    
    [[[mockConnection expect] andDo:^(NSInvocation *invocation) {
        
        NSDictionary *vehicle = [expectedJSON copy];
        
        NSHTTPURLResponse *response = [[NSHTTPURLResponse alloc] initWithURL:[NSURL new] statusCode:200 HTTPVersion:nil headerFields:nil];
        
        void (^successBlock)(NSDictionary *result, NSHTTPURLResponse *response) = nil;
        
        [invocation getArgument:&successBlock atIndex:8];
        
        successBlock(vehicle, response);
        
    }] startWithHost:[OCMArg any] path:[OCMArg any] queries:[OCMArg any] HTTPMethod:[OCMArg any] parameters:[OCMArg any] token:[OCMArg any] onSuccess:[OCMArg any] onFailure:[OCMArg any]];
    
    [connection getLatestVehicleForDeviceWithId:deviceId onSuccess:^(VLVehicle *vehicle, NSHTTPURLResponse *response) {
        
        XCTAssertEqual(vehicle.make, expectedJSON[@"vehicle"][@"make"]);
        
    } onFailure:^(NSError *error, NSHTTPURLResponse *response, NSString *bodyString) {
        XCTAssertTrue(NO);
    }];
}

- (void) testGetAllVehiclesForDeviceWithId{
    id mockConnection = OCMPartialMock(connection);
    
    NSDictionary *expectedJSON = [VLTestHelper getAllVehiclesJSON:deviceId];
    
    [[[mockConnection expect] andDo:^(NSInvocation *invocation) {
        
        NSDictionary *vehicle = [expectedJSON copy];
        
        NSHTTPURLResponse *response = [[NSHTTPURLResponse alloc] initWithURL:[NSURL new] statusCode:200 HTTPVersion:nil headerFields:nil];
        
        void (^successBlock)(NSDictionary *result, NSHTTPURLResponse *response) = nil;
        
        [invocation getArgument:&successBlock atIndex:8];
        
        successBlock(vehicle, response);
        
    }] startWithHost:[OCMArg any] path:[OCMArg any] queries:[OCMArg any] HTTPMethod:[OCMArg any] parameters:[OCMArg any] token:[OCMArg any] onSuccess:[OCMArg any] onFailure:[OCMArg any]];
    
    [connection getVehiclesForDeviceWithId:deviceId onSuccess:^(VLVehiclePager *vehiclePager, NSHTTPURLResponse *response) {
        XCTAssertEqual(vehiclePager.vehicles.count, [expectedJSON[@"vehicles"] count]); // Make sure that there are two objects in the array.
        
        XCTAssertEqual(vehiclePager.total, [expectedJSON[@"meta"][@"pagination"][@"total"] unsignedLongValue]); // Make sure that the Meta more or less translated correctly.
        
        XCTAssertEqual([[vehiclePager.vehicles objectAtIndex:0] make], expectedJSON[@"vehicles"][0][@"make"]); // Make sure that the vehicles array more or less translated correctly
        
        
    } onFailure:^(NSError *error, NSHTTPURLResponse *response, NSString *bodyString) {
        XCTAssertTrue(NO);
    }];
}

- (void) testGetSpecificDeviceWithId{
    id mockConnection = OCMPartialMock(connection);
    NSDictionary *expectedJSON = [VLTestHelper getDeviceJSON:deviceId];
    
    [[[mockConnection expect] andDo:^(NSInvocation *invocation) {
        
        NSDictionary *device = [expectedJSON copy];
        
        
        NSHTTPURLResponse *response = [[NSHTTPURLResponse alloc] initWithURL:[NSURL new] statusCode:200 HTTPVersion:nil headerFields:nil];
        
        void (^successBlock)(NSDictionary *result, NSHTTPURLResponse *response) = nil;
        
        [invocation getArgument:&successBlock atIndex:8];
        
        successBlock(device, response);
        
    }] startWithHost:[OCMArg any] path:[OCMArg any] queries:[OCMArg any] HTTPMethod:[OCMArg any] parameters:[OCMArg any] token:[OCMArg any] onSuccess:[OCMArg any] onFailure:[OCMArg any]];
    
    [connection getDeviceWithId:deviceId onSuccess:^(VLDevice *device, NSHTTPURLResponse *response) {
        
        XCTAssertEqual(device.deviceId, expectedJSON[@"device"][@"id"]);
        XCTAssertEqual(device.selfURL.absoluteString, expectedJSON[@"device"][@"links"][@"self"]);
        
    } onFailure:^(NSError *error, NSHTTPURLResponse *response, NSString *bodyString) {
        XCTAssertTrue(NO);
    }];
}

@end
