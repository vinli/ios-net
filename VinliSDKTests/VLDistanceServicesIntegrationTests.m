//
//  VLDistanceServicesIntegrationTests.m
//  VinliSDK
//
//  Created by Jai Ghanekar on 3/11/16.
//  Copyright © 2016 Vinli. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "VLTestHelper.h"
#import "VLService.h"
#import "VLSessionManager.h"
#import "VLDistance.h"
#import "VLDistancePager.h"
#import "NSHTTPURLResponse+VLAdditions.h"

@interface VLDistanceServicesIntegrationTests : XCTestCase

@property VLService *vlService;

@end

@implementation VLDistanceServicesIntegrationTests

#pragma mark - XCTestCase

- (void)setUp
{
    [super setUp];
    
    _vlService = [VLTestHelper vlService];
}

- (void)tearDown
{
    [super tearDown];
}

#pragma mark - VLService Tests

- (void)testGetDistancesForVehicleWithId
{
    if(![VLTestHelper vehicleId])
    {
        XCTAssertTrue(NO);
        return;
    }
    
    XCTestExpectation *distancesExpected = [self expectationWithDescription:@"service call distances"];
    [_vlService getDistancesForVehicleWithId:[VLTestHelper vehicleId] onSuccess:^(VLDistancePager *distancePager, NSHTTPURLResponse *response) {
        XCTAssertTrue(distancePager.distances.count > 0);
        
        for(VLDistance *distance in distancePager.distances)
        {
            XCTAssertTrue(distance.confidenceMin != nil && [distance.confidenceMin isKindOfClass:[NSNumber class]]);
            XCTAssertTrue(distance.confidenceMax != nil && [distance.confidenceMax isKindOfClass:[NSNumber class]]);
            XCTAssertTrue(distance.value != nil && [distance.value isKindOfClass:[NSNumber class]]);
            XCTAssertTrue(distance.lastOdometer != nil && [distance.lastOdometer isKindOfClass:[NSString class]] && distance.lastOdometer.length > 0);
        }
        
        [distancesExpected fulfill];
        
    } onFailure:^(NSError *error, NSHTTPURLResponse *response, NSString *bodyString) {
        XCTAssertTrue(NO);
        [distancesExpected fulfill];
    }];
    
    [self waitForExpectationsWithTimeout:[VLTestHelper defaultTimeOut] handler:nil];
}

