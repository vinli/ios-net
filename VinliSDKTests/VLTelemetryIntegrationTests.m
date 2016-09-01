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

@property VLService *vlService;
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

    self.vlService = [VLTestHelper vlService];
    self.messageId = [VLTestHelper telemetryMessageId];

    XCTestExpectation *expectations = [self expectationWithDescription:@"get the snapshots"];
    [_vlService startWithHost:[VLTestHelper accessToken] requestUri:[NSString stringWithFormat:@"https://telemetry.vin.li/api/v1/devices/%@/snapshots?fields=rpm", [VLTestHelper deviceId]] onSuccess:^(NSDictionary *result, NSHTTPURLResponse *response) {
        self.snapshots = result;
        [expectations fulfill];
    } onFailure:^(NSError *error, NSHTTPURLResponse *response, NSString *msg) {
        XCTAssertTrue(NO);
        [expectations fulfill];
    }];
    
    XCTestExpectation *expectationT = [self expectationWithDescription:@"telemetry json"];
    [_vlService startWithHost:[VLTestHelper accessToken] requestUri:[NSString stringWithFormat:@"https://telemetry.vin.li/api/v1/devices/%@/messages", [VLTestHelper deviceId] ] onSuccess:^(NSDictionary *result, NSHTTPURLResponse *response) {
        self.telemetryMessages = result;
        [expectationT fulfill];
    } onFailure:^(NSError *error, NSHTTPURLResponse *response, NSString *msg) {
        XCTAssertTrue(NO);
        [expectationT fulfill];
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
    [_vlService startWithHost:[VLTestHelper accessToken] requestUri:[NSString stringWithFormat:@"https://telemetry.vin.li/api/v1/devices/%@/locations", [VLTestHelper deviceId]] onSuccess:^(NSDictionary *result, NSHTTPURLResponse *response) {
        self.locations = result;
        [expectationL fulfill];
    } onFailure:^(NSError *error, NSHTTPURLResponse *response, NSString *msg) {
        XCTAssertTrue(NO);
        [expectationL fulfill];
    }];
    
    XCTestExpectation *expectedTelemetryMessage = [self expectationWithDescription:@"request for a telemetry message"];
    [_vlService startWithHost:[VLTestHelper accessToken] requestUri:[NSString stringWithFormat:@"https://telemetry.vin.li/api/v1/messages/%@", self.messageId] onSuccess:^(NSDictionary *result, NSHTTPURLResponse *response) {
        self.telemetryMessage = result;
        [expectedTelemetryMessage fulfill];
    } onFailure:^(NSError *error, NSHTTPURLResponse *response, NSString *msg) {
        XCTAssertTrue(NO);
        [expectedTelemetryMessage fulfill];
    }];
    
    [self waitForExpectationsWithTimeout:[VLTestHelper defaultTimeOut] handler:nil];
}

- (void)tearDown {
    [super tearDown];
}

- (void)testGetSnapshotsWithDeviceId {
   NSDictionary *expectedJSON = self.snapshots;
    
    XCTestExpectation *snapshotExpectation = [self expectationWithDescription:@"Get snapshots"];
    [_vlService getSnapshotsForDeviceWithId:[VLTestHelper deviceId] fields:@"rpm" onSuccess:^(VLSnapshotPager *snapshotPager, NSHTTPURLResponse *response) {
        XCTAssertEqual(snapshotPager.snapshots.count, [expectedJSON[@"snapshots"] count]);
        XCTAssertEqual(snapshotPager.remaining, [expectedJSON[@"meta"][@"pagination"][@"remaining"] unsignedLongValue]);
        [snapshotExpectation fulfill];
    } onFailure:^(NSError *error, NSHTTPURLResponse *response, NSString *bodyString) {
        XCTAssertTrue(NO);
        [snapshotExpectation fulfill];
    }];
   
    [self waitForExpectationsWithTimeout:[VLTestHelper defaultTimeOut] handler:nil];
}

- (void)testGetTelemetryMessageWithDeviceId {
    NSDictionary *expectedJSON = self.telemetryMessages;
    
    XCTestExpectation *telemetryExpectation = [self expectationWithDescription:@"telemetry messages"];
    [_vlService getTelemetryMessagesForDeviceWithId:[VLTestHelper deviceId] onSuccess:^(VLTelemetryMessagePager *telemetryPager, NSHTTPURLResponse *response) {
        self.testMessage = (telemetryPager.messages.count > 0) ? telemetryPager.messages[0] : nil;
        XCTAssertEqual(telemetryPager.messages.count, [expectedJSON[@"messages"] count]);
        XCTAssertEqual(telemetryPager.remaining, [expectedJSON[@"meta"][@"pagination"][@"remaining"] unsignedLongValue]);
        [telemetryExpectation fulfill];
    } onFailure:^(NSError *error, NSHTTPURLResponse *response, NSString *bodyString) {
        XCTAssertTrue(NO);
        [telemetryExpectation fulfill];
    }];
    
    [self waitForExpectationsWithTimeout:[VLTestHelper defaultTimeOut] handler:nil];
}

- (void)testGetLocationsWithDeviceId {
    NSDictionary *expectedJSON = self.locations;
    
    XCTestExpectation *expectedLocations = [self expectationWithDescription:@"Getting locations"];
    [_vlService getLocationsForDeviceWithId:[VLTestHelper deviceId] onSuccess:^(VLLocationPager *locationPager, NSHTTPURLResponse *response) {
        XCTAssertEqual(locationPager.locations.count, [expectedJSON[@"locations"][@"features"] count]);
        XCTAssertEqual(locationPager.remaining, [expectedJSON[@"meta"][@"pagination"][@"remaining"] unsignedLongValue]);
        XCTAssertEqual([((VLLocation *)[locationPager.locations objectAtIndex:0]) latitude], [expectedJSON[@"locations"][@"features"][0][@"geometry"][@"coordinates"][1] doubleValue]);
        [expectedLocations fulfill];
    } onFailure:^(NSError *error, NSHTTPURLResponse *response, NSString *bodyString) {
        XCTAssertTrue(NO);
        [expectedLocations fulfill];
    }];
    
    [self waitForExpectationsWithTimeout:[VLTestHelper defaultTimeOut] handler:nil];
}

- (void)testGetTelemetryMessageWithId {
    NSDictionary *expectedJSON = self.telemetryMessage;
    
    XCTestExpectation *specificMessageExpectation = [self expectationWithDescription:@"service call for a single telemetry message"];
    [_vlService getTelemetryMessageWithId:self.messageId onSuccess:^(VLTelemetryMessage *telemetryMessage, NSHTTPURLResponse *response) {
        XCTAssertTrue([telemetryMessage.messageId isEqualToString:expectedJSON[@"message"][@"id"]]);
        XCTAssertEqual(telemetryMessage.latitude, [expectedJSON[@"message"][@"data"][@"location"][@"coordinates"][1]doubleValue ]);
        [specificMessageExpectation fulfill];
    } onFailure:^(NSError *error, NSHTTPURLResponse *response, NSString *bodyString) {
        XCTAssertTrue(NO);
        [specificMessageExpectation fulfill];
    }];
    
    [self waitForExpectationsWithTimeout:[VLTestHelper defaultTimeOut] handler:nil];
}

@end
