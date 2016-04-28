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
@property NSDictionary *trips;
@property NSDictionary *trip;
@property NSDictionary *vehicleTrips;





@end

@implementation VLTripsIntegrationTests

- (void)setUp {
    [super setUp];
    
    
    
    XCTestExpectation *expectationT = [self expectationWithDescription:@"call made to get device trips"];
    [[VLSessionManager sharedManager].service startWithHost:[VLTestHelper accessToken] requestUri:[NSString stringWithFormat:@"https://trips.vin.li/api/v1/devices/%@/trips", [VLTestHelper deviceId]] onSuccess:^(NSDictionary *result, NSHTTPURLResponse *response) {
        [expectationT fulfill];
        self.trips = result;
        XCTAssertTrue(YES);
    } onFailure:^(NSError *error, NSHTTPURLResponse *response, NSString *msg) {
        XCTAssertTrue(NO);
}];
    [self waitForExpectationsWithTimeout:[VLTestHelper defaultTimeOut] handler:nil];
    
    XCTestExpectation *singleTripExpectation = [self expectationWithDescription:@"uri call for single trip"];
    [[VLSessionManager sharedManager].service startWithHost:[VLTestHelper accessToken] requestUri:[NSString stringWithFormat:@"https://trips.vin.li/api/v1/trips/%@", [VLTestHelper tripId]] onSuccess:^(NSDictionary *result, NSHTTPURLResponse *response) {
        [singleTripExpectation fulfill];
        self.trip = result;
    } onFailure:^(NSError *error, NSHTTPURLResponse *response, NSString *msg) {
        XCTAssertTrue(NO);
    }];
    
    [self waitForExpectationsWithTimeout:[VLTestHelper defaultTimeOut] handler:nil];
    
    
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
    [[VLSessionManager sharedManager].service getTripsForDeviceWithId:[VLTestHelper deviceId] onSuccess:^(VLTripPager *tripPager, NSHTTPURLResponse *response) {
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
    NSDictionary *expectedJSON = [VLTestHelper cleanDictionary:self.trip[@"trip"]];
    XCTestExpectation *singleExpectedTrip = [self expectationWithDescription:@"test service call for getting a single trip"];
    [[VLSessionManager sharedManager].service getTripWithId:[VLTestHelper tripId] onSuccess:^(VLTrip *trip, NSHTTPURLResponse *response) {
        [singleExpectedTrip fulfill];
        XCTAssertEqualObjects(trip.tripId, expectedJSON[@"id"]);
        XCTAssertEqualObjects(trip.start, expectedJSON[@"start"]);
        XCTAssertEqualObjects([VLDateFormatter stringFromDate:[trip startDate]], expectedJSON[@"start"]);
        XCTAssertEqualObjects(trip.stop, expectedJSON[@"stop"]);
        XCTAssertEqualObjects([VLDateFormatter stringFromDate:[trip stopDate]], expectedJSON[@"stop"]);
        XCTAssertEqualObjects(trip.status, expectedJSON[@"status"]);
        
        
        

       
        
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
