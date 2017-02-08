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

@property VLService *vlService;

@end

@implementation VLEventsIntegrationTests

- (void)setUp {
    [super setUp];
    
    _vlService = [VLTestHelper vlService];
}

- (void)tearDown {
    [super tearDown];
}

- (void)testGetEventsWithDeviceId {
    if(![VLTestHelper deviceId]){
        XCTAssertTrue(NO);
        return;
    }
    
    XCTestExpectation *eventsExpectation = [self expectationWithDescription:@"Getting events"];
    [_vlService getEventsForDeviceWithId:[VLTestHelper deviceId] eventType:nil onSuccess:^(VLEventPager *eventPager, NSHTTPURLResponse *response) {
        XCTAssertTrue(eventPager.events.count > 0);
        XCTAssertTrue(eventPager.since != nil && [eventPager.since isKindOfClass:[NSString class]] && eventPager.since.length > 0);
        XCTAssertTrue(eventPager.until != nil && [eventPager.until isKindOfClass:[NSString class]] && eventPager.until.length > 0);
        
        for(VLEvent *event in eventPager.events){
            XCTAssertTrue(event.eventId != nil && [event.eventId isKindOfClass:[NSString class]] && event.eventId.length > 0);
            XCTAssertTrue(event.timestamp != nil && [event.timestamp isKindOfClass:[NSString class]] && event.timestamp.length > 0);
            XCTAssertTrue(event.deviceId != nil && [event.deviceId isKindOfClass:[NSString class]] && event.deviceId.length > 0);
            XCTAssertTrue(event.eventType != nil && [event.eventType isKindOfClass:[NSString class]] && event.eventType.length > 0);
        }
        [eventsExpectation fulfill];
    } onFailure:^(NSError *error, NSHTTPURLResponse *response, NSString *bodyString) {
        XCTAssertTrue(NO);
        [eventsExpectation fulfill];
    }];
    
    [self waitForExpectationsWithTimeout:[VLTestHelper defaultTimeOut] handler:nil];
}

- (void)testGetEventsWithDeviceIdAndStartUp {
    if(![VLTestHelper deviceId]){
        XCTAssertTrue(NO);
        return;
    }
    
    XCTestExpectation *eventsExpectation = [self expectationWithDescription:@"Getting events"];
    [_vlService getEventsForDeviceWithId:[VLTestHelper deviceId] eventType:VLEventTypeStartUp onSuccess:^(VLEventPager *eventPager, NSHTTPURLResponse *response) {
        XCTAssertTrue(eventPager.events.count > 0);
        XCTAssertTrue(eventPager.since != nil && [eventPager.since isKindOfClass:[NSString class]] && eventPager.since.length > 0);
        XCTAssertTrue(eventPager.until != nil && [eventPager.until isKindOfClass:[NSString class]] && eventPager.until.length > 0);
        
        for(VLEvent *event in eventPager.events){
            XCTAssertTrue(event.eventId != nil && [event.eventId isKindOfClass:[NSString class]] && event.eventId.length > 0);
            XCTAssertTrue(event.timestamp != nil && [event.timestamp isKindOfClass:[NSString class]] && event.timestamp.length > 0);
            XCTAssertTrue(event.deviceId != nil && [event.deviceId isKindOfClass:[NSString class]] && event.deviceId.length > 0);
            XCTAssertTrue(event.eventType != nil && [event.eventType isKindOfClass:[NSString class]] && event.eventType.length > 0);
            XCTAssertTrue([event.eventType isEqualToString:VLEventTypeStartUp]);
        }
        [eventsExpectation fulfill];
    } onFailure:^(NSError *error, NSHTTPURLResponse *response, NSString *bodyString) {
        XCTAssertTrue(NO);
        [eventsExpectation fulfill];
    }];
    
    [self waitForExpectationsWithTimeout:[VLTestHelper defaultTimeOut] handler:nil];
}


