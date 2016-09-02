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
    NSDictionary *expectedJSON = [VLTestHelper getAllTripsJSON:@"2ad86caa-5a30-429e-80b8-80bc3da5efe6"];
    
    if(![VLTestHelper deviceId]){
        XCTAssertTrue(NO);
        return;
    }
    
    XCTestExpectation *tripsExpectation = [self expectationWithDescription:@"trips call"];
    [_vlService getTripsForDeviceWithId:[VLTestHelper deviceId] onSuccess:^(VLTripPager *tripPager, NSHTTPURLResponse *response) {
        if (tripPager.trips.count == 0){
            XCTAssertEqual(tripPager.priorURL, expectedJSON[@"meta"][@"pagination"][@"links"][@"prior"]);
            XCTAssertEqual(tripPager.nextURL, expectedJSON[@"meta"][@"pagination"][@"links"][@"next"]);
        }else {
            XCTAssertEqual(tripPager.trips.count, [expectedJSON[@"trips"] count]);
            //XCTAssertEqual(tripPager.total, [expectedJSON[@"meta"][@"pagination"][@"total"] unsignedLongValue]);
            XCTAssertEqualObjects(((VLTrip*)[tripPager.trips objectAtIndex:0]).tripId, expectedJSON[@"trips"][0][@"id"]);
            XCTAssertEqualObjects([tripPager.priorURL absoluteString], expectedJSON[@"meta"][@"pagination"][@"links"][@"prior"]);
            XCTAssertEqualObjects([tripPager.nextURL absoluteString], expectedJSON[@"meta"][@"pagination"][@"links"][@"next"]);
            //XCTAssertEqualObjects(tripPager.since, expectedJSON[@"meta"][@"pagination"][@"since"]);
            // XCTAssertEqualObjects(tripPager.until, expectedJSON[@"meta"][@"pagination"][@"until"]); //timeseries sensitive
        }
        [tripsExpectation fulfill];
    } onFailure:^(NSError *error, NSHTTPURLResponse *response, NSString *bodyString) {
        XCTAssertTrue(NO);
        [tripsExpectation fulfill];
    }];
    
    [self waitForExpectationsWithTimeout:[VLTestHelper defaultTimeOut] handler:nil];
}

- (void)testTripWithId {
    NSDictionary *expectedJSON = [VLTestHelper getTripJSON:@"2ad86caa-5a30-429e-80b8-80bc3da5efe6"];
    
    if(![VLTestHelper tripId]){
        XCTAssertTrue(NO);
        return;
    }
    
    XCTestExpectation *singleExpectedTrip = [self expectationWithDescription:@"test service call for getting a single trip"];
    [_vlService getTripWithId:[VLTestHelper tripId] onSuccess:^(VLTrip *trip, NSHTTPURLResponse *response) {
        XCTAssertEqualObjects(trip.tripId, expectedJSON[@"id"]);
        XCTAssertEqualObjects(trip.start, expectedJSON[@"start"]);
        XCTAssertEqualObjects([VLDateFormatter stringFromDate:[trip startDate]], expectedJSON[@"start"]);
        XCTAssertEqualObjects(trip.stop, expectedJSON[@"stop"]);
        XCTAssertEqualObjects([VLDateFormatter stringFromDate:[trip stopDate]], expectedJSON[@"stop"]);
        XCTAssertEqualObjects(trip.status, expectedJSON[@"status"]);
        [singleExpectedTrip fulfill];
    } onFailure:^(NSError *error, NSHTTPURLResponse *response, NSString *bodyString) {
        XCTAssertTrue(NO);
        [singleExpectedTrip fulfill];
    }];
    
    [self waitForExpectationsWithTimeout:[VLTestHelper defaultTimeOut] handler:nil];
}

- (void)testTripsWithVehicleId {
    NSDictionary *expectedJSON = [VLTestHelper getAllTripsJSON:@"2ad86caa-5a30-429e-80b8-80bc3da5efe6"];
    
    if(![VLTestHelper vehicleId]){
        XCTAssertTrue(NO);
        return;
    }
    
    XCTestExpectation *expectedVehicleTrips = [self expectationWithDescription:@"Service call for vehicle trips"];
    [_vlService getTripsForVehicleWithId:[VLTestHelper vehicleId] onSuccess:^(VLTripPager *tripPager, NSHTTPURLResponse *response) {
        XCTAssertEqual(tripPager.trips.count, [expectedJSON[@"trips"] count]);
        //XCTAssertEqual(tripPager.total, [expectedJSON[@"meta"][@"pagination"][@"total"] unsignedLongValue]);
        XCTAssertEqualObjects(((VLTrip*)[tripPager.trips objectAtIndex:0]).tripId, expectedJSON[@"trips"][0][@"id"]);
        XCTAssertEqualObjects([tripPager.priorURL absoluteString], expectedJSON[@"meta"][@"pagination"][@"links"][@"prior"]);
        XCTAssertEqualObjects([tripPager.nextURL absoluteString], expectedJSON[@"meta"][@"pagination"][@"links"][@"next"]);
        XCTAssertEqualObjects(tripPager.since, expectedJSON[@"meta"][@"pagination"][@"since"]);
        // XCTAssertEqualObjects(tripPager.until, expectedJSON[@"meta"][@"pagination"][@"until"]); //timeseries sensitive
        [expectedVehicleTrips fulfill];
    } onFailure:^(NSError *error, NSHTTPURLResponse *response, NSString *bodyString) {
        XCTAssertTrue(NO);
        [expectedVehicleTrips fulfill];
    }];
    
    [self waitForExpectationsWithTimeout:[VLTestHelper defaultTimeOut] handler:nil];
}

@end
