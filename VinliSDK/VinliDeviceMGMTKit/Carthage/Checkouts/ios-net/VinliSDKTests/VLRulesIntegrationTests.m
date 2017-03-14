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

- (void)testCreateParametricRuleWithDeviceId {
    if(![VLTestHelper deviceId]){
        XCTAssertTrue(NO);
        return;
    }
    
    XCTestExpectation *expectedRules = [self expectationWithDescription:@"rules service call"];
    VLParametricBoundary *boundary = [[VLParametricBoundary alloc] initWithParameter:@"vehicleSpeed" min:90 max:99];
    VLRule *rule = [[VLRule alloc] initWithName:@"TestRule" boundaries:@[boundary]];
    
    [self.vlService createRule:rule forDevice:[VLTestHelper deviceId] onSuccess:^(VLRule *newRule, NSHTTPURLResponse *response) {
        XCTAssertNotNil(newRule);
        XCTAssertTrue(newRule.ruleId != nil && [newRule.ruleId isKindOfClass:[NSString class]] && newRule.ruleId.length > 0);
        XCTAssertEqualObjects(newRule.deviceId, [VLTestHelper deviceId]);
        XCTAssertNil(newRule.vehicleId);
        XCTAssertEqualObjects(rule.name, newRule.name);
        XCTAssertTrue(newRule.boundaries.count > 0);
        VLParametricBoundary *newBoundary = newRule.boundaries.firstObject;
        XCTAssertEqualObjects(newBoundary.type, boundary.type);
        XCTAssertEqualObjects(newBoundary.parameter, boundary.parameter);
        XCTAssertTrue(newBoundary.min == boundary.min);
        XCTAssertTrue(newBoundary.max == boundary.max);
        [self.vlService deleteRuleWithId:newRule.ruleId onSuccess:^(NSHTTPURLResponse *response) {
            [expectedRules fulfill];
        } onFailure:^(NSError *error, NSHTTPURLResponse *response, NSString *bodyString) {
            [expectedRules fulfill];
        }];
    } onFailure:^(NSError *error, NSHTTPURLResponse *response, NSString *body) {
        XCTAssertTrue(NO);
        [expectedRules fulfill];
    }];
    
    [self waitForExpectationsWithTimeout:[VLTestHelper defaultTimeOut] handler:nil];
}

- (void)testCreateGeoSpatialRadiusRuleWithDeviceId {
    if(![VLTestHelper deviceId]){
        XCTAssertTrue(NO);
        return;
    }
    
    XCTestExpectation *expectedRules = [self expectationWithDescription:@"rules service call"];
    VLRadiusBoundary *boundary = [[VLRadiusBoundary alloc] initWithRadius:50 latitude:[VLTestHelper getTestLatitude] longitude:[VLTestHelper getTestLongitude]];
    VLRule *rule = [[VLRule alloc] initWithName:@"TestRule" boundaries:@[boundary]];
    
    [self.vlService createRule:rule forDevice:[VLTestHelper deviceId] onSuccess:^(VLRule *newRule, NSHTTPURLResponse *response) {
        XCTAssertNotNil(newRule);
        XCTAssertTrue(newRule.ruleId != nil && [newRule.ruleId isKindOfClass:[NSString class]] && newRule.ruleId.length > 0);
        XCTAssertEqualObjects(newRule.deviceId, [VLTestHelper deviceId]);
        XCTAssertNil(newRule.vehicleId);
        XCTAssertEqualObjects(rule.name, newRule.name);
        XCTAssertTrue(newRule.boundaries.count > 0);
        VLRadiusBoundary *newBoundary = newRule.boundaries.firstObject;
        XCTAssertEqualObjects(newBoundary.type, boundary.type);
        XCTAssertTrue(newBoundary.radius == boundary.radius);
        XCTAssertTrue(newBoundary.latitude == boundary.latitude);
        XCTAssertTrue(newBoundary.longitude == boundary.longitude);
        [self.vlService deleteRuleWithId:newRule.ruleId onSuccess:^(NSHTTPURLResponse *response) {
            [expectedRules fulfill];
        } onFailure:^(NSError *error, NSHTTPURLResponse *response, NSString *bodyString) {
            [expectedRules fulfill];
        }];
    } onFailure:^(NSError *error, NSHTTPURLResponse *response, NSString *body) {
        XCTAssertTrue(NO);
        [expectedRules fulfill];
    }];
    
    [self waitForExpectationsWithTimeout:[VLTestHelper defaultTimeOut] handler:nil];
}

