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
@property NSDictionary *devices;
@property VLDevice *device;
@property NSDictionary *trips;
@property NSString *tripId;
@property NSDictionary *vehicleTrips;





@end

@implementation VLTripsIntegrationTests

- (void)setUp {
    [super setUp];
    
    
    
    XCTestExpectation *expectation = [self expectationWithDescription:@"getting devices call"];
    [[VLSessionManager sharedManager].service startWithHost:[VLTestHelper accessToken] requestUri:@"https://platform.vin.li/api/v1/devices" onSuccess:^(NSDictionary *result, NSHTTPURLResponse *response) {
        [expectation fulfill];
        self.devices = result;
        XCTAssertTrue(YES);
    } onFailure:^(NSError *error, NSHTTPURLResponse *response, NSString *msg) {
        XCTAssertTrue(NO);
    } ];
    
    [self waitForExpectationsWithTimeout:[VLTestHelper defaultTimeOut] handler:nil];

    
    XCTestExpectation *deviceExpectation = [self expectationWithDescription:@"get devices with sessionManager"];
    [[VLSessionManager sharedManager].service getDevicesOnSuccess:^(VLDevicePager *devicePager, NSHTTPURLResponse *response) {
        [deviceExpectation fulfill];
        self.device = (devicePager.devices.count > 0) ? devicePager.devices[0] : nil;
        if (self.device) {
            XCTAssertTrue(YES);
        }
    } onFailure:^(NSError *error, NSHTTPURLResponse *response, NSString *bodyString) {
        XCTAssertTrue(NO);
    }];
    
    [self waitForExpectationsWithTimeout:[VLTestHelper defaultTimeOut] handler:nil];

    
    
    
    XCTestExpectation *expectationT = [self expectationWithDescription:@"call made to get device trips"];
    [[VLSessionManager sharedManager].service startWithHost:[VLTestHelper accessToken] requestUri:[NSString stringWithFormat:@"https://trips.vin.li/api/v1/devices/%@/trips", [VLTestHelper deviceId]] onSuccess:^(NSDictionary *result, NSHTTPURLResponse *response) {
        [expectationT fulfill];
        self.trips = result;
        XCTAssertTrue(YES);
    } onFailure:^(NSError *error, NSHTTPURLResponse *response, NSString *msg) {
        XCTAssertTrue(NO);
}];
    [self waitForExpectationsWithTimeout:[VLTestHelper defaultTimeOut] handler:nil];
    
    self.tripId = @"5ea04e77-d878-4775-8c3c-38eb966f349a";

    
    XCTestExpectation *vehicleTripExpectation = [self expectationWithDescription:@"call to get a vehicles trips"];
    [[VLSessionManager sharedManager].service startWithHost:[VLTestHelper accessToken] requestUri:[NSString stringWithFormat:@"https://trips.vin.li/api/v1/vehicles/%@/trips", [VLTestHelper vehicleId]] onSuccess:^(NSDictionary *result, NSHTTPURLResponse *response) {
        [vehicleTripExpectation fulfill];
        self.vehicleTrips = result;
        XCTAssertTrue(YES);
    } onFailure:^(NSError *error, NSHTTPURLResponse *response, NSString *msg) {
        XCTAssertTrue(NO);
    }];
    [self waitForExpectationsWithTimeout:[VLTestHelper defaultTimeOut] handler:nil];

}


