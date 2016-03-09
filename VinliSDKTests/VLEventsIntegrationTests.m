//
//  VLEventsIntegrationTests.m
//  VinliSDK
//
//  Created by Jai Ghanekar on 2/26/16.
//  Copyright © 2016 Vinli. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "VLSessionManager.h"
#import "VLService.h"
#import "VLDevice.h"
#import "VLEvent.h"
#import "VLTestHelper.h"


@interface VLEventsIntegrationTests : XCTestCase
@property NSDictionary *events;
@property NSDictionary *eventNotifications;
@property NSString *eventId;
@property NSString *subscriptionId;
@property NSDictionary *subscriptionNotificiations;
@property NSString *deviceId;
@property NSString *notificationId;
@property NSDictionary *notification;
@property NSDictionary *event;
@end

@implementation VLEventsIntegrationTests

- (void)setUp {
    [super setUp];
    
    self.notificationId = @"d5772824-c98f-44b5-9418-7e03974003a7";
    //call for the device's events
    XCTestExpectation *expectationE = [self expectationWithDescription:@"call for subscription with device id"];
    [[VLSessionManager sharedManager].service startWithHost:[VLTestHelper accessToken] requestUri:[NSString stringWithFormat:@"https://events.vin.li/api/v1/devices/%@/events",[VLTestHelper deviceId]] onSuccess:^(NSDictionary *result, NSHTTPURLResponse *response) {
        [expectationE fulfill];
        self.events = result;
        
    } onFailure:^(NSError *error, NSHTTPURLResponse *response, NSString *msg) {
        XCTAssertTrue(NO);
    }];
    [self waitForExpectationsWithTimeout:[VLTestHelper defaultTimeOut] handler:nil];
    

    //store event id
    self.eventId = @"44cdc7e9-5433-4e20-9957-09b8f1da1a7c";
    XCTestExpectation *expectationN = [self expectationWithDescription:@"call for notifications"];
    [[VLSessionManager sharedManager].service startWithHost:[VLTestHelper accessToken] requestUri:[NSString stringWithFormat:@"https://events.vin.li/api/v1/events/%@/notifications", self.eventId] onSuccess:^(NSDictionary *result, NSHTTPURLResponse *response) {
        [expectationN fulfill];
        self.eventNotifications = result;
        
    } onFailure:^(NSError *error, NSHTTPURLResponse *response, NSString *msg) {
        XCTAssertTrue(NO);
    }];
    
    [self waitForExpectationsWithTimeout:5.0 handler:nil];
    
    
    XCTestExpectation *expectationEvent = [self expectationWithDescription:@"raw json for single device"];
    [[VLSessionManager sharedManager].service startWithHost:[VLTestHelper accessToken] requestUri:[NSString stringWithFormat:@"https://events.vin.li/api/v1/events/%@", self.eventId] onSuccess:^(NSDictionary *result, NSHTTPURLResponse *response) {
        [expectationEvent fulfill];
        self.event = result;
        
    } onFailure:^(NSError *error, NSHTTPURLResponse *response, NSString *msg) {
        XCTAssertTrue(NO);
    }];
    [self waitForExpectationsWithTimeout:[VLTestHelper defaultTimeOut] handler:nil];
    
    
    self.subscriptionId = @"1d83f2cb-acc9-4a5f-9760-2ed3991d7380";
    XCTestExpectation *expectationForSubscription = [self expectationWithDescription:@"notifications with subscription id"];
    [[VLSessionManager sharedManager].service startWithHost:[VLTestHelper accessToken] requestUri:[NSString stringWithFormat:@"https://events.vin.li/api/v1/subscriptions/%@/notifications", self.subscriptionId] onSuccess:^(NSDictionary *result, NSHTTPURLResponse *response) {
        [expectationForSubscription fulfill];
        self.subscriptionNotificiations = result;
        
    } onFailure:^(NSError *error, NSHTTPURLResponse *response, NSString *msg) {
        XCTAssertTrue(NO);
    }];
    
    
    [self waitForExpectationsWithTimeout:[VLTestHelper defaultTimeOut] handler:nil];
    
    
    XCTestExpectation *expectingNotification = [self expectationWithDescription:@"single notification call"];
    [[VLSessionManager sharedManager].service startWithHost:[VLTestHelper accessToken] requestUri:[NSString stringWithFormat:@"https://events.vin.li/api/v1/notifications/%@", self.notificationId] onSuccess:^(NSDictionary *result, NSHTTPURLResponse *response) {
        [expectingNotification fulfill];
        self.notification = result;
        
    } onFailure:^(NSError *error, NSHTTPURLResponse *response, NSString *msg) {
        XCTAssertTrue(NO);
    }];
    [self waitForExpectationsWithTimeout:[VLTestHelper defaultTimeOut] handler:nil];
    
    
    
    
    
}