- (void)testCreateGeoSpatialPolygonRuleWithDeviceId {
    if(![VLTestHelper deviceId]){
        XCTAssertTrue(NO);
        return;
    }
    
    XCTestExpectation *expectedRules = [self expectationWithDescription:@"rules service call"];
    VLPolygonBoundary *boundary = [[VLPolygonBoundary alloc] initWithCoordinates:[VLTestHelper getPolygonGeometry]];
    VLRule *rule = [[VLRule alloc] initWithName:@"TestRule" boundaries:@[boundary]];
    
    [self.vlService createRule:rule forDevice:[VLTestHelper deviceId] onSuccess:^(VLRule *newRule, NSHTTPURLResponse *response) {
        XCTAssertNotNil(newRule);
        XCTAssertTrue(newRule.ruleId != nil && [newRule.ruleId isKindOfClass:[NSString class]] && newRule.ruleId.length > 0);
        XCTAssertEqualObjects(newRule.deviceId, [VLTestHelper deviceId]);
        XCTAssertNil(newRule.vehicleId);
        XCTAssertEqualObjects(rule.name, newRule.name);
        XCTAssertTrue(newRule.boundaries.count > 0);
        VLPolygonBoundary *newBoundary = newRule.boundaries.firstObject;
        XCTAssertEqualObjects(newBoundary.type, boundary.type);
        XCTAssertEqual(newBoundary.coordinates.count, boundary.coordinates.count);
        [self.vlService deleteRuleWithId:newRule.ruleId onSuccess:^(NSHTTPURLResponse *response) {
            [expectedRules fulfill];
        } onFailure:^(NSError *error, NSHTTPURLResponse *response, NSString *bodyString) {
            [expectedRules fulfill];
        }];
    } onFailure:^(NSError *error, NSHTTPURLResponse *response, NSString *body) {
        XCTAssertTrue(NO);
        [expectedRules fulfill];
    }];
    
    [self waitForExpectationsWithTimeout:[VLTestHelper defaultTimeOut] handler:nil];
}



#pragma mark - Vehicularization

- (void)testGetRulesWithVehicleId {
    if(![VLTestHelper vehicleId]){
        XCTAssertTrue(NO);
        return;
    }
    
    XCTestExpectation *expectedRules = [self expectationWithDescription:@"rules service call"];
    [self.vlService getRulesForVehicleWithId:[VLTestHelper vehicleId] onSuccess:^(VLRulePager *rulePager, NSHTTPURLResponse *response) {
        XCTAssertNotNil(rulePager);
        XCTAssertNotNil(rulePager.rules);
        XCTAssertTrue(rulePager.rules.count > 0);
        XCTAssertTrue(rulePager.total > 0);
        
        for(VLRule *rule in rulePager.rules){
            XCTAssertTrue(rule.ruleId != nil && [rule.ruleId isKindOfClass:[NSString class]] && rule.ruleId.length > 0);
            XCTAssertEqualObjects(rule.vehicleId, [VLTestHelper vehicleId]);
            XCTAssertTrue(rule.ruleId != nil && [rule.ruleId isKindOfClass:[NSString class]] && rule.ruleId.length > 0);
        }
        [expectedRules fulfill];
    } onFailure:^(NSError *error, NSHTTPURLResponse *response, NSString *bodyString) {
        XCTAssertTrue(NO);
        [expectedRules fulfill];
    }];
    
    [self waitForExpectationsWithTimeout:[VLTestHelper defaultTimeOut] handler:nil];
}

- (void)testCreateParametricRuleWithVehicleId {
    if(![VLTestHelper vehicleId]){
        XCTAssertTrue(NO);
        return;
    }
    
    XCTestExpectation *expectedRules = [self expectationWithDescription:@"rules service call"];
    VLParametricBoundary *boundary = [[VLParametricBoundary alloc] initWithParameter:@"vehicleSpeed" min:90 max:99];
    VLRule *rule = [[VLRule alloc] initWithName:@"TestRule" boundaries:@[boundary]];

    [self.vlService createRule:rule forVehicle:[VLTestHelper vehicleId] onSuccess:^(VLRule *newRule, NSHTTPURLResponse *response) {
        XCTAssertNotNil(newRule);
        XCTAssertTrue(newRule.ruleId != nil && [newRule.ruleId isKindOfClass:[NSString class]] && newRule.ruleId.length > 0);
        XCTAssertEqualObjects(newRule.vehicleId, [VLTestHelper vehicleId]);
        XCTAssertEqualObjects(rule.name, newRule.name);
        XCTAssertNil(newRule.deviceId);
        XCTAssertTrue(newRule.boundaries.count > 0);
        VLParametricBoundary *newBoundary = newRule.boundaries.firstObject;
        XCTAssertEqualObjects(newBoundary.type, boundary.type);
        XCTAssertEqualObjects(newBoundary.parameter, boundary.parameter);
        XCTAssertTrue(newBoundary.min == boundary.min);
        XCTAssertTrue(newBoundary.max == boundary.max);
        [self.vlService deleteRuleWithId:newRule.ruleId onSuccess:^(NSHTTPURLResponse *response) {
            [expectedRules fulfill];
        } onFailure:^(NSError *error, NSHTTPURLResponse *response, NSString *bodyString) {
            [expectedRules fulfill];
        }];
    } onFailure:^(NSError *error, NSHTTPURLResponse *response, NSString *body) {
        XCTAssertTrue(NO);
        [expectedRules fulfill];
    }];
    
    [self waitForExpectationsWithTimeout:[VLTestHelper defaultTimeOut] handler:nil];
}

