//
//  VLAuthServicesTests.m
//  VinliSDK
//
//  Created by Tommy Brown on 5/28/15.
//  Copyright (c) 2015 Vinli. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>
#import "VLService.h"
#import <OCMock/OCMock.h>
#import "VLTestHelper.h"

@interface VLAuthServicesTests : XCTestCase{
    VLService *service;
}
@end

@implementation VLAuthServicesTests

- (void)setUp {
    [super setUp];
    service = [[VLService alloc] init];
    [service useSession:[[VLSession alloc] initWithAccessToken:@"TEST"]];
}

- (void)tearDown {
    [super tearDown];
}

- (void) testGetUser{
    id mockConnection = OCMPartialMock(service);
    
    NSDictionary *expectedJSON = [VLTestHelper getUserJSON];
    
    [[[mockConnection expect] andDo:^(NSInvocation *invocation) {
        
        NSDictionary *user = [expectedJSON copy];
        
        NSHTTPURLResponse *response = [[NSHTTPURLResponse alloc] initWithURL:nil statusCode:200 HTTPVersion:nil headerFields:nil];
        
        void (^successBlock)(NSDictionary *result, NSHTTPURLResponse *response) = nil;
        
        [invocation getArgument:&successBlock atIndex:8];
        
        successBlock(user, response);
        
    }] startWithHost:[OCMArg any] path:[OCMArg any] queries:[OCMArg any] HTTPMethod:[OCMArg any] parameters:[OCMArg any] token:[OCMArg any] onSuccess:[OCMArg any] onFailure:[OCMArg any]];
    
    [service getUserOnSuccess:^(VLUser *user, NSHTTPURLResponse *response) {
        
        XCTAssertEqual(user.userId, expectedJSON[@"user"][@"id"]);
        XCTAssertEqual(user.firstName, nil);
        
    } onFailure:^(NSError *error, NSHTTPURLResponse *response, NSString *bodyString) {
        XCTAssertTrue(NO);
    }];
}

- (void) testGetAllDevicesForUser{
    id mockConnection = OCMPartialMock(service);
    
    NSDictionary *expectedJSON = [VLTestHelper getUserDevicesJSON];
    
    [[[mockConnection expect] andDo:^(NSInvocation *invocation) {
        
        NSDictionary *devices = [expectedJSON copy];
        
        NSHTTPURLResponse *response = [[NSHTTPURLResponse alloc] initWithURL:nil statusCode:200 HTTPVersion:nil headerFields:nil];
        
        void (^successBlock)(NSDictionary *result, NSHTTPURLResponse *response) = nil;
        
        [invocation getArgument:&successBlock atIndex:8];
        
        successBlock(devices, response);
        
    }] startWithHost:[OCMArg any] path:[OCMArg any] queries:[OCMArg any] HTTPMethod:[OCMArg any] parameters:[OCMArg any] token:[OCMArg any] onSuccess:[OCMArg any] onFailure:[OCMArg any]];
    
    [service getDevicesForUserOnSuccess:^(NSArray *deviceArray, NSHTTPURLResponse *response) {
        
        XCTAssertEqual(deviceArray.count, [expectedJSON[@"devices"] count]);
        
        XCTAssertEqual([[deviceArray objectAtIndex:0] deviceId], expectedJSON[@"devices"][0][@"id"]);
        
        XCTAssertEqual([[deviceArray objectAtIndex:0] selfURL].absoluteString, expectedJSON[@"devices"][0][@"links"][@"self"]);
        
    } onFailure:^(NSError *error, NSHTTPURLResponse *response, NSString *bodyString) {
        XCTAssertTrue(NO);
    }];
}

@end
