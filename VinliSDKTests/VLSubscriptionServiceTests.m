//
//  VLSubscriptionServiceTests.m
//  VinliSDK
//
//  Created by Josh Beridon on 5/27/15.
//  Copyright (c) 2015 Vinli. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>
#import <OCMock/OCMock.h>
#import "VLService.h"
#import "VLRule.h"
#import "VLTestHelper.h"

@interface VLSubscriptionServiceTests : XCTestCase{
    VLService *service;
    NSString *subscriptionId;
    NSString *deviceId;
}

@end

@implementation VLSubscriptionServiceTests

- (void)setUp {
    [super setUp];
     service = [[VLService alloc] init];
    [service useSession:[[VLSession alloc] initWithAccessToken:@"TEST"]];
    subscriptionId = @"11111111-2222-3333-4444-555555555555";
    deviceId = @"11111111-2222-3333-4444-555555555555";
}

- (void)tearDown {
    [super tearDown];
}

- (void) testCreateSubscriptionForDevice{
    id mockConnection = OCMPartialMock(service);
    
    NSDictionary *inputJSON = [VLTestHelper getCreateSubscriptionsJSON];
    
    [[[mockConnection expect] andDo:^(NSInvocation *invocation) {
        
        NSDictionary *subscription = [inputJSON copy];
        
        NSHTTPURLResponse *response = [[NSHTTPURLResponse alloc] initWithURL:[NSURL new] statusCode:201 HTTPVersion:nil headerFields:nil];
        
        void (^successBlock)(NSDictionary *result, NSHTTPURLResponse *response) = nil;
        
        [invocation getArgument:&successBlock atIndex:8];
        
        successBlock(subscription, response);
        
    }] startWithHost:[OCMArg any] path:[OCMArg any] queries:[OCMArg any] HTTPMethod:[OCMArg any] parameters:[OCMArg any] token:[OCMArg any] onSuccess:[OCMArg any] onFailure:[OCMArg any]];
    
    [service createSubscription:[[VLSubscription alloc] initWithDictionary:inputJSON] forDevice:deviceId onSuccess:^(VLSubscription *subscription, NSHTTPURLResponse *response) {
       
        XCTAssertEqual(subscription.deviceId, inputJSON[@"subscriptions"][@"deviceId"]);
        
        XCTAssertEqual(subscription.selfURL.absoluteString, inputJSON[@"subscriptions"][@"links"][@"selfURL"]);
        
        XCTAssertEqual(subscription.objectRef.objectId, inputJSON[@"subscriptions"][@"object"][@"ruleId"]);
        
    } onFailure:^(NSError *error, NSHTTPURLResponse *response, NSString *bodyString) {
        XCTAssertTrue(NO);
    }];
}

- (void) testGetSpecificSubscriptionWithId{
    id mockConnection = OCMPartialMock(service);
    
    NSDictionary *expectedJSON = [VLTestHelper getSpecificSubscriptionJSON:subscriptionId];
    
    [[[mockConnection expect] andDo:^(NSInvocation *invocation) {
        
        NSDictionary *subscription = [expectedJSON copy];
        
        NSHTTPURLResponse *response = [[NSHTTPURLResponse alloc] initWithURL:[NSURL new] statusCode:200 HTTPVersion:nil headerFields:nil];
        
        void (^successBlock)(NSDictionary *result, NSHTTPURLResponse *response) = nil;
        
        [invocation getArgument:&successBlock atIndex:8];
        
        successBlock(subscription, response);
        
    }] startWithHost:[OCMArg any] path:[OCMArg any] queries:[OCMArg any] HTTPMethod:[OCMArg any] parameters:[OCMArg any] token:[OCMArg any] onSuccess:[OCMArg any] onFailure:[OCMArg any]];
    [service getSubscriptionWithId:subscriptionId onSuccess:^(VLSubscription *subscription, NSHTTPURLResponse *response) {
        
        XCTAssertEqual(subscription.deviceId, expectedJSON[@"subscription"][@"deviceId"]);
        
        XCTAssertEqual(subscription.selfURL.absoluteString, expectedJSON[@"subscription"][@"links"][@"self"]);
        
        XCTAssertEqual(subscription.objectRef.objectId, expectedJSON[@"subscription"][@"object"][@"id"]);
        
    } onFailure:^(NSError *error, NSHTTPURLResponse *response, NSString *bodyString) {
        XCTAssertTrue(NO);
    }];
}

- (void) testGetAllSubscriptionsWithDeviceId{
    id mockConnection = OCMPartialMock(service);
    
    NSDictionary *expectedJSON = [VLTestHelper getAllSubscriptionsJSON:deviceId];
    
    [[[mockConnection expect] andDo:^(NSInvocation *invocation) {
        
        NSDictionary *subscriptionPager = [expectedJSON copy];
        
        NSHTTPURLResponse *response = [[NSHTTPURLResponse alloc] initWithURL:[NSURL new] statusCode:200 HTTPVersion:nil headerFields:nil];
        
        void (^successBlock)(NSDictionary *result, NSHTTPURLResponse *response) = nil;
        
        [invocation getArgument:&successBlock atIndex:8];
        
        successBlock(subscriptionPager, response);
        
    }] startWithHost:[OCMArg any] path:[OCMArg any] queries:[OCMArg any] HTTPMethod:[OCMArg any] parameters:[OCMArg any] token:[OCMArg any] onSuccess:[OCMArg any] onFailure:[OCMArg any]];
    [service getSubscriptionsForDeviceWithId:deviceId onSuccess:^(VLSubscriptionPager *subscriptionPager, NSHTTPURLResponse *response) {

        XCTAssertEqual(subscriptionPager.subscriptions.count, [expectedJSON[@"subscriptions"] count]); // Make sure that there is one object in the array.
        
        XCTAssertEqual(subscriptionPager.total, [expectedJSON[@"meta"][@"pagination"][@"total"] unsignedLongValue]); // Make sure that the Meta more or less translated correctly.

        XCTAssertEqual([[[subscriptionPager.subscriptions objectAtIndex:0] objectRef] objectId],expectedJSON[@"subscriptions"][0][@"object"][@"id"]);
        
    } onFailure:^(NSError *error, NSHTTPURLResponse *response, NSString *bodyString) {
        XCTAssertTrue(NO);
    }];
}
- (void) testDeleteSpecificSubscriptionWithId{
    id mockConnection = OCMPartialMock(service);
    
    [[[mockConnection expect] andDo:^(NSInvocation *invocation) {
        
        NSDictionary *subscription = nil;
        
        NSHTTPURLResponse *response = [[NSHTTPURLResponse alloc] initWithURL:[NSURL new] statusCode:204 HTTPVersion:nil headerFields:nil];
        
        void (^successBlock)(NSDictionary *result, NSHTTPURLResponse *response) = nil;
        
        [invocation getArgument:&successBlock atIndex:8];
        
        successBlock(subscription, response);
        
    }] startWithHost:[OCMArg any] path:[OCMArg any] queries:[OCMArg any] HTTPMethod:[OCMArg any] parameters:[OCMArg any] token:[OCMArg any] onSuccess:[OCMArg any] onFailure:[OCMArg any]];
    
    [service deleteSubscriptionWithId:subscriptionId onSuccess:^(NSHTTPURLResponse *response) {
        
        XCTAssertTrue(YES);
        
    } onFailure:^(NSError *error, NSHTTPURLResponse *response, NSString *bodyString) {
        XCTAssertTrue(NO);
    }];
}

@end