- (void)tearDown {
    [super tearDown];
}


- (void)testGetEventsWithDeviceId {
    NSDictionary *expectedJSON = self.events;
    XCTestExpectation *eventsExpectation = [self expectationWithDescription:@"Getting events"];
    
    [[VLSessionManager sharedManager].service getEventsForDeviceWithId:[VLTestHelper deviceId] onSuccess:^(VLEventPager *eventPager, NSHTTPURLResponse *response) {
        [eventsExpectation fulfill];
        XCTAssertEqual(eventPager.events.count, [expectedJSON[@"events"] count]);
        //XCTAssertEqualObjects(eventPager.until, expectedJSON[@"meta"][@"pagination"][@"until"]); testing times defer
        
        //check for object at 0 condition
        XCTAssertEqualObjects(((VLEvent*)[eventPager.events objectAtIndex:0]).eventId, expectedJSON[@"events"][0][@"id"]);
    } onFailure:^(NSError *error, NSHTTPURLResponse *response, NSString *bodyString) {
        XCTAssertTrue(NO);
    }];
    [self waitForExpectationsWithTimeout:[VLTestHelper defaultTimeOut] handler:nil];
    
}

- (void)testGetNotificationsWithEventId {
    NSDictionary *expectedJSON = self.eventNotifications;
    XCTestExpectation *eventNotificationExpectation = [self expectationWithDescription:@"All notifications for event"];
    [[VLSessionManager sharedManager].service getNotificationsForEventWithId:self.eventId onSuccess:^(VLNotificationPager *notificationPager, NSHTTPURLResponse *response) {
        [eventNotificationExpectation fulfill];
        XCTAssertEqual(notificationPager.notifications.count, [expectedJSON[@"notifications"] count]);
        XCTAssertEqual([notificationPager.priorURL  absoluteString], expectedJSON[@"meta"][@"pagination"][@"links"][@"prior"]);
        XCTAssertEqual([notificationPager.nextURL  absoluteString], expectedJSON[@"meta"][@"pagination"][@"links"][@"next"]);
    } onFailure:^(NSError *error, NSHTTPURLResponse *response, NSString *bodyString) {
        XCTAssertTrue(NO);
    }];
    [self waitForExpectationsWithTimeout:[VLTestHelper defaultTimeOut] handler:nil];
}

- (void)testGetNotificationsWithSubscriptionId {
    NSDictionary *expectedJSON = self.subscriptionNotificiations;
    XCTestExpectation *expectedNotificationsForSubscription = [self expectationWithDescription:@"notifications for subscription id"];
    [[VLSessionManager sharedManager].service getNotificationsForSubscriptionWithId:self.subscriptionId onSuccess:^(VLNotificationPager *notificationPager, NSHTTPURLResponse *response) {
        [expectedNotificationsForSubscription fulfill];
        XCTAssertEqual(notificationPager.notifications.count, [expectedJSON[@"notifications"] count]); // Make sure that there are two objects in the array.
        XCTAssertEqualObjects([notificationPager.priorURL absoluteString], expectedJSON[@"meta"][@"pagination"][@"links"][@"prior"]);
        XCTAssertEqualObjects([notificationPager.nextURL absoluteString], expectedJSON[@"meta"][@"pagination"][@"links"][@"next"]);
        
    } onFailure:^(NSError *error, NSHTTPURLResponse *response, NSString *bodyString) {
        XCTAssertTrue(NO);
    }];
    [self waitForExpectationsWithTimeout:[VLTestHelper defaultTimeOut] handler:nil];
}



