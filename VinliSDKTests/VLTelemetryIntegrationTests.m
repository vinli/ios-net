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

- (void)setUp {
    [super setUp];

    self.vlService = [VLTestHelper vlService];
}

- (void)tearDown {
    [super tearDown];
}

- (void)testGetSnapshotsWithDeviceId {
   if(![VLTestHelper deviceId]){
        XCTAssertTrue(NO);
        return;
    }
    
    XCTestExpectation *snapshotExpectation = [self expectationWithDescription:@"Get snapshots"];
    [_vlService getSnapshotsForDeviceWithId:[VLTestHelper deviceId] fields:@"vehicleSpeed" onSuccess:^(VLSnapshotPager *snapshotPager, NSHTTPURLResponse *response) {
        XCTAssertTrue(snapshotPager.snapshots.count > 0);
        XCTAssertTrue(snapshotPager.since != nil && [snapshotPager.since isKindOfClass:[NSString class]] && snapshotPager.since.length > 0);
        XCTAssertTrue(snapshotPager.until != nil && [snapshotPager.until isKindOfClass:[NSString class]] && snapshotPager.until.length > 0);
        
        for(VLSnapshot *snapshot in snapshotPager.snapshots){
            XCTAssertTrue(snapshot.data != nil && [snapshot.data isKindOfClass:[NSDictionary class]] && snapshot.data.allKeys.count > 0);
        }
        [snapshotExpectation fulfill];
    } onFailure:^(NSError *error, NSHTTPURLResponse *response, NSString *bodyString) {
        XCTAssertTrue(NO);
        [snapshotExpectation fulfill];
    }];
   
    [self waitForExpectationsWithTimeout:[VLTestHelper defaultTimeOut] handler:nil];
}

- (void)testGetTelemetryMessageWithDeviceId {
    if(![VLTestHelper deviceId]){
        XCTAssertTrue(NO);
        return;
    }
    
    XCTestExpectation *telemetryExpectation = [self expectationWithDescription:@"telemetry messages"];
    [_vlService getTelemetryMessagesForDeviceWithId:[VLTestHelper deviceId] onSuccess:^(VLTelemetryMessagePager *telemetryPager, NSHTTPURLResponse *response) {
        XCTAssertTrue(telemetryPager.messages.count > 0);
        XCTAssertTrue(telemetryPager.since != nil && [telemetryPager.since isKindOfClass:[NSString class]] && telemetryPager.since.length > 0);
        XCTAssertTrue(telemetryPager.until != nil && [telemetryPager.until isKindOfClass:[NSString class]] && telemetryPager.until.length > 0);
        
        for(VLTelemetryMessage *message in telemetryPager.messages){
            XCTAssertTrue(message.messageId != nil && [message.messageId isKindOfClass:[NSString class]] && message.messageId.length > 0);
            XCTAssertTrue(message.timestamp != nil && [message.timestamp isKindOfClass:[NSString class]] && message.timestamp.length > 0);
            XCTAssertTrue(message.data != nil && [message.data isKindOfClass:[NSDictionary class]]);
        }
        [telemetryExpectation fulfill];
    } onFailure:^(NSError *error, NSHTTPURLResponse *response, NSString *bodyString) {
        XCTAssertTrue(NO);
        [telemetryExpectation fulfill];
    }];
    
    [self waitForExpectationsWithTimeout:[VLTestHelper defaultTimeOut] handler:nil];
}

- (void)testGetLocationsWithDeviceId {
    if(![VLTestHelper deviceId]){
        XCTAssertTrue(NO);
        return;
    }
    
    XCTestExpectation *expectedLocations = [self expectationWithDescription:@"Getting locations"];
    [_vlService getLocationsForDeviceWithId:[VLTestHelper deviceId] onSuccess:^(VLLocationPager *locationPager, NSHTTPURLResponse *response) {
        XCTAssertTrue(locationPager.locations.count > 0);
        XCTAssertTrue(locationPager.since != nil && [locationPager.since isKindOfClass:[NSString class]] && locationPager.since.length > 0);
        XCTAssertTrue(locationPager.until != nil && [locationPager.until isKindOfClass:[NSString class]] && locationPager.until.length > 0);
        
        for(VLLocation *location in locationPager.locations){
            XCTAssertTrue(fabs(location.latitude) <= 180.0);
            XCTAssertTrue(fabs(location.longitude) <= 180.0);
        }
        [expectedLocations fulfill];
    } onFailure:^(NSError *error, NSHTTPURLResponse *response, NSString *bodyString) {
        XCTAssertTrue(NO);
        [expectedLocations fulfill];
    }];
    
    [self waitForExpectationsWithTimeout:[VLTestHelper defaultTimeOut] handler:nil];
}

- (void)testGetTelemetryMessageWithId {
    if(![VLTestHelper telemetryMessageId]){
        XCTAssertTrue(NO);
        return;
    }
    
    XCTestExpectation *specificMessageExpectation = [self expectationWithDescription:@"service call for a single telemetry message"];
    [_vlService getTelemetryMessageWithId:[VLTestHelper telemetryMessageId] onSuccess:^(VLTelemetryMessage *message, NSHTTPURLResponse *response) {
        XCTAssertTrue(message.messageId != nil && [message.messageId isKindOfClass:[NSString class]] && message.messageId.length > 0);
        XCTAssertTrue(message.timestamp != nil && [message.timestamp isKindOfClass:[NSString class]] && message.timestamp.length > 0);
        XCTAssertTrue(message.data != nil && [message.data isKindOfClass:[NSDictionary class]]);
        [specificMessageExpectation fulfill];
    } onFailure:^(NSError *error, NSHTTPURLResponse *response, NSString *bodyString) {
        XCTAssertTrue(NO);
        [specificMessageExpectation fulfill];
    }];
    
    [self waitForExpectationsWithTimeout:[VLTestHelper defaultTimeOut] handler:nil];
}

@end
