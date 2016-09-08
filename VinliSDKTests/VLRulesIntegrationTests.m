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

@end

@implementation VLRulesIntegrationTests

- (void)setUp {
    [super setUp];
    
    _vlService = [VLTestHelper vlService];
}

- (void)tearDown {
    [super tearDown];
}

- (void)testGetAllRulesWithDeviceId {
    if(![VLTestHelper deviceId]){
        XCTAssertTrue(NO);
        return;
    }
    
    XCTestExpectation *expectedRules = [self expectationWithDescription:@"rules service call"];
    [_vlService getRulesForDeviceWithId:[VLTestHelper deviceId] onSuccess:^(VLRulePager *rulePager, NSHTTPURLResponse *response) {
        XCTAssertTrue(rulePager.rules.count > 0);
        XCTAssertTrue(rulePager.total > 0);
        
        for(VLRule *rule in rulePager.rules){
            XCTAssertTrue(rule.ruleId != nil && [rule.ruleId isKindOfClass:[NSString class]] && rule.ruleId.length > 0);
            XCTAssertTrue(rule.deviceId != nil && [rule.deviceId isKindOfClass:[NSString class]] && rule.deviceId.length > 0);
            XCTAssertTrue(rule.ruleId != nil && [rule.ruleId isKindOfClass:[NSString class]] && rule.ruleId.length > 0);
        }
        [expectedRules fulfill];
    } onFailure:^(NSError *error, NSHTTPURLResponse *response, NSString *bodyString) {
        XCTAssertTrue(NO);
        [expectedRules fulfill];
    }];
    
    [self waitForExpectationsWithTimeout:[VLTestHelper defaultTimeOut] handler:nil];
}

- (void)testGetRuleWithId {
    if(![VLTestHelper ruleId]){
        XCTAssertTrue(NO);
        return;
    }
    
    XCTestExpectation *expectedRule = [self expectationWithDescription:@"service call for a single rule"];
    [_vlService getRuleWithId:[VLTestHelper ruleId] onSuccess:^(VLRule *rule, NSHTTPURLResponse *response) {
        XCTAssertTrue(rule.ruleId != nil && [rule.ruleId isKindOfClass:[NSString class]] && rule.ruleId.length > 0);
        XCTAssertTrue(rule.deviceId != nil && [rule.deviceId isKindOfClass:[NSString class]] && rule.deviceId.length > 0);
        XCTAssertTrue(rule.ruleId != nil && [rule.ruleId isKindOfClass:[NSString class]] && rule.ruleId.length > 0);
        [expectedRule fulfill];
    } onFailure:^(NSError *error, NSHTTPURLResponse *response, NSString *bodyString) {
        XCTAssertTrue(NO);
        [expectedRule fulfill];
    }];
    
    [self waitForExpectationsWithTimeout:[VLTestHelper defaultTimeOut] handler:nil];
}




@end
