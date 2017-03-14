//
//  VLEventServicesTests.m
//  VinliSDK
//
//  Created by Tommy Brown on 5/22/15.
//  Copyright (c) 2015 Vinli. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>
#import <OCMock/OCMock.h>
#import "VLService.h"
#import "VLRule.h"
#import "VLTestHelper.h"

@interface VLRuleServicesTests : XCTestCase{
    VLService *service;
    NSString *deviceId;
    NSString *ruleId;
}
@end

@implementation VLRuleServicesTests

- (void)setUp {
    [super setUp];
    service = [[VLService alloc] init];
    [service useSession:[[VLSession alloc] initWithAccessToken:@"TEST"]];
    deviceId = @"11111111-2222-3333-4444-555555555555";
    ruleId = @"11111111-2222-3333-4444-555555555555";
}

- (void)tearDown {
    [super tearDown];
}

- (void) testCreateRuleForDevice{
    id mockConnection = OCMPartialMock(service);
    
    NSDictionary *expectedJSON = [VLTestHelper getRuleJSON:ruleId];
    
    [[[mockConnection expect] andDo:^(NSInvocation *invocation) {
        
        NSDictionary *rule = [expectedJSON copy];
        
        NSHTTPURLResponse *response = [[NSHTTPURLResponse alloc] initWithURL:[NSURL new] statusCode:201 HTTPVersion:nil headerFields:nil];
        
        void (^successBlock)(NSDictionary *result, NSHTTPURLResponse *response) = nil;
        
        [invocation getArgument:&successBlock atIndex:8];
        
        successBlock(rule, response);
        
    }] startWithHost:[OCMArg any] path:[OCMArg any] queries:[OCMArg any] HTTPMethod:[OCMArg any] parameters:[OCMArg any] token:[OCMArg any] onSuccess:[OCMArg any] onFailure:[OCMArg any]];
    
    [service createRule:[[VLRule alloc] initWithDictionary:expectedJSON] forDevice:deviceId onSuccess:^(VLRule *rule, NSHTTPURLResponse *response) {
        
        
        XCTAssertEqual(rule.deviceId, expectedJSON[@"rule"][@"deviceId"]);
        
        XCTAssertEqual(rule.eventsURL.absoluteString, expectedJSON[@"rule"][@"links"][@"events"]); // Make sure that the Meta more or less translated correctly.
        
        XCTAssertEqual(rule.name, expectedJSON[@"rule"][@"name"]);
 
        
    } onFailure:^(NSError *error, NSHTTPURLResponse *response, NSString *bodyString) {
        XCTAssertTrue(NO);
    }];
}

- (void) testGetSpecificRuleWithId{ 
    id mockConnection = OCMPartialMock(service);
    
    NSDictionary *expectedJSON = [VLTestHelper getRuleJSON:ruleId];
    
    [[[mockConnection expect] andDo:^(NSInvocation *invocation) {
        
        NSDictionary *rule = [expectedJSON copy];
        
        NSHTTPURLResponse *response = [[NSHTTPURLResponse alloc] initWithURL:[NSURL new] statusCode:200 HTTPVersion:nil headerFields:nil];
        
        void (^successBlock)(NSDictionary *result, NSHTTPURLResponse *response) = nil;
        
        [invocation getArgument:&successBlock atIndex:8];
        
        successBlock(rule, response);
        
    }] startWithHost:[OCMArg any] path:[OCMArg any] queries:[OCMArg any] HTTPMethod:[OCMArg any] parameters:[OCMArg any] token:[OCMArg any] onSuccess:[OCMArg any] onFailure:[OCMArg any]];
    
    [service getRuleWithId:ruleId onSuccess:^(VLRule *rule, NSHTTPURLResponse *response) {
        
       
        
        XCTAssertEqual(rule.deviceId, expectedJSON[@"rule"][@"deviceId"]);
        
        XCTAssertEqual(rule.eventsURL.absoluteString, expectedJSON[@"rule"][@"links"][@"events"]); // Make sure that the Meta more or less translated correctly.
        
        XCTAssertEqual(rule.name, expectedJSON[@"rule"][@"name"]);
        
    } onFailure:^(NSError *error, NSHTTPURLResponse *response, NSString *bodyString) {
        XCTAssertTrue(NO);
    }];
}

- (void) testDeleteSpecificRuleWithId{
    id mockConnection = OCMPartialMock(service);
    
    [[[mockConnection expect] andDo:^(NSInvocation *invocation) {
        
        NSDictionary *rule = nil;
        
        NSHTTPURLResponse *response = [[NSHTTPURLResponse alloc] initWithURL:[NSURL new] statusCode:204 HTTPVersion:nil headerFields:nil];
        
        void (^successBlock)(NSDictionary *result, NSHTTPURLResponse *response) = nil;
        
        [invocation getArgument:&successBlock atIndex:8];
        
        successBlock(rule, response);
        
    }] startWithHost:[OCMArg any] path:[OCMArg any] queries:[OCMArg any] HTTPMethod:[OCMArg any] parameters:[OCMArg any] token:[OCMArg any] onSuccess:[OCMArg any] onFailure:[OCMArg any]];
    
    [service deleteRuleWithId:ruleId onSuccess:^(NSHTTPURLResponse *response) {
        
        XCTAssertTrue(YES);
        
    } onFailure:^(NSError *error, NSHTTPURLResponse *response, NSString *bodyString) {
        XCTAssertTrue(NO);
    }];
}

- (void) testGetAllRulesForDeviceWithId{
    id mockConnection = OCMPartialMock(service);
    
    NSDictionary *expectedJSON = [VLTestHelper getAllRulesJSON:deviceId];
    
    [[[mockConnection expect] andDo:^(NSInvocation *invocation) {
        
        NSDictionary *message = [expectedJSON copy];
        
        NSHTTPURLResponse *response = [[NSHTTPURLResponse alloc] initWithURL:[NSURL new] statusCode:200 HTTPVersion:nil headerFields:nil];
        
        void (^successBlock)(NSDictionary *result, NSHTTPURLResponse *response) = nil;
        
        [invocation getArgument:&successBlock atIndex:8];
        
        successBlock(message, response);
        
    }] startWithHost:[OCMArg any] path:[OCMArg any] queries:[OCMArg any] HTTPMethod:[OCMArg any] parameters:[OCMArg any] token:[OCMArg any] onSuccess:[OCMArg any] onFailure:[OCMArg any]];
    
    [service getRulesForDeviceWithId:deviceId onSuccess:^(VLRulePager *rulePager, NSHTTPURLResponse *response) {
        
        XCTAssertEqual(rulePager.rules.count, [expectedJSON[@"rules"] count]); // Make sure that there is one object in the array.
        
        XCTAssertEqual(rulePager.total, [expectedJSON[@"meta"][@"pagination"][@"total"] unsignedLongValue]); // Make sure that the Meta more or less translated correctly.
        
        XCTAssertTrue([[[rulePager.rules objectAtIndex:0] name] isEqualToString:expectedJSON[@"rules"][0][@"name"]]);
        
    } onFailure:^(NSError *error, NSHTTPURLResponse *response, NSString *bodyString) {
        XCTAssertTrue(NO);
    }];
}

@end