- (void)testGetOdometersForVehicleId
{
    if(![VLTestHelper vehicleId])
    {
        XCTFail(@"There is no vehicleId in Scheme Enviornment Variables");
        return;
    }
    
    XCTestExpectation *expectedOdometers = [self expectationWithDescription:@"Service Call to odometers"];
    
    NSString *currentDateStr = [VLDateFormatter stringFromDate:[[NSDate date] dateByAddingTimeInterval:-1000.0f]];
    VLOdometer *odometerParameter = [[VLOdometer alloc] initWithReading:@1 dateStr:currentDateStr unit:VLDistanceUnitMiles];
    [self.vlService createOdometer:odometerParameter vehicleId:[VLTestHelper vehicleId] OnSuccess:^(VLOdometer *createdOdometer, NSHTTPURLResponse *response) {
        
        [self.vlService getOdometersForVehicleWithId:[VLTestHelper vehicleId] onSuccess:^(VLOdometerPager *odometerPager, NSHTTPURLResponse *response) {
            
            XCTAssertTrue(odometerPager.odometers.count > 0);
            XCTAssertTrue(odometerPager.since != nil && [odometerPager.since isKindOfClass:[NSString class]] && odometerPager.since.length > 0);
            XCTAssertTrue(odometerPager.until != nil && [odometerPager.until isKindOfClass:[NSString class]] && odometerPager.until.length > 0);
            
            for (VLOdometer *odometer in odometerPager.odometers)
            {
                XCTAssertTrue(odometer.odometerId != nil && [odometer.odometerId isKindOfClass:[NSString class]] && odometer.odometerId.length > 0);
                XCTAssertTrue(odometer.vehicleId != nil && [odometer.vehicleId isKindOfClass:[NSString class]] && odometer.vehicleId.length > 0);
                XCTAssertTrue(odometer.reading != nil && [odometer.reading isKindOfClass:[NSNumber class]]);
                XCTAssertTrue(odometer.dateStr != nil && [odometer.dateStr isKindOfClass:[NSString class]] && odometer.dateStr.length > 0);
            }
            
            // Need to delete Odometer after we create it
            if (createdOdometer.odometerId.length > 0)
            {
                [self.vlService deleteOdometerWithId:createdOdometer.odometerId onSuccess:^(NSHTTPURLResponse *response) {
                    
                    [expectedOdometers fulfill];
                    
                } onFailure:^(NSError *error, NSHTTPURLResponse *response, NSString *bodyString) {
                    
                    XCTFail(@"Failed to delete the odoemter: %@ that was created.", createdOdometer.odometerId);
                    [expectedOdometers fulfill];
                    
                }];
            }
            
        } onFailure:^(NSError *error, NSHTTPURLResponse *response, NSString *bodyString) {
            
            XCTFail(@"Failed to get Odometer by odometerId: %@", createdOdometer.odometerId);
            
            // Need to delete Odometer after we create it
            if (createdOdometer.odometerId.length > 0)
            {
                [self.vlService deleteOdometerWithId:createdOdometer.odometerId onSuccess:^(NSHTTPURLResponse *response) {
                    
                    [expectedOdometers fulfill];
                    
                } onFailure:^(NSError *error, NSHTTPURLResponse *response, NSString *bodyString) {
                    
                    XCTFail(@"Failed to delete the odoemter: %@ that was created.", createdOdometer.odometerId);
                    [expectedOdometers fulfill];
                    
                }];
            }
        }];

        
    } onFailure:^(NSError *error, NSHTTPURLResponse *response, NSString *bodyString) {
        
        XCTFail(@"Failed to create Odoemter for testing testGetOdometerWithId");
        [expectedOdometers fulfill];
        
    }];
    
    
    [self waitForExpectationsWithTimeout:[VLTestHelper defaultTimeOut] handler:nil];
}

- (void)testGetOdometerWithId
{
    if(![VLTestHelper vehicleId])
    {
        XCTFail(@"There is no vehicleId in Scheme Enviornment Variables");
        return;
    }
    
    XCTestExpectation *odometerExpected = [self expectationWithDescription:@"Service call for odometer"];
    
    NSString *currentDateStr = [VLDateFormatter stringFromDate:[[NSDate date] dateByAddingTimeInterval:-1000.0f]];
    VLOdometer *odometerParameter = [[VLOdometer alloc] initWithReading:@1 dateStr:currentDateStr unit:VLDistanceUnitMiles];
    
    [self.vlService createOdometer:odometerParameter vehicleId:[VLTestHelper vehicleId] OnSuccess:^(VLOdometer *createdOdometer, NSHTTPURLResponse *response) {
        
        [self.vlService getOdometerWithId:createdOdometer.odometerId onSuccess:^(VLOdometer *odometer, NSHTTPURLResponse *response) {
            
            XCTAssertTrue(odometer.odometerId != nil && [odometer.odometerId isKindOfClass:[NSString class]] && odometer.odometerId.length > 0);
            XCTAssertTrue(odometer.vehicleId != nil && [odometer.vehicleId isKindOfClass:[NSString class]] && odometer.vehicleId.length > 0);
            XCTAssertTrue(odometer.reading != nil && [odometer.reading isKindOfClass:[NSNumber class]]);
            XCTAssertTrue(odometer.dateStr != nil && [odometer.dateStr isKindOfClass:[NSString class]] && odometer.dateStr.length > 0);
            
            // Need to delete Odometer after we create it
            if (createdOdometer.odometerId.length > 0)
            {
                [self.vlService deleteOdometerWithId:createdOdometer.odometerId onSuccess:^(NSHTTPURLResponse *response) {
                    
                    [odometerExpected fulfill];
                    
                } onFailure:^(NSError *error, NSHTTPURLResponse *response, NSString *bodyString) {
                    
                    XCTFail(@"Failed to delete the odoemter: %@ that was created.", createdOdometer.odometerId);
                    [odometerExpected fulfill];
                    
                }];
            }
            
        } onFailure:^(NSError *error, NSHTTPURLResponse *response, NSString *bodyString) {
            
            XCTFail(@"Failed to get Odometer by odometerId: %@", createdOdometer.odometerId);
            
            // Need to delete Odometer after we create it
            if (createdOdometer.odometerId.length > 0)
            {
                [self.vlService deleteOdometerWithId:createdOdometer.odometerId onSuccess:^(NSHTTPURLResponse *response) {
                    
                    [odometerExpected fulfill];
                    
                } onFailure:^(NSError *error, NSHTTPURLResponse *response, NSString *bodyString) {
                    
                    XCTFail(@"Failed to delete the odoemter: %@ that was created.", createdOdometer.odometerId);
                    [odometerExpected fulfill];
                    
                }];
            }
        }];

    } onFailure:^(NSError *error, NSHTTPURLResponse *response, NSString *bodyString) {
       
        XCTFail(@"Failed to create Odoemter for testing testGetOdometerWithId");
        [odometerExpected fulfill];
        
    }];
    
    
    [self waitForExpectationsWithTimeout:[VLTestHelper defaultTimeOut] handler:nil];
}

