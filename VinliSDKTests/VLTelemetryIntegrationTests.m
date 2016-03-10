//
//  VLTelemetryIntegrationTests.m
//  VinliSDK
//
//  Created by Jai Ghanekar on 2/23/16.
//  Copyright © 2016 Vinli. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "VLSessionManager.h"
#import "VLService.h"
#import "VLDevice.h"
#import "VLSnapshot.h"
#import "VLTestHelper.h"
#import "VLTelemetryMessage.h"

@interface VLTelemetryIntegrationTests : XCTestCase


@property NSDictionary *devices;
@property VLDevice *device;
@property NSDictionary *snapshots;
@property NSDictionary *telemetryMessages;
@property VLTelemetryMessage *testMessage;
@property NSDictionary *message;
@property NSDictionary *locations;
@property NSString *messageId;
@property NSDictionary *telemetryMessage;
@property NSString *deviceId;


@end

@implementation VLTelemetryIntegrationTests

//temporary test urls
- (void)setUp {
    [super setUp];

    self.messageId = @"e3b8782c-0f00-4159-8e7d-9bbf221ededd";
    self.deviceId = @"ba89372f-74f4-43c8-a4fd-b8f24699426e";
    
    
    
    XCTestExpectation *expectation = [self expectationWithDescription:@"getting devices call"];
    [[VLSessionManager sharedManager].service startWithHost:[VLTestHelper accessToken] requestUri:@"https://platform.vin.li/api/v1/devices" onSuccess:^(NSDictionary *result, NSHTTPURLResponse *response) {
        [expectation fulfill];
        self.devices = result;
        XCTAssertTrue(YES);
    } onFailure:^(NSError *error, NSHTTPURLResponse *response, NSString *msg) {
        XCTAssertTrue(NO);
    } ];
    
    [self waitForExpectationsWithTimeout:[VLTestHelper defaultTimeOut] handler:nil];
    
    //expectation_s snapshots json
    XCTestExpectation *expectations = [self expectationWithDescription:@"get the snapshots"];
    [[VLSessionManager sharedManager].service startWithHost:[VLTestHelper accessToken] requestUri:[NSString stringWithFormat:@"https://telemetry.vin.li/api/v1/devices/%@/snapshots?fields=rpm", self.deviceId] onSuccess:^(NSDictionary *result, NSHTTPURLResponse *response) {
        [expectations fulfill];
        self.snapshots = result;
    } onFailure:^(NSError *error, NSHTTPURLResponse *response, NSString *msg) {
        XCTAssertTrue(NO);
    }];
    
    [self waitForExpectationsWithTimeout:[VLTestHelper defaultTimeOut] handler:nil];
    
    
    XCTestExpectation *expectationT = [self expectationWithDescription:@"telemetry json"];
    [[VLSessionManager sharedManager].service startWithHost:[VLTestHelper accessToken] requestUri:[NSString stringWithFormat:@"https://telemetry.vin.li/api/v1/devices/%@/messages", self.deviceId ] onSuccess:^(NSDictionary *result, NSHTTPURLResponse *response) {
        [expectationT fulfill];
        self.telemetryMessages = result;
        XCTAssertTrue(YES);
    } onFailure:^(NSError *error, NSHTTPURLResponse *response, NSString *msg) {
        XCTAssertTrue(NO);
    }];
    
//    XCTestExpectation *expectationM = [self expectationWithDescription:@"message expectation"];
//    [[VLSessionManager sharedManager].service startWithHost:[VLTestHelper accessToken] requestUri:@"URL: https://telemetry.vin.li/api/v1/messages/c6101486-cf48-4da9-84b8-87ca14a926e8" onSuccess:^(NSDictionary *result, NSHTTPURLResponse *response) {
//        [expectationM fulfill];
//        self.message = result;
//        XCTAssertTrue(YES);
//    } onFailure:^(NSError *error, NSHTTPURLResponse *response, NSString *msg) {
//        XCTAssertTrue(NO);
//    }];
//    [self waitForExpectationsWithTimeout:[VLTestHelper defaultTimeOut] handler:nil];
    
    XCTestExpectation *expectationL = [self expectationWithDescription:@"Get locations"];
    [[VLSessionManager sharedManager].service startWithHost:[VLTestHelper accessToken] requestUri:[NSString stringWithFormat:@"https://telemetry.vin.li/api/v1/devices/%@/locations", self.deviceId] onSuccess:^(NSDictionary *result, NSHTTPURLResponse *response) {
        [expectationL fulfill];
        self.locations = result;
    } onFailure:^(NSError *error, NSHTTPURLResponse *response, NSString *msg) {
        XCTAssertTrue(NO);
    }];
    
    [self waitForExpectationsWithTimeout:[VLTestHelper defaultTimeOut] handler:nil];
    
    
    XCTestExpectation *deviceExpectation = [self expectationWithDescription:@"get devices with sessionManager"];
    [[VLSessionManager sharedManager].service getDevicesOnSuccess:^(VLDevicePager *devicePager, NSHTTPURLResponse *response) {
        [deviceExpectation fulfill];
        self.device = (devicePager.devices.count > 0) ? devicePager.devices[0] : nil;
        if (self.device) {
            XCTAssertTrue(YES);
        }
    } onFailure:^(NSError *error, NSHTTPURLResponse *response, NSString *bodyString) {
        XCTAssertTrue(NO);
    }];
    
    [self waitForExpectationsWithTimeout:[VLTestHelper defaultTimeOut] handler:nil];
    
    
    XCTestExpectation *expectedTelemetryMessage = [self expectationWithDescription:@"request for a telemetry message"];
    [[VLSessionManager sharedManager].service startWithHost:[VLTestHelper accessToken] requestUri:[NSString stringWithFormat:@"https://telemetry.vin.li/api/v1/messages/%@", self.messageId] onSuccess:^(NSDictionary *result, NSHTTPURLResponse *response) {
        [expectedTelemetryMessage fulfill];
        self.telemetryMessage = result;
        XCTAssertTrue(YES);
    } onFailure:^(NSError *error, NSHTTPURLResponse *response, NSString *msg) {
        XCTAssertTrue(NO);
    }];
    [self waitForExpectationsWithTimeout:[VLTestHelper defaultTimeOut] handler:nil];
    
}





