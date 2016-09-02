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

@end

@implementation VLSubscriptionIntegrationTests

- (void)setUp {
    [super setUp];
    
    _vlService = [VLTestHelper vlService];
}

- (void)tearDown {
    [super tearDown];
}

- (void)testGetSubscriptionswithDeviceId {
    NSDictionary *expectedJSON = [VLTestHelper getAllSubscriptionsJSON:@"2ad86caa-5a30-429e-80b8-80bc3da5efe6"];
    
    if(![VLTestHelper deviceId]){
        XCTAssertTrue(NO);
        return;
    }
    
    XCTestExpectation *expectedDevices = [self expectationWithDescription:@"getting the subscriptions"];
    [_vlService getSubscriptionsForDeviceWithId:[VLTestHelper deviceId] onSuccess:^(VLSubscriptionPager *subscriptionPager, NSHTTPURLResponse *response) {
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
    NSDictionary *expectedJSON = [VLTestHelper getSpecificSubscriptionJSON:@"2ad86caa-5a30-429e-80b8-80bc3da5efe6"];
    
    if(![VLTestHelper subscriptionId]){
        XCTAssertTrue(NO);
        return;
    }
    
    XCTestExpectation *subscriptionExpectation = [self expectationWithDescription:@"service call for a subscription"];
    [_vlService getSubscriptionWithId:[VLTestHelper subscriptionId] onSuccess:^(VLSubscription *subscription, NSHTTPURLResponse *response) {
        XCTAssertEqualObjects(subscription.deviceId, expectedJSON[@"subscription"][@"deviceId"]);
        XCTAssertEqualObjects(subscription.selfURL.absoluteString, expectedJSON[@"subscription"][@"links"][@"self"]);
        [subscriptionExpectation fulfill];
    } onFailure:^(NSError *error, NSHTTPURLResponse *response, NSString *bodyString) {
        XCTAssertTrue(NO);
        [subscriptionExpectation fulfill];
    }];
    
    [self waitForExpectationsWithTimeout:[VLTestHelper defaultTimeOut] handler:nil];
}

@end
