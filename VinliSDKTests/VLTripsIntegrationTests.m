//
//  VLTripsIntegrationTests.m
//  VinliSDK
//
//  Created by Jai Ghanekar on 3/1/16.
//  Copyright © 2016 Vinli. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "VLSessionManager.h"
#import "VLService.h"
#import "VLDevice.h"
#import "VLTestHelper.h"


@interface VLTripsIntegrationTests : XCTestCase

@property VLService *vlService;

@end

@implementation VLTripsIntegrationTests

- (void)setUp {
    [super setUp];
    
    _vlService = [VLTestHelper vlService];
}

- (void)tearDown {
    [super tearDown];
}

- (void)testGetAllTripsWithDeviceId {
    if(![VLTestHelper deviceId]){
        XCTAssertTrue(NO);
        return;
    }
    
    XCTestExpectation *tripsExpectation = [self expectationWithDescription:@"trips call"];
    [_vlService getTripsForDeviceWithId:[VLTestHelper deviceId] onSuccess:^(VLTripPager *tripPager, NSHTTPURLResponse *response) {
        XCTAssertTrue(tripPager.trips.count > 0);
        XCTAssertTrue(tripPager.since != nil && [tripPager.since isKindOfClass:[NSString class]] && tripPager.since.length > 0);
        XCTAssertTrue(tripPager.until != nil && [tripPager.until isKindOfClass:[NSString class]] && tripPager.until.length > 0);
        
        for(VLTrip *trip in tripPager.trips){
            XCTAssertTrue(trip.tripId != nil && [trip.tripId isKindOfClass:[NSString class]] && trip.tripId.length > 0);
            XCTAssertTrue(trip.start != nil && [trip.start isKindOfClass:[NSString class]] && trip.start.length > 0);
            XCTAssertTrue(trip.stop != nil && [trip.stop isKindOfClass:[NSString class]] && trip.stop.length > 0);
            XCTAssertTrue(trip.vehicleId != nil && [trip.vehicleId isKindOfClass:[NSString class]] && trip.vehicleId.length > 0);
            XCTAssertTrue(trip.deviceId != nil && [trip.deviceId isKindOfClass:[NSString class]] && trip.deviceId.length > 0);
        }
        
        [tripsExpectation fulfill];
    } onFailure:^(NSError *error, NSHTTPURLResponse *response, NSString *bodyString) {
        XCTAssertTrue(NO);
        [tripsExpectation fulfill];
    }];
    
    [self waitForExpectationsWithTimeout:[VLTestHelper defaultTimeOut] handler:nil];
}

- (void)testTripWithId {
    if(![VLTestHelper tripId]){
        XCTAssertTrue(NO);
        return;
    }
    
    XCTestExpectation *singleExpectedTrip = [self expectationWithDescription:@"test service call for getting a single trip"];
    [_vlService getTripWithId:[VLTestHelper tripId] onSuccess:^(VLTrip *trip, NSHTTPURLResponse *response) {
        XCTAssertTrue(trip.tripId != nil && [trip.tripId isKindOfClass:[NSString class]] && trip.tripId.length > 0);
        XCTAssertTrue(trip.start != nil && [trip.start isKindOfClass:[NSString class]] && trip.start.length > 0);
        XCTAssertTrue(trip.stop != nil && [trip.stop isKindOfClass:[NSString class]] && trip.stop.length > 0);
        XCTAssertTrue(trip.vehicleId != nil && [trip.vehicleId isKindOfClass:[NSString class]] && trip.vehicleId.length > 0);
        XCTAssertTrue(trip.deviceId != nil && [trip.deviceId isKindOfClass:[NSString class]] && trip.deviceId.length > 0);
        [singleExpectedTrip fulfill];
    } onFailure:^(NSError *error, NSHTTPURLResponse *response, NSString *bodyString) {
        XCTAssertTrue(NO);
        [singleExpectedTrip fulfill];
    }];
    
    [self waitForExpectationsWithTimeout:[VLTestHelper defaultTimeOut] handler:nil];
}

- (void)testTripsWithVehicleId {
    if(![VLTestHelper vehicleId]){
        XCTAssertTrue(NO);
        return;
    }
    
    XCTestExpectation *expectedVehicleTrips = [self expectationWithDescription:@"Service call for vehicle trips"];
    [_vlService getTripsForVehicleWithId:[VLTestHelper vehicleId] onSuccess:^(VLTripPager *tripPager, NSHTTPURLResponse *response) {
        XCTAssertTrue(tripPager.trips.count > 0);
        XCTAssertTrue(tripPager.since != nil && [tripPager.since isKindOfClass:[NSString class]] && tripPager.since.length > 0);
        XCTAssertTrue(tripPager.until != nil && [tripPager.until isKindOfClass:[NSString class]] && tripPager.until.length > 0);
        
        for(VLTrip *trip in tripPager.trips){
            XCTAssertTrue(trip.tripId != nil && [trip.tripId isKindOfClass:[NSString class]] && trip.tripId.length > 0);
            XCTAssertTrue(trip.start != nil && [trip.start isKindOfClass:[NSString class]] && trip.start.length > 0);
            XCTAssertTrue(trip.stop != nil && [trip.stop isKindOfClass:[NSString class]] && trip.stop.length > 0);
            XCTAssertTrue(trip.vehicleId != nil && [trip.vehicleId isKindOfClass:[NSString class]] && trip.vehicleId.length > 0);
            XCTAssertTrue(trip.deviceId != nil && [trip.deviceId isKindOfClass:[NSString class]] && trip.deviceId.length > 0);
        }
        [expectedVehicleTrips fulfill];
    } onFailure:^(NSError *error, NSHTTPURLResponse *response, NSString *bodyString) {
        XCTAssertTrue(NO);
        [expectedVehicleTrips fulfill];
    }];
    
    [self waitForExpectationsWithTimeout:[VLTestHelper defaultTimeOut] handler:nil];
}

@end
