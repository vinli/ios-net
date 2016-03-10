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
@property NSDictionary *devices;
@property VLDevice *device;
@property NSDictionary *rules;
@property NSString *deviceId;
@property NSString *ruleId;
@property NSDictionary *rule;
@end



//need to add methods for posting and deleting

@implementation VLRulesIntegrationTests

- (void)setUp {
    [super setUp];
    self.deviceId = @"ba89372f-74f4-43c8-a4fd-b8f24699426e";
    self.ruleId = @"2be6570b-566f-43b5-beab-79eb1ed1fbed";
    
    
    XCTestExpectation *expectation = [self expectationWithDescription:@"getting devices call"];
    [[VLSessionManager sharedManager].service startWithHost:[VLTestHelper accessToken] requestUri:@"https://platform.vin.li/api/v1/devices" onSuccess:^(NSDictionary *result, NSHTTPURLResponse *response) {
        [expectation fulfill];
        self.devices = result;
        XCTAssertTrue(YES);
    } onFailure:^(NSError *error, NSHTTPURLResponse *response, NSString *msg) {
        XCTAssertTrue(NO);
    } ];
    
    [self waitForExpectationsWithTimeout:[VLTestHelper defaultTimeOut] handler:nil];
    
    
    
    XCTestExpectation *expectationRule = [self expectationWithDescription:@"get specific rule"];
    [[VLSessionManager sharedManager].service startWithHost:[VLTestHelper accessToken] requestUri:[NSString stringWithFormat:@"https://rules.vin.li/api/v1/rules/%@", self.ruleId] onSuccess:^(NSDictionary *result, NSHTTPURLResponse *response) {
        [expectationRule fulfill];
        self.rule = result;
    } onFailure:^(NSError *error, NSHTTPURLResponse *response, NSString *msg) {
        XCTAssertTrue(NO);
    }];
    [self waitForExpectationsWithTimeout:[VLTestHelper defaultTimeOut] handler:nil];
    
    
    
    
    XCTestExpectation *expectationR = [self expectationWithDescription:@"rules call"];
    [[VLSessionManager sharedManager].service startWithHost:[VLTestHelper accessToken] requestUri:[NSString stringWithFormat:@"https://rules.vin.li/api/v1/devices/%@/rules", self.deviceId] onSuccess:^(NSDictionary *result, NSHTTPURLResponse *response) {
        [expectationR fulfill];
        self.rules = result;
        XCTAssertTrue(YES);
    } onFailure:^(NSError *error, NSHTTPURLResponse *response, NSString *msg) {
        XCTAssertTrue(NO);
    }];
    [self waitForExpectationsWithTimeout:[VLTestHelper defaultTimeOut] handler:nil];
    
    
}

- (void)tearDown {

    [super tearDown];
}

- (void)testGetAllRulesWithDeviceId {
    NSDictionary *expectedJSON = self.rules;
    XCTestExpectation *expectedRules = [self expectationWithDescription:@"rules service call"];
    [[VLSessionManager sharedManager].service getRulesForDeviceWithId:self.deviceId onSuccess:^(VLRulePager *rulePager, NSHTTPURLResponse *response) {
        [expectedRules fulfill];
        XCTAssertEqual(rulePager.rules.count, [expectedJSON[@"rules"] count]);
        
        XCTAssertEqual(rulePager.total, [expectedJSON[@"meta"][@"pagination"][@"total"] unsignedLongValue]);
        
        //XCTAssertTrue([[[rulePager.rules objectAtIndex:0] name] isEqualToString:expectedJSON[@"rules"][0][@"name"]]);
        
        
    } onFailure:^(NSError *error, NSHTTPURLResponse *response, NSString *bodyString) {
        XCTAssertTrue(NO);
    }];
    [self waitForExpectationsWithTimeout:[VLTestHelper defaultTimeOut] handler:nil];
}

- (void)testGetRuleWithId {
    NSDictionary *expectedJSON = self.rule;
    XCTestExpectation *expectedRule = [self expectationWithDescription:@"service call for a single rule"];
    [[VLSessionManager sharedManager].service getRuleWithId:self.ruleId onSuccess:^(VLRule *rule, NSHTTPURLResponse *response) {
        [expectedRule fulfill];
        XCTAssertEqualObjects(rule.deviceId, expectedJSON[@"rule"][@"deviceId"]);
        XCTAssertEqualObjects(rule.eventsURL.absoluteString, expectedJSON[@"rule"][@"links"][@"events"]); // Make sure that the Meta more or less translated correctly.
        XCTAssertEqualObjects(rule.name, expectedJSON[@"rule"][@"name"]);
        
    } onFailure:^(NSError *error, NSHTTPURLResponse *response, NSString *bodyString) {
        XCTAssertTrue(NO);
    }];
    [self waitForExpectationsWithTimeout:[VLTestHelper defaultTimeOut] handler:nil];
}




@end