- (void)testCreateGeoSpatialRadiusRuleWithVehicleId {
    if(![VLTestHelper vehicleId]){
        XCTAssertTrue(NO);
        return;
    }
    
    XCTestExpectation *expectedRules = [self expectationWithDescription:@"rules service call"];
    VLRadiusBoundary *boundary = [[VLRadiusBoundary alloc] initWithRadius:50 latitude:[VLTestHelper getTestLatitude] longitude:[VLTestHelper getTestLongitude]];
    VLRule *rule = [[VLRule alloc] initWithName:@"TestRule" boundaries:@[boundary]];
    
    [self.vlService createRule:rule forVehicle:[VLTestHelper vehicleId] onSuccess:^(VLRule *newRule, NSHTTPURLResponse *response) {
        XCTAssertNotNil(newRule);
        XCTAssertTrue(newRule.ruleId != nil && [newRule.ruleId isKindOfClass:[NSString class]] && newRule.ruleId.length > 0);
        XCTAssertEqualObjects(newRule.vehicleId, [VLTestHelper vehicleId]);
        XCTAssertNil(newRule.deviceId);
        XCTAssertEqualObjects(rule.name, newRule.name);
        XCTAssertTrue(newRule.boundaries.count > 0);
        VLRadiusBoundary *newBoundary = newRule.boundaries.firstObject;
        XCTAssertEqualObjects(newBoundary.type, boundary.type);
        XCTAssertTrue(newBoundary.radius == boundary.radius);
        XCTAssertTrue(newBoundary.latitude == boundary.latitude);
        XCTAssertTrue(newBoundary.longitude == boundary.longitude);
        [self.vlService deleteRuleWithId:newRule.ruleId onSuccess:^(NSHTTPURLResponse *response) {
            [expectedRules fulfill];
        } onFailure:^(NSError *error, NSHTTPURLResponse *response, NSString *bodyString) {
            [expectedRules fulfill];
        }];
    } onFailure:^(NSError *error, NSHTTPURLResponse *response, NSString *body) {
        XCTAssertTrue(NO);
        [expectedRules fulfill];
    }];
    
    [self waitForExpectationsWithTimeout:[VLTestHelper defaultTimeOut] handler:nil];
}


- (void)testCreateGeoSpatialPolygonRuleWithVehicleId {
    if(![VLTestHelper vehicleId]){
        XCTAssertTrue(NO);
        return;
    }
    
    XCTestExpectation *expectedRules = [self expectationWithDescription:@"rules service call"];
    VLPolygonBoundary *boundary = [[VLPolygonBoundary alloc] initWithCoordinates:[VLTestHelper getPolygonGeometry]];
    VLRule *rule = [[VLRule alloc] initWithName:@"TestRule" boundaries:@[boundary]];
    
    [self.vlService createRule:rule forVehicle:[VLTestHelper vehicleId] onSuccess:^(VLRule *newRule, NSHTTPURLResponse *response) {
        XCTAssertNotNil(newRule);
        XCTAssertTrue(newRule.ruleId != nil && [newRule.ruleId isKindOfClass:[NSString class]] && newRule.ruleId.length > 0);
        XCTAssertEqualObjects(newRule.vehicleId, [VLTestHelper vehicleId]);
        XCTAssertNil(newRule.deviceId);
        XCTAssertEqualObjects(rule.name, newRule.name);
        XCTAssertTrue(newRule.boundaries.count > 0);
        VLPolygonBoundary *newBoundary = newRule.boundaries.firstObject;
        XCTAssertEqualObjects(newBoundary.type, boundary.type);
        XCTAssertEqual(newBoundary.coordinates.count, boundary.coordinates.count);
        [self.vlService deleteRuleWithId:newRule.ruleId onSuccess:^(NSHTTPURLResponse *response) {
            [expectedRules fulfill];
        } onFailure:^(NSError *error, NSHTTPURLResponse *response, NSString *bodyString) {
            [expectedRules fulfill];
        }];
    } onFailure:^(NSError *error, NSHTTPURLResponse *response, NSString *body) {
        XCTAssertTrue(NO);
        [expectedRules fulfill];
    }];
    
    [self waitForExpectationsWithTimeout:[VLTestHelper defaultTimeOut] handler:nil];
}

@end