- (void)tearDown {
    [super tearDown];
}

- (void)testGetSnapshotsWithDeviceId {
   NSDictionary *expectedJSON = self.snapshots;
    //getting snapshots
    XCTestExpectation *snapshotExpectation = [self expectationWithDescription:@"Get snapshots"];
    [[VLSessionManager sharedManager].service getSnapshotsForDeviceWithId:self.device.deviceId fields:@"rpm" onSuccess:^(VLSnapshotPager *snapshotPager, NSHTTPURLResponse *response) {
        [snapshotExpectation fulfill];
        XCTAssertEqual(snapshotPager.snapshots.count, [expectedJSON[@"snapshots"] count]);
        XCTAssertEqual(snapshotPager.remaining, [expectedJSON[@"meta"][@"pagination"][@"remaining"] unsignedLongValue]);
        
    } onFailure:^(NSError *error, NSHTTPURLResponse *response, NSString *bodyString) {
        XCTAssertTrue(NO);
    }];
   
    [self waitForExpectationsWithTimeout:[VLTestHelper defaultTimeOut] handler:nil];
    
}



- (void)testGetTelemetryMessageWithDeviceId {
    NSDictionary *expectedJSON = self.telemetryMessages;
    XCTestExpectation *telemetryExpectation = [self expectationWithDescription:@"telemetry messages"];
    [[VLSessionManager sharedManager].service getTelemetryMessagesForDeviceWithId:self.device.deviceId onSuccess:^(VLTelemetryMessagePager *telemetryPager, NSHTTPURLResponse *response) {
        [telemetryExpectation fulfill];
        self.testMessage = (telemetryPager.messages.count > 0) ? telemetryPager.messages[0] : nil;
        
        XCTAssertEqual(telemetryPager.messages.count, [expectedJSON[@"messages"] count]);
        XCTAssertEqual(telemetryPager.remaining, [expectedJSON[@"meta"][@"pagination"][@"remaining"] unsignedLongValue]);
        
    } onFailure:^(NSError *error, NSHTTPURLResponse *response, NSString *bodyString) {
        XCTAssertTrue(NO);
    }];
    [self waitForExpectationsWithTimeout:1.0 handler:nil];
    
    
}



- (void)testGetLocationsWithDeviceId {
    NSDictionary *expectedJSON = self.locations;
    XCTestExpectation *expectedLocations = [self expectationWithDescription:@"Getting locations"];
    [[VLSessionManager sharedManager].service getLocationsForDeviceWithId:self.device.deviceId onSuccess:^(VLLocationPager *locationPager, NSHTTPURLResponse *response) {
        
        [expectedLocations fulfill];
        
        XCTAssertEqual(locationPager.locations.count, [expectedJSON[@"locations"][@"features"] count]);
        
        XCTAssertEqual(locationPager.remaining, [expectedJSON[@"meta"][@"pagination"][@"remaining"] unsignedLongValue]);
        
        XCTAssertEqual([locationPager.locations[0] latitude], [expectedJSON[@"locations"][@"features"][0][@"geometry"][@"coordinates"][1] doubleValue]);
        
    } onFailure:^(NSError *error, NSHTTPURLResponse *response, NSString *bodyString) {
        XCTAssertTrue(NO);
    }];
    
    [self waitForExpectationsWithTimeout:[VLTestHelper defaultTimeOut] handler:nil];
}



- (void)testGetTelemetryMessageWithId {
    NSDictionary *expectedJSON = self.telemetryMessage;
    XCTestExpectation *specificMessageExpectation = [self expectationWithDescription:@"service call for a single telemetry message"];
    [[VLSessionManager sharedManager].service getTelemetryMessageWithId:self.messageId onSuccess:^(VLTelemetryMessage *telemetryMessage, NSHTTPURLResponse *response) {
        [specificMessageExpectation fulfill];
        XCTAssertTrue([telemetryMessage.messageId isEqualToString:expectedJSON[@"message"][@"id"]]);
        XCTAssertEqual(telemetryMessage.latitude, [expectedJSON[@"message"][@"data"][@"location"][@"coordinates"][1]doubleValue ]); //fix to this internally
        
    } onFailure:^(NSError *error, NSHTTPURLResponse *response, NSString *bodyString) {
        XCTAssertTrue(NO);
    }];
    [self waitForExpectationsWithTimeout:[VLTestHelper defaultTimeOut] handler:nil];
}




@end
