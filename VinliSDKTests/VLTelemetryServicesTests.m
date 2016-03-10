//
//  VLTelemetryServicesTests.m
//  VinliSDK
//
//  Created by Josh Beridon on 5/26/15.
//  Copyright (c) 2015 Vinli. All rights reserved.
//


//TBD remove
#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>
#import <OCMock/OCMock.h>
#import "VLService.h"
#import "VLTestHelper.h"

@interface VLTelemetryServicesTests : XCTestCase{
    VLService *service;
    NSString *deviceId;
    NSString *messageId;
}

@end


@implementation VLTelemetryServicesTests

- (void)setUp {
    [super setUp];
    service = [[VLService alloc] init];
    [service useSession:[[VLSession alloc] initWithAccessToken:@"TEST"]];
    deviceId = @"11111111-2222-3333-4444-555555555555";
    messageId = @"11111111-2222-3333-4444-555555555555";
}

- (void)tearDown {
    [super tearDown];
}

- (void) testGetSnapshotsForDevice{
    
    // TODO fix this method, expected JSON is currently wrong.
    
    id mockConnection = OCMPartialMock(service);
    
    NSDictionary *expectedJSON = [VLTestHelper getSnapshotsJSON:deviceId];
    
    [[[mockConnection expect] andDo:^(NSInvocation *invocation) {
        
        NSDictionary *message = [expectedJSON copy];
        
        NSHTTPURLResponse *response = [[NSHTTPURLResponse alloc] initWithURL:[NSURL new] statusCode:200 HTTPVersion:nil headerFields:nil];
        
        void (^successBlock)(NSDictionary *result, NSHTTPURLResponse *response) = nil;
        
        [invocation getArgument:&successBlock atIndex:8];
        
        successBlock(message, response);
        
    }] startWithHost:[OCMArg any] path:[OCMArg any] queries:[OCMArg any] HTTPMethod:[OCMArg any] parameters:[OCMArg any] token:[OCMArg any] onSuccess:[OCMArg any] onFailure:[OCMArg any]];
    
    [service getSnapshotsForDeviceWithId:deviceId fields:@"rpm" onSuccess:^(VLSnapshotPager *snapshotPager, NSHTTPURLResponse *response) {
        
        XCTAssertEqual(snapshotPager.snapshots.count, [expectedJSON[@"snapshots"] count]); // Make sure that there are three objects in the array.
        
        XCTAssertEqual(snapshotPager.remaining, [expectedJSON[@"meta"][@"pagination"][@"remaining"] unsignedLongValue]); // Make sure that the Meta more or less translated correctly.
        
    } onFailure:^(NSError *error, NSHTTPURLResponse *response, NSString *bodyString) {
        XCTAssertTrue(NO);
    }];
}

