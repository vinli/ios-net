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
    
    self.deviceId = @"ba89372f-74f4-43c8-a4fd-b8f24699426e";
    self.subscriptionId = @"979c2120-49cf-4fea-a6ed-10b0c70ace57";
    XCTestExpectation *expectation = [self expectationWithDescription:@"getting devices call"];
    [[VLSessionManager sharedManager].service startWithHost:[VLTestHelper accessToken] requestUri:@"https://platform.vin.li/api/v1/devices" onSuccess:^(NSDictionary *result, NSHTTPURLResponse *response) {
        [expectation fulfill];
        self.devices = result;
        XCTAssertTrue(YES);
    } onFailure:^(NSError *error, NSHTTPURLResponse *response, NSString *msg) {
        XCTAssertTrue(NO);
    } ];
    
    [self waitForExpectationsWithTimeout:[VLTestHelper defaultTimeOut] handler:nil];
    
    

    
    
    
    //TO DO:need to add test for creating subscription and subscription with id
    
    
    XCTestExpectation *expectationS = [self expectationWithDescription:@"get subscriptions for device call"];
    [[VLSessionManager sharedManager].service startWithHost:[VLTestHelper accessToken] requestUri:[NSString stringWithFormat:@"https://events.vin.li/api/v1/devices/%@/subscriptions", self.deviceId] onSuccess:^(NSDictionary *result, NSHTTPURLResponse *response) {
        [expectationS fulfill];
        self.subscriptions = result;
    } onFailure:^(NSError *error, NSHTTPURLResponse *response, NSString *msg) {
        XCTAssertTrue(NO);
    }];
    [self waitForExpectationsWithTimeout:[VLTestHelper defaultTimeOut] handler:nil];
    
    
    XCTestExpectation *expectationSubscription = [self expectationWithDescription:@"single subscription get"];
    [[VLSessionManager sharedManager].service startWithHost:[VLTestHelper accessToken] requestUri:[NSString stringWithFormat:@"https://events.vin.li/api/v1/subscriptions/%@", self.subscriptionId] onSuccess:^(NSDictionary *result, NSHTTPURLResponse *response) {
        [expectationSubscription fulfill];
        self.subscription = result;
    } onFailure:^(NSError *error, NSHTTPURLResponse *response, NSString *msg) {
        XCTAssertTrue(NO);
    }];
    [self waitForExpectationsWithTimeout:[VLTestHelper defaultTimeOut] handler:nil];


}


- (void)testGetSubscriptionswithDeviceId {
    NSDictionary *expectedJSON = self.subscriptions;
    XCTestExpectation *expectedDevices = [self expectationWithDescription:@"getting the subscriptions"];
    [[VLSessionManager sharedManager].service getSubscriptionsForDeviceWithId:self.deviceId onSuccess:^(VLSubscriptionPager *subscriptionPager, NSHTTPURLResponse *response) {
        [expectedDevices fulfill];
        XCTAssertEqual(subscriptionPager.subscriptions.count, [expectedJSON[@"subscriptions"] count]); // Make sure that there is one object in the array.
        
        XCTAssertEqual(subscriptionPager.total, [expectedJSON[@"meta"][@"pagination"][@"total"] unsignedLongValue]); // Make sure that the Meta more or less translated correctly.
        
        //add more tests ie specfic models
    } onFailure:^(NSError *error, NSHTTPURLResponse *response, NSString *bodyString) {
        XCTAssertTrue(NO);
    }];
    [self waitForExpectationsWithTimeout:[VLTestHelper defaultTimeOut] handler:nil];
}





- (void)testGetSubscriptionWithId {
    NSDictionary *expectedJSON = self.subscription;
    XCTestExpectation *subscriptionExpectation = [self expectationWithDescription:@"service call for a subscription"];
    [[VLSessionManager sharedManager].service getSubscriptionWithId:self.subscriptionId onSuccess:^(VLSubscription *subscription, NSHTTPURLResponse *response) {
        [subscriptionExpectation fulfill];
        
        XCTAssertEqualObjects(subscription.deviceId, expectedJSON[@"subscription"][@"deviceId"]);
        
        XCTAssertEqualObjects(subscription.selfURL.absoluteString, expectedJSON[@"subscription"][@"links"][@"self"]);
        
        XCTAssertEqualObjects(subscription.objectRef.objectId, expectedJSON[@"subscription"][@"object"][@"id"]);
        
    } onFailure:^(NSError *error, NSHTTPURLResponse *response, NSString *bodyString) {
        XCTAssertTrue(NO);
    }];
    [self waitForExpectationsWithTimeout:[VLTestHelper defaultTimeOut] handler:nil];
}


//add tests for delete post




- (void)tearDown {

    [super tearDown];
}






@end
