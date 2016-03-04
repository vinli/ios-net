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


@interface VLEventsIntegrationTests : XCTestCase
@property NSString *accessToken;
@property NSDictionary *devices;
@property VLDevice *device;
@property NSDictionary *events;
@property NSDictionary *eventNotifications;
@property NSString *eventId;
@property NSString *subscriptionId;
@property NSDictionary *subscriptionNotificiations;
@property NSString *deviceId;
@property NSTimeInterval defaultTimeOut;
@property NSString *notificationId;
@property NSDictionary *notification;
@end

@implementation VLEventsIntegrationTests

- (void)setUp {
    [super setUp];
    
    self.defaultTimeOut = 5.0;
    self.notificationId = @"53b5c852-8be5-4b6b-bc18-ae1d5db0d364";
    self.accessToken = @"HbZ_1S2vdywJk72iuPofm816fRhmYgRhT0OTwpyQX0okmDElQ7J8p5W_sKNUr8iE";
    self.deviceId = @"ba89372f-74f4-43c8-a4fd-b8f24699426e";
    XCTestExpectation *expectation = [self expectationWithDescription:@"getting devices call"];
    
    
    [[VLSessionManager sharedManager].service startWithHost:self.accessToken requestUri:@"https://platform.vin.li/api/v1/devices" onSuccess:^(NSDictionary *result, NSHTTPURLResponse *response) {
        [expectation fulfill];
        self.devices = result;
        XCTAssertTrue(YES);
    } onFailure:^(NSError *error, NSHTTPURLResponse *response, NSString *msg) {
        XCTAssertTrue(NO);
    } ];
    
    [self waitForExpectationsWithTimeout:self.defaultTimeOut handler:nil];
    
    
    //this device id could be stored a string to skip making this call
    
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
    
    [self waitForExpectationsWithTimeout:self.defaultTimeOut handler:nil];

    
    //call for the device's events
    
    XCTestExpectation *expectationE = [self expectationWithDescription:@"call for subscription with device id"];
    [[VLSessionManager sharedManager].service startWithHost:self.accessToken requestUri:[NSString stringWithFormat:@"https://events.vin.li/api/v1/devices/%@/events",self.deviceId] onSuccess:^(NSDictionary *result, NSHTTPURLResponse *response) {
        [expectationE fulfill];
        self.events = result;
        XCTAssertTrue(YES);
    } onFailure:^(NSError *error, NSHTTPURLResponse *response, NSString *msg) {
        XCTAssertTrue(NO);
    }];
    [self waitForExpectationsWithTimeout:self.defaultTimeOut handler:nil];
    
    
    //store event id
    self.eventId = @"44cdc7e9-5433-4e20-9957-09b8f1da1a7c";
    XCTestExpectation *expectationN = [self expectationWithDescription:@"call for notifications"];
    [[VLSessionManager sharedManager].service startWithHost:self.accessToken requestUri:[NSString stringWithFormat:@"https://events.vin.li/api/v1/events/%@/notifications", self.eventId] onSuccess:^(NSDictionary *result, NSHTTPURLResponse *response) {
        [expectationN fulfill];
        self.eventNotifications = result;
        XCTAssertTrue(YES);
    } onFailure:^(NSError *error, NSHTTPURLResponse *response, NSString *msg) {
        XCTAssertTrue(NO);
    }];
    
    [self waitForExpectationsWithTimeout:5.0 handler:nil];
    
    self.subscriptionId = @"1d83f2cb-acc9-4a5f-9760-2ed3991d7380";
    XCTestExpectation *expectationForSubscription = [self expectationWithDescription:@"notifications with subscription id"];
    [[VLSessionManager sharedManager].service startWithHost:self.accessToken requestUri:[NSString stringWithFormat:@"https://events.vin.li/api/v1/subscriptions/%@/notifications", self.subscriptionId] onSuccess:^(NSDictionary *result, NSHTTPURLResponse *response) {
        [expectationForSubscription fulfill];
        self.subscriptionNotificiations = result;
        XCTAssertTrue(YES);
    } onFailure:^(NSError *error, NSHTTPURLResponse *response, NSString *msg) {
        XCTAssertTrue(NO);
    }];
    
    
    [self waitForExpectationsWithTimeout:self.defaultTimeOut handler:nil];
    
    
    XCTestExpectation *expectingNotification = [self expectationWithDescription:@"single notification call"];
    [[VLSessionManager sharedManager].service startWithHost:self.accessToken requestUri:[NSString stringWithFormat:@"https://events.vin.li/api/v1/notifications/%@", self.notificationId] onSuccess:^(NSDictionary *result, NSHTTPURLResponse *response) {
        [expectingNotification fulfill];
        self.notification = result;
        XCTAssertTrue(YES);
    } onFailure:^(NSError *error, NSHTTPURLResponse *response, NSString *msg) {
        XCTAssertTrue(NO);
    }];
    [self waitForExpectationsWithTimeout:self.defaultTimeOut handler:nil];
    
    
    
    
    
}

- (void)tearDown {
    [super tearDown];
}


- (void)testGetEventsWithDeviceId {
    NSDictionary *expectedJSON = self.events;
    XCTestExpectation *eventsExpectation = [self expectationWithDescription:@"Getting events"];
    
    [[VLSessionManager sharedManager].service getEventsForDeviceWithId:self.deviceId onSuccess:^(VLEventPager *eventPager, NSHTTPURLResponse *response) {
        [eventsExpectation fulfill];
        XCTAssertEqual(eventPager.events.count, [expectedJSON[@"events"] count]);
        //XCTAssertEqualObjects(eventPager.until, expectedJSON[@"meta"][@"pagination"][@"until"]); testing times defer
        XCTAssertEqualObjects(((VLEvent*)[eventPager.events objectAtIndex:0]).eventId, expectedJSON[@"events"][0][@"id"]);
    } onFailure:^(NSError *error, NSHTTPURLResponse *response, NSString *bodyString) {
        XCTAssertTrue(NO);
    }];
    [self waitForExpectationsWithTimeout:self.defaultTimeOut handler:nil];
    
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
    [self waitForExpectationsWithTimeout:self.defaultTimeOut handler:nil];
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
    [self waitForExpectationsWithTimeout:self.defaultTimeOut handler:nil];
}

//- (void)testGetNotificationWithId {
//    NSDictionary *expectedJSON = self.notification;
//    XCTestExpectation *expectingSingleNotification = [self expectationWithDescription:@"service call for single device"];
//    [[VLSessionManager sharedManager].service getNotificationWithId:self.notificationId onSuccess:^(VLNotification *event, NSHTTPURLResponse *response) {
//        [expectingSingleNotification fulfill];
//        XCTAssertTrue(YES);
//        
//    } onFailure:^(NSError *error, NSHTTPURLResponse *response, NSString *bodyString) {
//        XCTAssertTrue(NO);
//    }];
//    [self waitForExpectationsWithTimeout:self.defaultTimeOut handler:nil];
//}


@end