- (void)testGetOdometerTriggerForVehicleWithId
{
    if(![VLTestHelper vehicleId])
    {
        XCTAssertTrue(NO);
        return;
    }
    
    XCTestExpectation *odometerTriggersExpected = [self expectationWithDescription:@"expectedOdometerPagers"];
    [_vlService getOdometerTriggersForVehicleWithId:[VLTestHelper vehicleId] onSucess:^(VLOdometerTriggerPager *odometerTriggerPager, NSHTTPURLResponse *response) {
        XCTAssertTrue(odometerTriggerPager.odometerTriggers.count > 0);
        XCTAssertTrue(odometerTriggerPager.since != nil && [odometerTriggerPager.since isKindOfClass:[NSString class]] && odometerTriggerPager.since.length > 0);
        XCTAssertTrue(odometerTriggerPager.until != nil && [odometerTriggerPager.until isKindOfClass:[NSString class]] && odometerTriggerPager.until.length > 0);
        
        for(VLOdometerTrigger *odometerTrigger in odometerTriggerPager.odometerTriggers){
            XCTAssertTrue(odometerTrigger.odometerTriggerId != nil && [odometerTrigger.odometerTriggerId isKindOfClass:[NSString class]] && odometerTrigger.odometerTriggerId.length > 0);
            XCTAssertTrue(odometerTrigger.vehicleId != nil && [odometerTrigger.vehicleId isKindOfClass:[NSString class]] && odometerTrigger.vehicleId.length > 0);
            XCTAssertTrue(odometerTrigger.threshold != nil && [odometerTrigger.threshold isKindOfClass:[NSNumber class]]);
        }
        [odometerTriggersExpected fulfill];
    } onFailure:^(NSError *error, NSHTTPURLResponse *response, NSString *bodyString) {
        XCTAssertTrue(NO);
        [odometerTriggersExpected fulfill];
    }];
    
    [self waitForExpectationsWithTimeout:[VLTestHelper defaultTimeOut] handler:nil];
}

