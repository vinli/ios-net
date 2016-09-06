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

@end
