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

@end

@implementation VLTelemetryIntegrationTests

//temporary test urls
- (void)setUp {
    [super setUp];

    self.vlService = [VLTestHelper vlService];
}

- (void)tearDown {
    [super tearDown];
}

- (void)testGetSnapshotsWithDeviceId {
   NSDictionary *expectedJSON = [VLTestHelper getSnapshotsJSON:@"2ad86caa-5a30-429e-80b8-80bc3da5efe6"];
    
    if(![VLTestHelper deviceId]){
        XCTAssertTrue(NO);
        return;
    }
    
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
    NSDictionary *expectedJSON = [VLTestHelper getMessagesJSON];
    
    if(![VLTestHelper deviceId]){
        XCTAssertTrue(NO);
        return;
    }
    
    XCTestExpectation *telemetryExpectation = [self expectationWithDescription:@"telemetry messages"];
    [_vlService getTelemetryMessagesForDeviceWithId:[VLTestHelper deviceId] onSuccess:^(VLTelemetryMessagePager *telemetryPager, NSHTTPURLResponse *response) {
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
    NSDictionary *expectedJSON = [VLTestHelper getLocationsJSON];
    
    if(![VLTestHelper deviceId]){
        XCTAssertTrue(NO);
        return;
    }
    
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
    NSDictionary *expectedJSON = [VLTestHelper getSpecificMessageJSON];
    
    if(![VLTestHelper telemetryMessageId]){
        XCTAssertTrue(NO);
        return;
    }
    
    XCTestExpectation *specificMessageExpectation = [self expectationWithDescription:@"service call for a single telemetry message"];
    [_vlService getTelemetryMessageWithId:[VLTestHelper telemetryMessageId] onSuccess:^(VLTelemetryMessage *telemetryMessage, NSHTTPURLResponse *response) {
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