- (void) testGetTelemetryMessageWithId{
    id mockConnection = OCMPartialMock(service);
    
    NSDictionary *expectedJSON = [VLTestHelper getSpecificMessageJSON];
    
    [[[mockConnection expect] andDo:^(NSInvocation *invocation) {
        
        NSDictionary *message = [expectedJSON copy];
        NSHTTPURLResponse *response = [[NSHTTPURLResponse alloc] initWithURL:[NSURL new] statusCode:200 HTTPVersion:nil headerFields:nil];
        void (^successBlock)(NSDictionary *result, NSHTTPURLResponse *response) = nil;
        [invocation getArgument:&successBlock atIndex:8];
        successBlock(message, response);
    }] startWithHost:[OCMArg any] path:[OCMArg any] queries:[OCMArg any] HTTPMethod:[OCMArg any] parameters:[OCMArg any] token:[OCMArg any] onSuccess:[OCMArg any] onFailure:[OCMArg any]];
    
    [service getTelemetryMessageWithId:messageId onSuccess:^(VLTelemetryMessage *telemetryMessage, NSHTTPURLResponse *response)  {
        
        XCTAssertEqual(telemetryMessage.messageId, expectedJSON[@"message"][@"id"] );
        
        XCTAssertEqual(telemetryMessage.latitude, [expectedJSON[@"message"][@"location"][@"coordinates"][0]unsignedLongValue ]);
        
    } onFailure:^(NSError *error, NSHTTPURLResponse *response, NSString *bodyString) {
        XCTAssertTrue(NO);
    }];
}
- (void) testGetAllTelemetryMessagesForDeviceWithId{
    id mockConnection = OCMPartialMock(service);
    
    NSDictionary *expectedJSON = [VLTestHelper getMessagesJSON];
    
    [[[mockConnection expect] andDo:^(NSInvocation *invocation) {
        
        NSDictionary *message = [expectedJSON copy];
        NSHTTPURLResponse *response = [[NSHTTPURLResponse alloc] initWithURL:[NSURL new] statusCode:200 HTTPVersion:nil headerFields:nil];
        void (^successBlock)(NSDictionary *result, NSHTTPURLResponse *response) = nil;
        [invocation getArgument:&successBlock atIndex:8];
        successBlock(message, response);
    }] startWithHost:[OCMArg any] path:[OCMArg any] queries:[OCMArg any] HTTPMethod:[OCMArg any] parameters:[OCMArg any] token:[OCMArg any] onSuccess:[OCMArg any] onFailure:[OCMArg any]];
    
    [service getTelemetryMessagesForDeviceWithId:messageId onSuccess:^(VLTelemetryMessagePager *telemetryPager, NSHTTPURLResponse *response)  {
        
        XCTAssertEqual(telemetryPager.messages.count, [expectedJSON[@"messages"] count]); // Make sure that there are three objects in the array.
        
        XCTAssertEqual(telemetryPager.remaining, [expectedJSON[@"meta"][@"pagination"][@"remaining"] unsignedLongValue]); // Make sure that the Meta more or less translated correctly.
        
    } onFailure:^(NSError *error, NSHTTPURLResponse *response, NSString *bodyString) {
        XCTAssertTrue(NO);
    }];
}
- (void) testGetLocationsForDevice{
    id mockConnection = OCMPartialMock(service);
    
    NSDictionary *expectedJSON = [VLTestHelper getLocationsJSON];
    
    [[[mockConnection expect] andDo:^(NSInvocation *invocation) {
        
        NSDictionary *location = [expectedJSON copy];
        
        NSHTTPURLResponse *response = [[NSHTTPURLResponse alloc] initWithURL:[NSURL new] statusCode:200 HTTPVersion:nil headerFields:nil];
        
        void (^successBlock)(NSDictionary *result, NSHTTPURLResponse *response) = nil;
        
        [invocation getArgument:&successBlock atIndex:8];
        
        successBlock(location, response);
        
    }] startWithHost:[OCMArg any] path:[OCMArg any] queries:[OCMArg any] HTTPMethod:[OCMArg any] parameters:[OCMArg any] token:[OCMArg any] onSuccess:[OCMArg any] onFailure:[OCMArg any]];
    
    [service getLocationsForDeviceWithId:deviceId onSuccess:^(VLLocationPager *locationPager, NSHTTPURLResponse *response) {
        
        XCTAssertEqual(locationPager.locations.count, [expectedJSON[@"locations"] count]); // Make sure that there are three objects in the array.
        
        XCTAssertEqual(locationPager.remaining, [expectedJSON[@"meta"][@"pagination"][@"remaining"] unsignedLongValue]); // Make sure that the Meta more or less translated correctly.
        
        XCTAssertEqual([locationPager.locations[0] latitude], [expectedJSON[@"locations"][@"features"][0][@"geometry"][@"coordinates"][1] doubleValue]);
        
    } onFailure:^(NSError *error, NSHTTPURLResponse *response, NSString *bodyString) {
        XCTAssertTrue(NO);
    }];
}

@end
