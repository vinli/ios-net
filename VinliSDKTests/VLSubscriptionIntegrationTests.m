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

- (void)testGetSubscriptionsWithDeviceId {
    if(![VLTestHelper deviceId]){
        XCTAssertTrue(NO);
        return;
    }
    
    XCTestExpectation *expectedDevices = [self expectationWithDescription:@"getting the subscriptions"];
    [_vlService getSubscriptionsForDeviceWithId:[VLTestHelper deviceId] onSuccess:^(VLSubscriptionPager *subscriptionPager, NSHTTPURLResponse *response) {
        XCTAssertTrue(subscriptionPager.subscriptions.count > 0);
        XCTAssertTrue(subscriptionPager.total > 0);
        
        for(VLSubscription *subscription in subscriptionPager.subscriptions){
            XCTAssertTrue(subscription.eventType != nil && [subscription.eventType isKindOfClass:[NSString class]] && subscription.eventType.length > 0);
            XCTAssertTrue(subscription.subscriptionId != nil && [subscription.subscriptionId isKindOfClass:[NSString class]] && subscription.subscriptionId.length > 0);
            XCTAssertTrue(subscription.url != nil && [subscription.url isKindOfClass:[NSURL class]] && subscription.url.absoluteString.length > 0);
        }
        [expectedDevices fulfill];
    } onFailure:^(NSError *error, NSHTTPURLResponse *response, NSString *bodyString) {
        XCTAssertTrue(NO);
        [expectedDevices fulfill];
    }];
    
    [self waitForExpectationsWithTimeout:[VLTestHelper defaultTimeOut] handler:nil];
}

- (void)testGetSubscriptionWithId {
    if(![VLTestHelper subscriptionId]){
        XCTAssertTrue(NO);
        return;
    }
    
    XCTestExpectation *subscriptionExpectation = [self expectationWithDescription:@"service call for a subscription"];
    [_vlService getSubscriptionWithId:[VLTestHelper subscriptionId] onSuccess:^(VLSubscription *subscription, NSHTTPURLResponse *response) {
        XCTAssertTrue(subscription.eventType != nil && [subscription.eventType isKindOfClass:[NSString class]] && subscription.eventType.length > 0);
        XCTAssertTrue(subscription.subscriptionId != nil && [subscription.subscriptionId isKindOfClass:[NSString class]] && subscription.subscriptionId.length > 0);
        XCTAssertTrue(subscription.url != nil && [subscription.url isKindOfClass:[NSURL class]] && subscription.url.absoluteString.length > 0);
        [subscriptionExpectation fulfill];
    } onFailure:^(NSError *error, NSHTTPURLResponse *response, NSString *bodyString) {
        XCTAssertTrue(NO);
        [subscriptionExpectation fulfill];
    }];
    
    [self waitForExpectationsWithTimeout:[VLTestHelper defaultTimeOut] handler:nil];
}

#pragma mark - Vehicularization

- (void)testGetSubscriptionsWithVehicleId {
    if (![VLTestHelper vehicleId]) {
        XCTAssertTrue(NO);
        return;
    }
    
    XCTestExpectation *expectation = [self expectationWithDescription:[NSString stringWithFormat:@"Vehicularization: Get subscriptions for vehicle with id: %@", [VLTestHelper vehicleId]]];
    [self.vlService getSubscriptionsForVehicleWithId:[VLTestHelper vehicleId] onSuccess:^(VLSubscriptionPager *subscriptionPager, NSHTTPURLResponse *response) {
        XCTAssertNotNil(subscriptionPager);
        XCTAssertNotNil(subscriptionPager.subscriptions);
        XCTAssertTrue(subscriptionPager.subscriptions.count > 0);
        [expectation fulfill];
    } onFailure:^(NSError *error, NSHTTPURLResponse *response, NSString *bodyString) {
        XCTAssertTrue(NO);
        [expectation fulfill];
    }];
    
    [self waitForExpectationsWithTimeout:[VLTestHelper defaultTimeOut] handler:nil];
}

- (void)testCreateSubscriptionWithVehicleId {
    if (![VLTestHelper vehicleId]) {
        XCTAssertTrue(NO);
        return;
    }
    
    VLSubscription* subscription = [[VLSubscription alloc] initWithEventType:@"startup" url:[NSURL URLWithString:@"http://www.google.com"] appData:nil objectRef:nil];
    
    XCTestExpectation *expectation = [self expectationWithDescription:[NSString stringWithFormat:@"Vehicularization: Get subscriptions for vehicle with id: %@", [VLTestHelper vehicleId]]];
    
    [self.vlService createSubscription:subscription forVehicle:[VLTestHelper vehicleId] onSuccess:^(VLSubscription *newSubscription, NSHTTPURLResponse *response) {
        XCTAssertNotNil(newSubscription);
        XCTAssertEqualObjects(newSubscription.eventType, subscription.eventType);
        XCTAssertEqualObjects(newSubscription.vehicleId, [VLTestHelper vehicleId]);
        XCTAssertEqualObjects(newSubscription.url, subscription.url);
        
        [self.vlService deleteSubscriptionWithId:newSubscription.subscriptionId onSuccess:^(NSHTTPURLResponse *response) {
            [expectation fulfill];
        } onFailure:^(NSError *error, NSHTTPURLResponse *response, NSString *bodyString) {
            [expectation fulfill];
        }];
        
    } onFailure:^(NSError *error, NSHTTPURLResponse *response, NSString *body) {
        XCTAssertTrue(NO);
        [expectation fulfill];
    }];
    
    [self waitForExpectationsWithTimeout:[VLTestHelper defaultTimeOut] handler:nil];
}


@end
