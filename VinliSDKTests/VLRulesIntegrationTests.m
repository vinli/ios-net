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
    NSDictionary *expectedJSON = [VLTestHelper getAllRulesJSON:@"2ad86caa-5a30-429e-80b8-80bc3da5efe6"];
    
    if(![VLTestHelper deviceId]){
        XCTAssertTrue(NO);
        return;
    }
    
    XCTestExpectation *expectedRules = [self expectationWithDescription:@"rules service call"];
    [_vlService getRulesForDeviceWithId:[VLTestHelper deviceId] onSuccess:^(VLRulePager *rulePager, NSHTTPURLResponse *response) {
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
    NSDictionary *expectedJSON = [VLTestHelper getRuleJSON:@"2ad86caa-5a30-429e-80b8-80bc3da5efe6"];
    
    if(![VLTestHelper ruleId]){
        XCTAssertTrue(NO);
        return;
    }
    
    XCTestExpectation *expectedRule = [self expectationWithDescription:@"service call for a single rule"];
    [_vlService getRuleWithId:[VLTestHelper ruleId] onSuccess:^(VLRule *rule, NSHTTPURLResponse *response) {
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
