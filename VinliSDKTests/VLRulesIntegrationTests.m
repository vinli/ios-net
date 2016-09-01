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
#import "VLTestHelper.h"

@interface VLRulesIntegrationTests : XCTestCase

@property VLService *vlService;
@property NSDictionary *devices;
@property VLDevice *device;
@property NSDictionary *rules;
@property NSString *deviceId;
@property NSString *ruleId;
@property NSDictionary *rule;

@end

@implementation VLRulesIntegrationTests

- (void)setUp {
    [super setUp];
    
    self.vlService = [VLTestHelper vlService];
    self.deviceId = [VLTestHelper deviceId];
    self.ruleId = [VLTestHelper ruleId];
    
    
    XCTestExpectation *expectation = [self expectationWithDescription:@"getting devices call"];
    [_vlService startWithHost:[VLTestHelper accessToken] requestUri:@"https://platform.vin.li/api/v1/devices" onSuccess:^(NSDictionary *result, NSHTTPURLResponse *response) {
        self.devices = result;
        [expectation fulfill];
    } onFailure:^(NSError *error, NSHTTPURLResponse *response, NSString *msg) {
        XCTAssertTrue(NO);
        [expectation fulfill];
    } ];
    
    XCTestExpectation *expectationRule = [self expectationWithDescription:@"get specific rule"];
    [_vlService startWithHost:[VLTestHelper accessToken] requestUri:[NSString stringWithFormat:@"https://rules.vin.li/api/v1/rules/%@", self.ruleId] onSuccess:^(NSDictionary *result, NSHTTPURLResponse *response) {
        self.rule = result;
        [expectationRule fulfill];
    } onFailure:^(NSError *error, NSHTTPURLResponse *response, NSString *msg) {
        XCTAssertTrue(NO);
        [expectationRule fulfill];
    }];
    
    XCTestExpectation *expectationR = [self expectationWithDescription:@"rules call"];
    [_vlService startWithHost:[VLTestHelper accessToken] requestUri:[NSString stringWithFormat:@"https://rules.vin.li/api/v1/devices/%@/rules", self.deviceId] onSuccess:^(NSDictionary *result, NSHTTPURLResponse *response) {
        self.rules = result;
        [expectationR fulfill];
    } onFailure:^(NSError *error, NSHTTPURLResponse *response, NSString *msg) {
        XCTAssertTrue(NO);
        [expectationR fulfill];
    }];
    
    [self waitForExpectationsWithTimeout:[VLTestHelper defaultTimeOut] handler:nil];
}

- (void)tearDown {
    [super tearDown];
}

- (void)testGetAllRulesWithDeviceId {
    NSDictionary *expectedJSON = self.rules;
    
    XCTestExpectation *expectedRules = [self expectationWithDescription:@"rules service call"];
    [_vlService getRulesForDeviceWithId:self.deviceId onSuccess:^(VLRulePager *rulePager, NSHTTPURLResponse *response) {
        XCTAssertEqual(rulePager.rules.count, [expectedJSON[@"rules"] count]);
        XCTAssertEqual(rulePager.total, [expectedJSON[@"meta"][@"pagination"][@"total"] unsignedLongValue]);
        //XCTAssertTrue([[[rulePager.rules objectAtIndex:0] name] isEqualToString:expectedJSON[@"rules"][0][@"name"]]);
        [expectedRules fulfill];
    } onFailure:^(NSError *error, NSHTTPURLResponse *response, NSString *bodyString) {
        XCTAssertTrue(NO);
        [expectedRules fulfill];
    }];
    
    [self waitForExpectationsWithTimeout:[VLTestHelper defaultTimeOut] handler:nil];
}

- (void)testGetRuleWithId {
    NSDictionary *expectedJSON = self.rule;
    
    XCTestExpectation *expectedRule = [self expectationWithDescription:@"service call for a single rule"];
    [_vlService getRuleWithId:self.ruleId onSuccess:^(VLRule *rule, NSHTTPURLResponse *response) {
        XCTAssertEqualObjects(rule.deviceId, expectedJSON[@"rule"][@"deviceId"]);
        XCTAssertEqualObjects(rule.eventsURL.absoluteString, expectedJSON[@"rule"][@"links"][@"events"]); // Make sure that the Meta more or less translated correctly.
        XCTAssertEqualObjects(rule.name, expectedJSON[@"rule"][@"name"]);
        [expectedRule fulfill];
    } onFailure:^(NSError *error, NSHTTPURLResponse *response, NSString *bodyString) {
        XCTAssertTrue(NO);
        [expectedRule fulfill];
    }];
    
    [self waitForExpectationsWithTimeout:[VLTestHelper defaultTimeOut] handler:nil];
}




@end
