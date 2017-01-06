//
//  VLDiagnosticIntegrationTests.m
//  VinliSDK
//
//  Created by Tommy Brown on 9/22/16.
//  Copyright © 2016 Vinli. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "VLService.h"
#import "VLTestHelper.h"

@interface VLDiagnosticIntegrationTests : XCTestCase

@property VLService *vlService;

@end

@implementation VLDiagnosticIntegrationTests

- (void)setUp {
    [super setUp];
    _vlService = [VLTestHelper vlService];
}

- (void)tearDown {
    [super tearDown];
}

- (void)testGetCurrentBatteryStatusWithVehicleId
{
    if(![VLTestHelper vehicleId])
    {
        XCTAssertTrue(NO);
        return;
    }
    
    XCTestExpectation *expectedDevices = [self expectationWithDescription:@"getting the battery status"];
    [_vlService getCurrentBatteryStatusWithVehicleId:[VLTestHelper vehicleId] onSuccess:^(VLBatteryStatus *batteryStatus, NSHTTPURLResponse *response) {
        
        if(batteryStatus) {
            XCTAssertTrue(batteryStatus.status == VLBatteryStatusColorGreen || batteryStatus.status == VLBatteryStatusColorYellow || batteryStatus.status == VLBatteryStatusColorRed);
            XCTAssertTrue(batteryStatus.timestamp != nil && batteryStatus.timestamp.length > 0);
        }
        
        [expectedDevices fulfill];
    } onFailure:^(NSError *error, NSHTTPURLResponse *response, NSString *bodyString) {
        XCTAssertTrue(NO);
        [expectedDevices fulfill];
    }];
    
    [self waitForExpectationsWithTimeout:[VLTestHelper defaultTimeOut] handler:nil];
}

#pragma mark - Codes

- (void)validateCode:(VLCode *)code pid:(NSString *)pid {
    XCTAssertNotNil(code);
    XCTAssertNotNil(code.codeId);
    XCTAssertNotNil(code.make);
    XCTAssertNotNil(code.system);
    //XCTAssertNotNil(code.subSystem);
    if (code.twoByte && code.threeByte) {
        XCTAssertEqualObjects(code.twoByte[@"number"], pid);
        XCTAssertEqualObjects(code.threeByte[@"number"], pid);
    }
    else if (code.twoByte) {
        XCTAssertEqualObjects(code.twoByte[@"number"], pid);
    }
    else if (code.threeByte) {
         XCTAssertEqualObjects(code.threeByte[@"number"], pid);
    }
    else {
        XCTAssertEqualObjects(code.pid, pid);
    }
}

- (void)validateDtc: (VLDtc *)dtc {
    XCTAssertNotNil(dtc);
    XCTAssertNotNil(dtc.codeId);
    XCTAssertNotNil(dtc.vehicleId);
    XCTAssertNotNil(dtc.deviceId);
    XCTAssertNotNil(dtc.pid);
    XCTAssertNotNil(dtc.codeDescription);
    XCTAssertNotNil(dtc.startTimeStr);
    XCTAssertNotNil(dtc.stopTimeStr);
    XCTAssertNotNil(dtc.startTime);
    XCTAssertNotNil(dtc.stopTime);
}

- (void)testGetCodesWithPID {
    NSString* pid = @"P0001";
    
    XCTestExpectation *expectation = [self expectationWithDescription:@"getting codes with pid"];
    [self.vlService getCodesWithPID:pid limit:nil offset:nil onSuccess:^(VLCodePager *codePager, NSHTTPURLResponse *response) {
        XCTAssertNotNil(codePager);
        XCTAssertTrue(codePager.codes.count > 0);
        for (VLCode *code in codePager.codes) {
            [self validateCode:code pid:pid];
        }
        [expectation fulfill];
    } onFailure:^(NSError *error, NSHTTPURLResponse *response, NSString *bodyString) {
        XCTAssertTrue(NO);
        [expectation fulfill];
    }];
    
    [self waitForExpectationsWithTimeout:[VLTestHelper defaultTimeOut] handler:nil];
}

- (void)testGetCodeWithId {
    NSString* pid = @"P0001";
    NSString *codeId = @"2db60bc5-0548-43ee-91c0-c34d59ce71ce";
    XCTestExpectation *expectation = [self expectationWithDescription:@"getting code with id"];
    [self.vlService getCodeWithId:codeId onSuccess:^(VLCode *code, NSHTTPURLResponse *response) {
        XCTAssertNotNil(code);
        [self validateCode:code pid:pid];
        XCTAssertEqualObjects(code.codeId, codeId);
        [expectation fulfill];
    } onFailure:^(NSError *error, NSHTTPURLResponse *response, NSString *bodyString) {
        XCTAssertTrue(NO);
        [expectation fulfill];
    }];

    [self waitForExpectationsWithTimeout:[VLTestHelper defaultTimeOut] handler:nil];

}

- (void)testGetDtcsForVehicle {
    
    if(![VLTestHelper vehicleId])
    {
        XCTAssertTrue(NO);
        return;
    }
    
    XCTestExpectation *expectation = [self expectationWithDescription:@"getting dtcs for vehicle"];
    [self.vlService getDtcsForVehicleWithId:[VLTestHelper vehicleId] timeSeries:[VLTimeSeries new] onSuccess:^(VLDtcPager *dtcPager, NSHTTPURLResponse *response) {
        XCTAssertNotNil(dtcPager);
        XCTAssertTrue(dtcPager.codes.count == 2);
        
        for (VLDtc *dtc in dtcPager.codes) {
            [self validateDtc:dtc];
            XCTAssertEqualObjects(dtc.vehicleId, [VLTestHelper vehicleId]);
        }
        [expectation fulfill];
    } onFailure:^(NSError *error, NSHTTPURLResponse *response, NSString *bodyString) {
        XCTAssertTrue(NO);
        [expectation fulfill];
    }];
    [self waitForExpectationsWithTimeout:[VLTestHelper defaultTimeOut] handler:nil];
}

@end