- (void)testGetNotificationsWithEventId {
    if(![VLTestHelper eventId]){
        XCTAssertTrue(NO);
        return;
    }
    
    XCTestExpectation *eventNotificationExpectation = [self expectationWithDescription:@"All notifications for event"];
    [_vlService getNotificationsForEventWithId:[VLTestHelper eventId] onSuccess:^(VLNotificationPager *notificationPager, NSHTTPURLResponse *response) {
        XCTAssertTrue(notificationPager.notifications.count > 0);
        XCTAssertTrue(notificationPager.since != nil && [notificationPager.since isKindOfClass:[NSString class]] && notificationPager.since.length > 0);
        XCTAssertTrue(notificationPager.until != nil && [notificationPager.until isKindOfClass:[NSString class]] && notificationPager.until.length > 0);
        
        for(VLNotification *notification in notificationPager.notifications){
            XCTAssertTrue(notification.notificationId != nil && [notification.notificationId isKindOfClass:[NSString class]] && notification.notificationId.length > 0);
            XCTAssertTrue(notification.eventId != nil && [notification.eventId isKindOfClass:[NSString class]] && notification.eventId.length > 0);
            XCTAssertTrue(notification.eventType != nil && [notification.eventType isKindOfClass:[NSString class]] && notification.eventType.length > 0);
            XCTAssertTrue(notification.eventTimestamp != nil && [notification.eventTimestamp isKindOfClass:[NSString class]] && notification.eventTimestamp.length > 0);
            XCTAssertTrue(notification.subscriptionId != nil && [notification.subscriptionId isKindOfClass:[NSString class]] && notification.subscriptionId.length > 0);
            XCTAssertTrue(notification.url != nil && [notification.url isKindOfClass:[NSURL class]] && notification.url.absoluteString.length > 0);
        }
        [eventNotificationExpectation fulfill];
    } onFailure:^(NSError *error, NSHTTPURLResponse *response, NSString *bodyString) {
        XCTAssertTrue(NO);
        [eventNotificationExpectation fulfill];
    }];
    
    [self waitForExpectationsWithTimeout:[VLTestHelper defaultTimeOut] handler:nil];
}

- (void)testGetNotificationsWithSubscriptionId {
    if(![VLTestHelper subscriptionId]){
        XCTAssertTrue(NO);
        return;
    }
    
    XCTestExpectation *expectedNotificationsForSubscription = [self expectationWithDescription:@"notifications for subscription id"];
    [_vlService getNotificationsForSubscriptionWithId:[VLTestHelper subscriptionId] onSuccess:^(VLNotificationPager *notificationPager, NSHTTPURLResponse *response) {
        XCTAssertTrue(notificationPager.notifications.count > 0);
        XCTAssertTrue(notificationPager.since != nil && [notificationPager.since isKindOfClass:[NSString class]] && notificationPager.since.length > 0);
        XCTAssertTrue(notificationPager.until != nil && [notificationPager.until isKindOfClass:[NSString class]] && notificationPager.until.length > 0);
        
        for(VLNotification *notification in notificationPager.notifications){
            XCTAssertTrue(notification.notificationId != nil && [notification.notificationId isKindOfClass:[NSString class]] && notification.notificationId.length > 0);
            XCTAssertTrue(notification.eventId != nil && [notification.eventId isKindOfClass:[NSString class]] && notification.eventId.length > 0);
            XCTAssertTrue(notification.eventType != nil && [notification.eventType isKindOfClass:[NSString class]] && notification.eventType.length > 0);
            XCTAssertTrue(notification.eventTimestamp != nil && [notification.eventTimestamp isKindOfClass:[NSString class]] && notification.eventTimestamp.length > 0);
            XCTAssertTrue(notification.subscriptionId != nil && [notification.subscriptionId isKindOfClass:[NSString class]] && notification.subscriptionId.length > 0);
            XCTAssertTrue(notification.url != nil && [notification.url isKindOfClass:[NSURL class]] && notification.url.absoluteString.length > 0);
        }
        [expectedNotificationsForSubscription fulfill];
    } onFailure:^(NSError *error, NSHTTPURLResponse *response, NSString *bodyString) {
        XCTAssertTrue(NO);
        [expectedNotificationsForSubscription fulfill];
    }];
    
    [self waitForExpectationsWithTimeout:[VLTestHelper defaultTimeOut] handler:nil];
}

- (void)testGetEventWithId {
    if(![VLTestHelper eventId]){
        XCTAssertTrue(NO);
        return;
    }
    
    XCTestExpectation *singleEventExpected = [self expectationWithDescription:@"service call for a single event"];
    [_vlService getEventWithId:[VLTestHelper eventId] onSuccess:^(VLEvent *event, NSHTTPURLResponse *response) {
        XCTAssertTrue(event.eventId != nil && [event.eventId isKindOfClass:[NSString class]] && event.eventId.length > 0);
        XCTAssertTrue(event.timestamp != nil && [event.timestamp isKindOfClass:[NSString class]] && event.timestamp.length > 0);
        XCTAssertTrue(event.deviceId != nil && [event.deviceId isKindOfClass:[NSString class]] && event.deviceId.length > 0);
        XCTAssertTrue(event.eventType != nil && [event.eventType isKindOfClass:[NSString class]] && event.eventType.length > 0);
        [singleEventExpected fulfill];
    } onFailure:^(NSError *error, NSHTTPURLResponse *response, NSString *bodyString) {
        XCTAssertTrue(NO);
        [singleEventExpected fulfill];
    }];
    
    [self waitForExpectationsWithTimeout:[VLTestHelper defaultTimeOut] handler:nil];
}

