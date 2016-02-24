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
#import "VLTelemetryMessage.h"

@interface VLTelemetryIntegrationTests : XCTestCase

@property NSString *accessToken;
@property NSDictionary *devices;
@property VLDevice *device;
@property NSDictionary *snapshots;
@property NSDictionary *telemetryMessages;
@property VLTelemetryMessage *testMessage;
@property NSDictionary *message;

@end

@implementation VLTelemetryIntegrationTests

//temporary test urls
- (void)setUp {
    [super setUp];
    self.accessToken = @"HbZ_1S2vdywJk72iuPofm816fRhmYgRhT0OTwpyQX0okmDElQ7J8p5W_sKNUr8iE";
    XCTestExpectation *expectation = [self expectationWithDescription:@"getting devices call"];
    [[VLSessionManager sharedManager].service startWithHost:self.accessToken requestUri:@"https://platform.vin.li/api/v1/devices" onSuccess:^(NSDictionary *result, NSHTTPURLResponse *response) {
        [expectation fulfill];
        self.devices = result;
        XCTAssertTrue(YES);
    } onFailure:^(NSError *error, NSHTTPURLResponse *response, NSString *msg) {
        XCTAssertTrue(NO);
    } ];
    
    [self waitForExpectationsWithTimeout:0.5 handler:nil];
    
    //expectation_s snapshots json
    XCTestExpectation *expectations = [self expectationWithDescription:@"get the snapshots"];
    [[VLSessionManager sharedManager].service startWithHost:self.accessToken requestUri:@"https://telemetry.vin.li/api/v1/devices/d47ef610-c7b9-44ac-9a41-39f9c6056de5/snapshots?fields=rpm" onSuccess:^(NSDictionary *result, NSHTTPURLResponse *response) {
        [expectations fulfill];
        self.snapshots = result;
    } onFailure:^(NSError *error, NSHTTPURLResponse *response, NSString *msg) {
        XCTAssertTrue(NO);
    }];
    
    [self waitForExpectationsWithTimeout:0.5 handler:nil];
    
    
    XCTestExpectation *expectationT = [self expectationWithDescription:@"telemetry json"];
    [[VLSessionManager sharedManager].service startWithHost:self.accessToken requestUri:@"https://telemetry.vin.li/api/v1/devices/d47ef610-c7b9-44ac-9a41-39f9c6056de5/messages" onSuccess:^(NSDictionary *result, NSHTTPURLResponse *response) {
        [expectationT fulfill];
        self.telemetryMessages = result;
        XCTAssertTrue(YES);
    } onFailure:^(NSError *error, NSHTTPURLResponse *response, NSString *msg) {
        XCTAssertTrue(NO);
    }];
    
    XCTestExpectation *expectationM = [self expectationWithDescription:@"message expectation"];
    [[VLSessionManager sharedManager].service startWithHost:self.accessToken requestUri:@"URL: https://telemetry.vin.li/api/v1/messages/c6101486-cf48-4da9-84b8-87ca14a926e8" onSuccess:^(NSDictionary *result, NSHTTPURLResponse *response) {
        [expectationM fulfill];
        self.message = result;
        XCTAssertTrue(YES);
    } onFailure:^(NSError *error, NSHTTPURLResponse *response, NSString *msg) {
        XCTAssertTrue(NO);
    }];
    [self waitForExpectationsWithTimeout:0.5 handler:nil];
    
    
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
    
    [self waitForExpectationsWithTimeout:0.5 handler:nil];
    
    
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
   
    [self waitForExpectationsWithTimeout:0.5 handler:nil];
    
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
    [self waitForExpectationsWithTimeout:0.5 handler:nil];
    
    
}

- (void)testGetTelemetryMessageWithMessageId {
    NSDictionary *expectedJSON = self.message; //this is the message we pulled
    XCTestExpectation *telemetryMessageExpectation = [self expectationWithDescription:@"single telemetry message"];
    [[VLSessionManager sharedManager].service getTelemetryMessageWithId:self.testMessage.messageId onSuccess:^(VLTelemetryMessage *telemetryMessage, NSHTTPURLResponse *response) {
        [telemetryMessageExpectation fulfill];
        
        XCTAssertEqual(telemetryMessage.messageId, expectedJSON[@"message"][@"id"] );
        
        XCTAssertEqual(telemetryMessage.latitude, [expectedJSON[@"message"][@"location"][@"coordinates"][0]unsignedLongValue ]);

    } onFailure:^(NSError *error, NSHTTPURLResponse *response, NSString *bodyString) {
        XCTAssertTrue(NO);
    }];
    [self waitForExpectationsWithTimeout:0.5 handler:nil];
}

//get locations test




@end
