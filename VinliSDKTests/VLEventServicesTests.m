//
//  VLEventServicesTests.m
//  VinliSDK
//
//  Created by Josh Beridon on 5/27/15.
//  Copyright (c) 2015 Vinli. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>
#import <OCMock/OCMock.h>
#import "VLService.h"
#import "VLTestHelper.h"

@interface VLEventServicesTests : XCTestCase{
    VLService *connection;
    NSString *eventId;
    NSString *deviceId;
    NSString *subscriptionId;
    NSString *notificationId;
}
@end

@implementation VLEventServicesTests

- (void)setUp {
    [super setUp];
    connection = [[VLService alloc] init];
    [connection useSession:[[VLSession alloc] initWithAccessToken:@"TEST"]];
    eventId = @"11111111-2222-3333-4444-555555555555";
    deviceId = @"11111111-2222-3333-4444-555555555555";
    subscriptionId = @"11111111-2222-3333-4444-555555555555";
    notificationId= @"11111111-2222-3333-4444-555555555555";
}

- (void)tearDown {
    [super tearDown];
}

- (void)testGetAllEventsForDeviceWithId{
    id mockConnection = OCMPartialMock(connection);
    
    NSDictionary *expectedJSON = [VLTestHelper getAllEventsJSON:deviceId];
    
    [[[mockConnection expect] andDo:^(NSInvocation *invocation) {
        NSDictionary *event = [expectedJSON copy];
        NSHTTPURLResponse *response = [[NSHTTPURLResponse alloc] initWithURL:[NSURL new] statusCode:200 HTTPVersion:nil headerFields:nil];
        
        void (^successBlock)(NSDictionary *result, NSHTTPURLResponse *response) = nil;
        [invocation getArgument:&successBlock atIndex:8];
        successBlock(event, response);
        
    }] startWithHost:[OCMArg any] path:[OCMArg any] queries:[OCMArg any] HTTPMethod:[OCMArg any] parameters:[OCMArg any] token:[OCMArg any] onSuccess:[OCMArg any] onFailure:[OCMArg any]];
    
    [connection getEventsForDeviceWithId:deviceId eventType:nil onSuccess:^(VLEventPager *eventPager, NSHTTPURLResponse *response) {
        
        XCTAssertEqual(eventPager.events.count, [expectedJSON[@"events"] count]); // Make sure that there are two objects in the array.
        XCTAssertEqual(eventPager.until, expectedJSON[@"meta"][@"pagination"][@"until"]); // Make sure that the Meta more or less translated correctly.
        XCTAssertEqual(((VLEvent*)[eventPager.events objectAtIndex:0]).eventId, expectedJSON[@"events"][0][@"id"]); // Make sure that the events array more or less translated correctly
        
        
    } onFailure:^(NSError *error, NSHTTPURLResponse *response, NSString *bodyString) {
        XCTAssertTrue(NO);
    }];
}

- (void)testGetAllEventsForDeviceWithIdAndEventType
{
    id mockConnection = OCMPartialMock(connection);
    
    NSDictionary *expectedJSON = [VLTestHelper getAllEventsJSON:deviceId];
    
    [[[mockConnection expect] andDo:^(NSInvocation *invocation) {
        NSDictionary *event = [expectedJSON copy];
        NSHTTPURLResponse *response = [[NSHTTPURLResponse alloc] initWithURL:[NSURL new] statusCode:200 HTTPVersion:nil headerFields:nil];
        
        void (^successBlock)(NSDictionary *result, NSHTTPURLResponse *response) = nil;
        [invocation getArgument:&successBlock atIndex:8];
        successBlock(event, response);
        
    }] startWithHost:[OCMArg any] path:[OCMArg any] queries:[OCMArg any] HTTPMethod:[OCMArg any] parameters:[OCMArg any] token:[OCMArg any] onSuccess:[OCMArg any] onFailure:[OCMArg any]];
    
    [connection getEventsForDeviceWithId:deviceId eventType:VLEventTypeRuleLeave onSuccess:^(VLEventPager *eventPager, NSHTTPURLResponse *response) {
        
        XCTAssertEqual(eventPager.events.count, [expectedJSON[@"events"] count]); // Make sure that there are two objects in the array.
        XCTAssertEqual(eventPager.until, expectedJSON[@"meta"][@"pagination"][@"until"]); // Make sure that the Meta more or less translated correctly.
        XCTAssertEqual(((VLEvent*)[eventPager.events objectAtIndex:0]).eventId, expectedJSON[@"events"][0][@"id"]); // Make sure that the events array more or less translated correctly
        XCTAssertEqual(((VLEvent*)[eventPager.events objectAtIndex:0]).eventType, expectedJSON[@"events"][0][@"eventType"]); // Make sure that the events array more or less translated correctly
        
    } onFailure:^(NSError *error, NSHTTPURLResponse *response, NSString *bodyString) {
        XCTAssertTrue(NO);
    }];
}