- (void)testGetOdometerTriggerWithId
{
    if(![VLTestHelper odometerTriggerId])
    {
        XCTAssertTrue(NO);
        return;
    }
    
    XCTestExpectation *odometerTriggerExpected = [self expectationWithDescription:@"service call to odometertrigger"];
    [_vlService getOdometerTriggerWithId:[VLTestHelper odometerTriggerId] onSuccess:^(VLOdometerTrigger *odometerTrigger, NSHTTPURLResponse *response) {
        XCTAssertTrue(odometerTrigger.odometerTriggerId != nil && [odometerTrigger.odometerTriggerId isKindOfClass:[NSString class]] && odometerTrigger.odometerTriggerId.length > 0);
        XCTAssertTrue(odometerTrigger.vehicleId != nil && [odometerTrigger.vehicleId isKindOfClass:[NSString class]] && odometerTrigger.vehicleId.length > 0);
        XCTAssertTrue(odometerTrigger.threshold != nil && [odometerTrigger.threshold isKindOfClass:[NSNumber class]]);
        [odometerTriggerExpected fulfill];
    } onFailure:^(NSError *error, NSHTTPURLResponse *response, NSString *bodyString) {
         XCTAssertTrue(NO);
        [odometerTriggerExpected fulfill];
    }];
    
    [self waitForExpectationsWithTimeout:[VLTestHelper defaultTimeOut] handler:nil];
}

- (void)testCreateOdometerWithVehicleId
{
    if(![VLTestHelper vehicleId])
    {
        XCTAssertTrue(NO);
        return;
    }
    
    __block NSString *retOdometerId;
    __block NSNumber *highestCurrentReading;
    
    XCTestExpectation *odometerCreationExpected = [self expectationWithDescription:@"expectedOdometerPagers"];
    NSString *currentDateStr = [VLDateFormatter stringFromDate:[[NSDate date] dateByAddingTimeInterval:-10.0f]];

    [self.vlService getOdometersForVehicleWithId:[VLTestHelper vehicleId] onSuccess:^(VLOdometerPager *odometerPager, NSHTTPURLResponse *response) {
        
        highestCurrentReading = [(VLOdometer *)odometerPager.odometers.firstObject reading] ? [NSNumber numberWithDouble:([(VLOdometer *)odometerPager.odometers.firstObject reading].doubleValue + 1)] : @1;
        
        VLDistanceUnit unit = [(VLOdometer *)odometerPager.odometers.firstObject reading] ? [(VLOdometer *)odometerPager.odometers.firstObject distanceUnit] : VLDistanceUnitMiles;
        VLOdometer *odometerParameter = [[VLOdometer alloc] initWithReading:highestCurrentReading dateStr:currentDateStr unit:unit];
        
        [self.vlService createOdometer:odometerParameter vehicleId:[VLTestHelper vehicleId] OnSuccess:^(VLOdometer *odometer, NSHTTPURLResponse *response) {
            
            XCTAssertTrue([response isSuccessfulResponse], @"We expect that the status code of response will be a 200.");
            XCTAssertNotNil(odometer, @"Odometer should exist.");
            XCTAssertTrue(odometer.odometerId.length > 0, @"Odometer Id should not be nil and should have a value");
            XCTAssertTrue(odometer.vehicleId.length > 0, @"Vehicle Id should not be nil and should have a value.");
            XCTAssertNotNil(odometer.reading, @"Reading should exist.");
            XCTAssertTrue(odometer.dateStr.length > 0, @"Date string should not be nil and should have a value.");
            
            // Need to delete Odometer after we create it
            retOdometerId = odometer.odometerId;
            
            if (retOdometerId.length > 0)
            {
                [self.vlService deleteOdometerWithId:retOdometerId onSuccess:^(NSHTTPURLResponse *response) {
                    
                    [odometerCreationExpected fulfill];

                } onFailure:^(NSError *error, NSHTTPURLResponse *response, NSString *bodyString) {
                    
                    [odometerCreationExpected fulfill];

                }];
            }
            
        } onFailure:^(NSError *error, NSHTTPURLResponse *response, NSString *bodyString) {
            
            XCTAssertTrue(NO);
            [odometerCreationExpected fulfill];
            
        }];

        
    } onFailure:^(NSError *error, NSHTTPURLResponse *response, NSString *bodyString) {
        
        XCTAssertTrue(NO);
        [odometerCreationExpected fulfill];
        
    }];
    
    [self waitForExpectationsWithTimeout:[VLTestHelper defaultTimeOut] handler:nil];
}

@end
