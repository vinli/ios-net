//
//  VLRulesIntegrationTests.m
//  VinliSDK
//
//  Created by Jai Ghanekar on 3/2/16.
//  Copyright © 2016 Vinli. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "VLSessionManager.h"
#import "VLService.h"
#import "VLDevice.h"

@interface VLRulesIntegrationTests : XCTestCase
@property NSString *accessToken;
@property NSDictionary *devices;
@property VLDevice *device;
@property NSDictionary *rules;

@end



//need to add methods for posting and deleting

@implementation VLRulesIntegrationTests

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
    
    
    
    XCTestExpectation *expectationR = [self expectationWithDescription:@"rules call"];
    [[VLSessionManager sharedManager].service startWithHost:self.accessToken requestUri:@"https://rules.vin.li/api/v1/devices/d47ef610-c7b9-44ac-9a41-39f9c6056de5/rules" onSuccess:^(NSDictionary *result, NSHTTPURLResponse *response) {
        [expectationR fulfill];
        self.rules = result;
        XCTAssertTrue(YES);
    } onFailure:^(NSError *error, NSHTTPURLResponse *response, NSString *msg) {
        XCTAssertTrue(NO);
    }];
    [self waitForExpectationsWithTimeout:0.5 handler:nil];
    
    
}

- (void)tearDown {

    [super tearDown];
}

- (void)testGetAllRulesWithDeviceId {
    NSDictionary *expectedJSON = self.rules;
    XCTestExpectation *expectedRules = [self expectationWithDescription:@"rules service call"];
    [[VLSessionManager sharedManager].service getRulesForDeviceWithId:self.device.deviceId onSuccess:^(VLRulePager *rulePager, NSHTTPURLResponse *response) {
        [expectedRules fulfill];
        XCTAssertEqual(rulePager.rules.count, [expectedJSON[@"rules"] count]);
        
        XCTAssertEqual(rulePager.total, [expectedJSON[@"meta"][@"pagination"][@"total"] unsignedLongValue]);
        
        //XCTAssertTrue([[[rulePager.rules objectAtIndex:0] name] isEqualToString:expectedJSON[@"rules"][0][@"name"]]);

        
        
    } onFailure:^(NSError *error, NSHTTPURLResponse *response, NSString *bodyString) {
        XCTAssertTrue(NO);
    }];
    [self waitForExpectationsWithTimeout:0.5 handler:nil];
}




@end