- (void)testGetEventWithId {
    NSDictionary *expectedJSON = [VLTestHelper cleanDictionary:self.event[@"event"]]; //clear the null values
    XCTestExpectation *singleEventExpected = [self expectationWithDescription:@"service call for a single event"];
    [[VLSessionManager sharedManager].service getEventWithId:self.eventId onSuccess:^(VLEvent *event, NSHTTPURLResponse *response) {
        [singleEventExpected fulfill];
        //add assertions in here
        XCTAssertEqualObjects(event.eventId, expectedJSON[@"id"]);
        XCTAssertEqualObjects(event.timestamp, expectedJSON[@"timestamp"]);
        XCTAssertEqualObjects(event.deviceId, expectedJSON[@"deviceId"]);
        XCTAssertEqualObjects(event.stored, expectedJSON[@"stored"]);
        XCTAssertEqualObjects(event.eventType, expectedJSON[@"eventType"]);
        XCTAssertEqualObjects(event.objectId, expectedJSON[@"object"][@"id"]);
        XCTAssertEqualObjects(event.objectType, expectedJSON[@"object"][@"type"]);
        XCTAssertEqualObjects([event.selfURL absoluteString], expectedJSON[@"links"][@"self"]);
        XCTAssertEqualObjects([event.notificationsURL absoluteString], expectedJSON[@"links"][@"notifications"]);
        XCTAssertEqualObjects(event.vehicleId, expectedJSON[@"meta"][@"vehicleId"]);
        
    } onFailure:^(NSError *error, NSHTTPURLResponse *response, NSString *bodyString) {
        XCTAssertTrue(NO);
    }];
    [self waitForExpectationsWithTimeout:[VLTestHelper defaultTimeOut] handler:nil];
}



- (void)testGetNotificationWithId {
    NSMutableDictionary *expectedJSON = [VLTestHelper cleanDictionary:self.notification[@"notification"]];
    XCTestExpectation *expectingSingleNotification = [self expectationWithDescription:@"service call for single device"];
    [[VLSessionManager sharedManager].service getNotificationWithId:self.notificationId onSuccess:^(VLNotification *notification, NSHTTPURLResponse *response) {
        [expectingSingleNotification fulfill];
        XCTAssertEqualObjects(notification.notificationId, expectedJSON[@"id"]);
        XCTAssertEqualObjects(notification.eventId, expectedJSON[@"eventId"]);
        XCTAssertEqualObjects(notification.eventType, expectedJSON[@"eventType"]);
        XCTAssertEqualObjects(notification.eventTimestamp, expectedJSON[@"eventTimestamp"]);
        XCTAssertEqualObjects(notification.subscriptionId, expectedJSON[@"subscriptionId"]);
        XCTAssertEqual(notification.responseCode, [expectedJSON[@"reponseCode"] unsignedLongValue]);
        XCTAssertEqualObjects(notification.response, expectedJSON[@"response"]);
        XCTAssertEqualObjects([notification.url absoluteString], expectedJSON[@"url"]);
        XCTAssertEqualObjects(notification.payload, expectedJSON[@"payload"]);
        XCTAssertEqualObjects(notification.state, expectedJSON[@"state"]);
        XCTAssertEqualObjects(notification.notifiedAt, expectedJSON[@"notifiedAt"]);
        XCTAssertEqualObjects(notification.respondedAt, expectedJSON[@"respondedAt"]);
        XCTAssertEqualObjects(notification.createdAt, expectedJSON[@"createdAt"]);
        XCTAssertEqualObjects([notification.selfURL absoluteString], expectedJSON[@"links"][@"self"]);
        XCTAssertEqualObjects([notification.eventURL absoluteString], expectedJSON[@"links"][@"event"]);
        XCTAssertEqualObjects([notification.subscriptionURL absoluteString], expectedJSON[@"links"][@"subscription"]);
        
        
    } onFailure:^(NSError *error, NSHTTPURLResponse *response, NSString *bodyString) {
        XCTAssertTrue(NO);
    }];
    [self waitForExpectationsWithTimeout:[VLTestHelper defaultTimeOut] handler:nil];
}


@end