- (void)testGetNotificationWithId {
    if(![VLTestHelper notificationId]){
        XCTAssertTrue(NO);
        return;
    }
    
    XCTestExpectation *expectingSingleNotification = [self expectationWithDescription:@"service call for single device"];
    [_vlService getNotificationWithId:[VLTestHelper notificationId] onSuccess:^(VLNotification *notification, NSHTTPURLResponse *response) {
        XCTAssertTrue(notification.notificationId != nil && [notification.notificationId isKindOfClass:[NSString class]] && notification.notificationId.length > 0);
        XCTAssertTrue(notification.eventId != nil && [notification.eventId isKindOfClass:[NSString class]] && notification.eventId.length > 0);
        XCTAssertTrue(notification.eventType != nil && [notification.eventType isKindOfClass:[NSString class]] && notification.eventType.length > 0);
        XCTAssertTrue(notification.eventTimestamp != nil && [notification.eventTimestamp isKindOfClass:[NSString class]] && notification.eventTimestamp.length > 0);
        XCTAssertTrue(notification.subscriptionId != nil && [notification.subscriptionId isKindOfClass:[NSString class]] && notification.subscriptionId.length > 0);
        XCTAssertTrue(notification.url != nil && [notification.url isKindOfClass:[NSURL class]] && notification.url.absoluteString.length > 0);
        [expectingSingleNotification fulfill];
    } onFailure:^(NSError *error, NSHTTPURLResponse *response, NSString *bodyString) {
        XCTAssertTrue(NO);
        [expectingSingleNotification fulfill];
    }];
    
    [self waitForExpectationsWithTimeout:[VLTestHelper defaultTimeOut] handler:nil];
}

#pragma mark - Vehicularization

- (void)testGetEventsWithVehicleId {
    if (![VLTestHelper vehicleId]) {
        XCTAssertTrue(NO);
        return;
    }
    
    XCTestExpectation *expectation = [self expectationWithDescription:[NSString stringWithFormat:@"Vehicularization: Get events for vehicle with id: %@", [VLTestHelper vehicleId]]];
    [self.vlService getEventsForVehicleWithId:[VLTestHelper vehicleId] eventType:nil timeSeries:nil onSuccess:^(VLEventPager *eventPager, NSHTTPURLResponse *response) {
        XCTAssertNotNil(eventPager);
        XCTAssertNotNil(eventPager.events);
        XCTAssertTrue(eventPager.events.count > 0);
        [expectation fulfill];
    } onFailure:^(NSError *error, NSHTTPURLResponse *response, NSString *bodyString) {
        XCTAssertTrue(NO);
        [expectation fulfill];
    }];
    
    [self waitForExpectationsWithTimeout:[VLTestHelper defaultTimeOut] handler:nil];
}

- (void)testGetEventsWithVehicleIdAndEventType {
    if (![VLTestHelper vehicleId]) {
        XCTAssertTrue(NO);
        return;
    }
    
    XCTestExpectation *expectation = [self expectationWithDescription:[NSString stringWithFormat:@"Vehicularization: Get events for vehicle with id: %@", [VLTestHelper vehicleId]]];
    [self.vlService getEventsForVehicleWithId:[VLTestHelper vehicleId] eventType:VLEventTypeShutdown timeSeries:nil onSuccess:^(VLEventPager *eventPager, NSHTTPURLResponse *response) {
        XCTAssertNotNil(eventPager);
        XCTAssertNotNil(eventPager.events);
        XCTAssertTrue(eventPager.events.count > 0);
        XCTAssertTrue([[(VLEvent *)eventPager.events.firstObject eventType] isEqualToString:VLEventTypeShutdown]);
        [expectation fulfill];
    } onFailure:^(NSError *error, NSHTTPURLResponse *response, NSString *bodyString) {
        XCTAssertTrue(NO);
        [expectation fulfill];
    }];
    
    [self waitForExpectationsWithTimeout:[VLTestHelper defaultTimeOut] handler:nil];
}


@end
