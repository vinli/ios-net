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

@interface VLSubscriptionIntegrationTests : XCTestCase
@property NSString *accessToken;
@property NSDictionary *devices;
@property VLDevice *device;
@property NSDictionary *subscriptions;

@end

@implementation VLSubscriptionIntegrationTests

- (void)setUp {
    [super setUp];
    
    
    self.accessToken = @"HbZ_1S2vdywJk72iuPofm816fRhmYgRhT0OTwpyQX0okmDElQ7J8p5W_sKNUr8iE";
    
    
    
    XCTestExpectation *expectation = [self expectationWithDescription:@"getting devices call"];
    [[VLSessionManager sharedManager].service startWithHost:self.accessToken requestUri:@"https://platform.vin.li/api/v1/devices" onSuccess:^(NSDictionary *result, NSHTTPURLResponse *response) {
        [expectation fulfill];
        self.devices = result;
        XCTAssertTrue(YES);
    } onFailure:^(NSError *error, NSHTTPURLResponse *response, NSString *msg) {
        XCTAssertTrue(NO);
    } ];
    
    [self waitForExpectationsWithTimeout:0.5 handler:nil];
    
    

    
    
    
    //TO DO:need to add test for creating subscription and subscription with id
    
    
    XCTestExpectation *expectationS = [self expectationWithDescription:@"get subscriptions for device call"];
    [[VLSessionManager sharedManager].service startWithHost:self.accessToken requestUri:@"https://events.vin.li/api/v1/devices/d47ef610-c7b9-44ac-9a41-39f9c6056de5/subscriptions" onSuccess:^(NSDictionary *result, NSHTTPURLResponse *response) {
        [expectationS fulfill];
        self.subscriptions = result;
    } onFailure:^(NSError *error, NSHTTPURLResponse *response, NSString *msg) {
        XCTAssertTrue(NO);
    }];
    [self waitForExpectationsWithTimeout:0.5 handler:nil];
    
    
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
    
    [self waitForExpectationsWithTimeout:0.5 handler:nil];

}


- (void)testGetSubscriptionswithDeviceId {
    NSDictionary *expectedJSON = self.subscriptions;
    XCTestExpectation *expectedDevices = [self expectationWithDescription:@"getting the subscriptions"];
    [[VLSessionManager sharedManager].service getSubscriptionsForDeviceWithId:self.device.deviceId onSuccess:^(VLSubscriptionPager *subscriptionPager, NSHTTPURLResponse *response) {
        [expectedDevices fulfill];
        XCTAssertEqual(subscriptionPager.subscriptions.count, [expectedJSON[@"subscriptions"] count]); // Make sure that there is one object in the array.
        
        XCTAssertEqual(subscriptionPager.total, [expectedJSON[@"meta"][@"pagination"][@"total"] unsignedLongValue]); // Make sure that the Meta more or less translated correctly.
        
        //add more tests ie specfic models
    } onFailure:^(NSError *error, NSHTTPURLResponse *response, NSString *bodyString) {
        XCTAssertTrue(NO);
    }];
    [self waitForExpectationsWithTimeout:5.0 handler:nil];
}


//add tests for delete post




- (void)tearDown {

    [super tearDown];
}






@end
