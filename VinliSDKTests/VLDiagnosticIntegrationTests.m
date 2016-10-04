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
        
        if(batteryStatus)
        {
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

@end