- (void)testGetAllNotificationsForSubscriptionWithId{
    id mockConnection = OCMPartialMock(connection);
    
    NSDictionary *expectedJSON = [VLTestHelper getAllEventsOrSubscriptionsNotificationsJSON:subscriptionId];
    
    [[[mockConnection expect] andDo:^(NSInvocation *invocation) {
        NSDictionary *event = [expectedJSON copy];
        NSHTTPURLResponse *response = [[NSHTTPURLResponse alloc] initWithURL:[NSURL new] statusCode:200 HTTPVersion:nil headerFields:nil];
        
        void (^successBlock)(NSDictionary *result, NSHTTPURLResponse *response) = nil;
        [invocation getArgument:&successBlock atIndex:8];
        successBlock(event, response);
        
    }] startWithHost:[OCMArg any] path:[OCMArg any] queries:[OCMArg any] HTTPMethod:[OCMArg any] parameters:[OCMArg any] token:[OCMArg any] onSuccess:[OCMArg any] onFailure:[OCMArg any]];
    
    [connection getNotificationsForSubscriptionWithId:subscriptionId onSuccess:^(VLNotificationPager *notificationPager, NSHTTPURLResponse *response) {
        
        XCTAssertEqual(notificationPager.notifications.count, [expectedJSON[@"notifications"] count]); // Make sure that there are two objects in the array.
        XCTAssertEqualObjects([notificationPager.priorURL absoluteString], expectedJSON[@"meta"][@"pagination"][@"links"][@"prior"]);
        XCTAssertEqualObjects([notificationPager.nextURL absoluteString], expectedJSON[@"meta"][@"pagination"][@"links"][@"next"]);
    } onFailure:^(NSError *error, NSHTTPURLResponse *response, NSString *bodyString) {
        XCTAssertTrue(NO);
    }];
}

- (void)testGetSpecificNotificationWithId{
    id mockConnection = OCMPartialMock(connection);
    
    NSDictionary *expectedJSON = [VLTestHelper getNotificationJSON:notificationId];
    
    [[[mockConnection expect] andDo:^(NSInvocation *invocation) {
        
        NSDictionary *notification = [expectedJSON copy];
        
        NSHTTPURLResponse *response = [[NSHTTPURLResponse alloc] initWithURL:[NSURL new] statusCode:200 HTTPVersion:nil headerFields:nil];
        
        void (^successBlock)(NSDictionary *result, NSHTTPURLResponse *response) = nil;
        
        [invocation getArgument:&successBlock atIndex:8];
        
        successBlock(notification, response);
        
    }] startWithHost:[OCMArg any] path:[OCMArg any] queries:[OCMArg any] HTTPMethod:[OCMArg any] parameters:[OCMArg any] token:[OCMArg any] onSuccess:[OCMArg any] onFailure:[OCMArg any]];
    
    [connection getNotificationWithId:notificationId onSuccess:^(VLNotification *notification, NSHTTPURLResponse *response) {
        
        //just make sure that trip got created, and is not empty.
        XCTAssert(notification != nil);
        XCTAssert(notification.notificationId != nil);
        
    } onFailure:^(NSError *error, NSHTTPURLResponse *response, NSString *bodyString) {
        XCTAssert(NO);
    }];
}

@end
