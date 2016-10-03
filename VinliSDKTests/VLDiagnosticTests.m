//
//  VLDiagnosticTests.m
//  VinliSDK
//
//  Created by Tommy Brown on 9/22/16.
//  Copyright © 2016 Vinli. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "VLService.h"
#import "VLTestHelper.h"
#import <OCMock/OCMock.h>

@interface VLDiagnosticTests : XCTestCase

@property (strong, nonatomic) VLService *vlService;

@end

@implementation VLDiagnosticTests

- (void)setUp {
    [super setUp];
    
    _vlService = [[VLService alloc] init];
    [_vlService useSession:[[VLSession alloc] initWithAccessToken:@"TEST"]];
}

- (void)tearDown {
    [super tearDown];
}

- (void) testGetCurrentBatteryStatus{
    id mockConnection = OCMPartialMock(_vlService);
    
    NSDictionary *expectedJSON = [VLTestHelper getBatteryStatusJSON];
    
    [[[mockConnection expect] andDo:^(NSInvocation *invocation) {
        
        NSDictionary *batteryStatus = [expectedJSON copy];
        
        NSHTTPURLResponse *response = [[NSHTTPURLResponse alloc] initWithURL:[NSURL  new] statusCode:200 HTTPVersion:nil headerFields:nil];
        
        void (^successBlock)(NSDictionary *result, NSHTTPURLResponse *response) = nil;
        
        [invocation getArgument:&successBlock atIndex:8];
        
        successBlock(batteryStatus, response);
        
    }] startWithHost:[OCMArg any] path:[OCMArg any] queries:[OCMArg any] HTTPMethod:[OCMArg any] parameters:[OCMArg any] token:[OCMArg any] onSuccess:[OCMArg any] onFailure:[OCMArg any]];
    
    [_vlService getCurrentBatteryStatusWithVehicleId:@"some uuid" onSuccess:^(VLBatteryStatus *batteryStatus, NSHTTPURLResponse *response) {
        XCTAssert(batteryStatus.status == VLBatteryStatusColorGreen);
        XCTAssert(batteryStatus.timestamp == expectedJSON[@"batteryStatus"][@"timestamp"]);
    } onFailure:^(NSError *error, NSHTTPURLResponse *response, NSString *bodyString) {
        XCTAssert(NO);
    }];
}

@end
