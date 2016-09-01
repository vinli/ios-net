//
//  VLSubscriptionIntegrationTests.m
//  VinliSDK
//
//  Created by Jai Ghanekar on 2/26/16.
//  Copyright © 2016 Vinli. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "VLSessionManager.h"
#import "VLService.h"
#import "VLDevice.h"
#import "VLTestHelper.h"

@interface VLSubscriptionIntegrationTests : XCTestCase

@property VLService *vlService;
@property NSDictionary *devices;
@property VLDevice *device;
@property NSDictionary *subscriptions;
@property NSString *deviceId;
@property NSString *subscriptionId;
@property NSDictionary *subscription;

@end

@implementation VLSubscriptionIntegrationTests

- (void)setUp {
    [super setUp];
    
    _vlService = [VLTestHelper vlService];
    self.deviceId = [VLTestHelper deviceId];
    self.subscriptionId = [VLTestHelper subscriptionId];
    
    XCTestExpectation *expectation = [self expectationWithDescription:@"getting devices call"];
    [_vlService startWithHost:[VLTestHelper accessToken] requestUri:@"https://platform.vin.li/api/v1/devices" onSuccess:^(NSDictionary *result, NSHTTPURLResponse *response) {
        self.devices = result;
        [expectation fulfill];
    } onFailure:^(NSError *error, NSHTTPURLResponse *response, NSString *msg) {
        XCTAssertTrue(NO);
        [expectation fulfill];
    } ];
    
    XCTestExpectation *expectationS = [self expectationWithDescription:@"get subscriptions for device call"];
    [_vlService startWithHost:[VLTestHelper accessToken] requestUri:[NSString stringWithFormat:@"https://events.vin.li/api/v1/devices/%@/subscriptions", self.deviceId] onSuccess:^(NSDictionary *result, NSHTTPURLResponse *response) {
        self.subscriptions = result;
        [expectationS fulfill];
    } onFailure:^(NSError *error, NSHTTPURLResponse *response, NSString *msg) {
        XCTAssertTrue(NO);
        [expectationS fulfill];
    }];
    
    XCTestExpectation *expectationSubscription = [self expectationWithDescription:@"single subscription get"];
    [_vlService startWithHost:[VLTestHelper accessToken] requestUri:[NSString stringWithFormat:@"https://events.vin.li/api/v1/subscriptions/%@", self.subscriptionId] onSuccess:^(NSDictionary *result, NSHTTPURLResponse *response) {
        self.subscription = result;
        [expectationSubscription fulfill];
    } onFailure:^(NSError *error, NSHTTPURLResponse *response, NSString *msg) {
        XCTAssertTrue(NO);
        [expectationSubscription fulfill];
    }];
    
    [self waitForExpectationsWithTimeout:[VLTestHelper defaultTimeOut] handler:nil];
}

- (void)tearDown {
    [super tearDown];
}

- (void)testGetSubscriptionswithDeviceId {
    NSDictionary *expectedJSON = self.subscriptions;
    
    XCTestExpectation *expectedDevices = [self expectationWithDescription:@"getting the subscriptions"];
    [_vlService getSubscriptionsForDeviceWithId:self.deviceId onSuccess:^(VLSubscriptionPager *subscriptionPager, NSHTTPURLResponse *response) {
        XCTAssertEqual(subscriptionPager.subscriptions.count, [expectedJSON[@"subscriptions"] count]); // Make sure that there is one object in the array.
        XCTAssertEqual(subscriptionPager.total, [expectedJSON[@"meta"][@"pagination"][@"total"] unsignedLongValue]); // Make sure that the Meta more or less translated correctly.
        [expectedDevices fulfill];
    } onFailure:^(NSError *error, NSHTTPURLResponse *response, NSString *bodyString) {
        XCTAssertTrue(NO);
        [expectedDevices fulfill];
    }];
    
    [self waitForExpectationsWithTimeout:[VLTestHelper defaultTimeOut] handler:nil];
}

- (void)testGetSubscriptionWithId {
    NSDictionary *expectedJSON = self.subscription;
    
    XCTestExpectation *subscriptionExpectation = [self expectationWithDescription:@"service call for a subscription"];
    [[VLSessionManager sharedManager].service getSubscriptionWithId:self.subscriptionId onSuccess:^(VLSubscription *subscription, NSHTTPURLResponse *response) {
        XCTAssertEqualObjects(subscription.deviceId, expectedJSON[@"subscription"][@"deviceId"]);
        XCTAssertEqualObjects(subscription.selfURL.absoluteString, expectedJSON[@"subscription"][@"links"][@"self"]);
        XCTAssertEqualObjects(subscription.objectRef.objectId, expectedJSON[@"subscription"][@"object"][@"id"]);
        [subscriptionExpectation fulfill];
    } onFailure:^(NSError *error, NSHTTPURLResponse *response, NSString *bodyString) {
        XCTAssertTrue(NO);
        [subscriptionExpectation fulfill];
    }];
    
    [self waitForExpectationsWithTimeout:[VLTestHelper defaultTimeOut] handler:nil];
}

@end