- (void)testGetAllTripsWithDeviceId {
    NSDictionary *expectedJSON = self.trips;
    XCTestExpectation *tripsExpectation = [self expectationWithDescription:@"trips call"];
    [[VLSessionManager sharedManager].service getTripsForDeviceWithId:self.device.deviceId onSuccess:^(VLTripPager *tripPager, NSHTTPURLResponse *response) {
        [tripsExpectation fulfill];
        
        
        
        if (tripPager.trips.count == 0)
        {
            XCTAssertEqual(tripPager.priorURL, expectedJSON[@"meta"][@"pagination"][@"links"][@"prior"]);
            XCTAssertEqual(tripPager.nextURL, expectedJSON[@"meta"][@"pagination"][@"links"][@"next"]);
            
        }
        else
        {
        XCTAssertEqual(tripPager.trips.count, [expectedJSON[@"trips"] count]);
        //XCTAssertEqual(tripPager.total, [expectedJSON[@"meta"][@"pagination"][@"total"] unsignedLongValue]);
        XCTAssertEqualObjects(((VLTrip*)[tripPager.trips objectAtIndex:0]).tripId, expectedJSON[@"trips"][0][@"id"]);
        XCTAssertEqualObjects([tripPager.priorURL absoluteString], expectedJSON[@"meta"][@"pagination"][@"links"][@"prior"]);
        XCTAssertEqualObjects([tripPager.nextURL absoluteString], expectedJSON[@"meta"][@"pagination"][@"links"][@"next"]);
        //XCTAssertEqualObjects(tripPager.since, expectedJSON[@"meta"][@"pagination"][@"since"]);
       // XCTAssertEqualObjects(tripPager.until, expectedJSON[@"meta"][@"pagination"][@"until"]); //timeseries sensitive
        }
        
    } onFailure:^(NSError *error, NSHTTPURLResponse *response, NSString *bodyString) {
        XCTAssertTrue(NO);
    }];
    [self waitForExpectationsWithTimeout:[VLTestHelper defaultTimeOut] handler:nil];
}



- (void)testTripWithId {

    XCTestExpectation *singleExpectedTrip = [self expectationWithDescription:@"test service call for getting a single trip"];
    [[VLSessionManager sharedManager].service getTripWithId:self.tripId onSuccess:^(VLTrip *trip, NSHTTPURLResponse *response) {
        [singleExpectedTrip fulfill];
        XCTAssert(trip != nil);
        XCTAssert(trip.tripId != nil);
        XCTAssert(trip.selfURL != nil);
        
    } onFailure:^(NSError *error, NSHTTPURLResponse *response, NSString *bodyString) {
        XCTAssertTrue(NO);
    }];
    
    [self waitForExpectationsWithTimeout:[VLTestHelper defaultTimeOut] handler:nil];
}


- (void)testTripsWithVehicleId {
    NSDictionary *expectedJSON = self.vehicleTrips;
    XCTestExpectation *expectedVehicleTrips = [self expectationWithDescription:@"Service call for vehicle trips"];
    [[VLSessionManager sharedManager].service getTripsForVehicleWithId:[VLTestHelper vehicleId] onSuccess:^(VLTripPager *tripPager, NSHTTPURLResponse *response) {
        [expectedVehicleTrips fulfill];
        XCTAssertEqual(tripPager.trips.count, [expectedJSON[@"trips"] count]);
        //XCTAssertEqual(tripPager.total, [expectedJSON[@"meta"][@"pagination"][@"total"] unsignedLongValue]);
        XCTAssertEqualObjects(((VLTrip*)[tripPager.trips objectAtIndex:0]).tripId, expectedJSON[@"trips"][0][@"id"]);
        XCTAssertEqualObjects([tripPager.priorURL absoluteString], expectedJSON[@"meta"][@"pagination"][@"links"][@"prior"]);
        XCTAssertEqualObjects([tripPager.nextURL absoluteString], expectedJSON[@"meta"][@"pagination"][@"links"][@"next"]);
        XCTAssertEqualObjects(tripPager.since, expectedJSON[@"meta"][@"pagination"][@"since"]);
        // XCTAssertEqualObjects(tripPager.until, expectedJSON[@"meta"][@"pagination"][@"until"]); //timeseries sensitive
        
    } onFailure:^(NSError *error, NSHTTPURLResponse *response, NSString *bodyString) {
        XCTAssertTrue(NO);
    }];
    [self waitForExpectationsWithTimeout:[VLTestHelper defaultTimeOut] handler:nil];
}



- (void)tearDown {

    [super tearDown];
}





@end
