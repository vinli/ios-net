//
//  VLTripPagerIntegrationTests.m
//  VinliSDK
//
//  Created by Bryan on 9/30/16.
//  Copyright © 2016 Vinli. All rights reserved.
//

#import <XCTest/XCTest.h>

#import "VLTripPager.h"

#import "VLService.h"

#import "VLTestHelper.h"

@interface VLTripPagerIntegrationTests : XCTestCase

@property (strong, nonatomic) VLService *service;

@property (strong, nonatomic) VLTripPager *tripPager;

@end

@implementation VLTripPagerIntegrationTests

- (void)setUp
{
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
    
    if (!_service)
    {
        _service = [VLTestHelper vlService];
    }
}

- (void)tearDown
{
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

#pragma mark - Tests With Service

- (void)testGetNextSetOfTripsWhereTimeSeriesOrderIsDescending
{
    XCTestExpectation *tripsExpectation = [self expectationWithDescription:@"Create Trip Pagination and get next set of trips in default sort order, descending."];

    if (!_tripPager)
    {
        [self.service getTripsForDeviceWithId:[VLTestHelper deviceId] timeSeries:nil onSuccess:^(VLTripPager *tripPager, NSHTTPURLResponse *response) {
            
            if (tripPager)
            {
                _tripPager = tripPager;
                
                XCTAssertNil(self.tripPager.nextURL, @"We expect nextURL to be nil because if we pass a nil time series then the back end will default to a time series where the order of trips coming back will be descending and will only have a priorURL.");
                
                unsigned long copyRemaining = self.tripPager.remaining;
                NSURL *copyPriorURL = self.tripPager.priorURL;
                
                [self.tripPager getNextTrips:^(NSArray<VLTrip *> * _Nullable nextTrips, NSError * _Nullable error) {
                    
                    if (error)
                    {
                        XCTAssertTrue(NO, @"this test should never fail");
                        [tripsExpectation fulfill];
                        return;
                    }
                    
                    XCTAssertNil(error, @"Error should be nil");
                    
                    XCTAssertNil(self.tripPager.nextURL, @"We expect nextURL to be nil because the initial VLTripPager call should only allow us to get a priorURL since its order is set to the default, descending.");

                    if (copyPriorURL)
                    {
                        XCTAssertNotEqualObjects(copyPriorURL.absoluteString, self.tripPager.priorURL.absoluteString, @"priorURL should have been updated to grab the next set of trips.");
                    }
                    
                    XCTAssertGreaterThanOrEqual(copyRemaining, self.tripPager.remaining, @"The remaining property should be decreasing with each pagination.");
                    
                    XCTAssertNotNil(nextTrips, @"nextTrips should exist.");
                    XCTAssertLessThanOrEqual(nextTrips.count, self.tripPager.limit, @"The number of nextTrips returned back should be less than or equal to pager limit.");
                    XCTAssertGreaterThanOrEqual(nextTrips.count, 0, @"The number of nextTrips should always be at least zero.");
                    
                    BOOL containsEachTrip = YES;
                    for (VLTrip *aTrip in nextTrips)
                    {
                        if (![self.tripPager.trips containsObject:aTrip])
                        {
                            containsEachTrip = NO;
                            break;
                        }
                    }
                    
                    XCTAssertTrue(containsEachTrip, @"Each VLTrip returned in nextTrips should be in the VLTripPager's trips array.");
                    [tripsExpectation fulfill];
                    
                }];
                

            }
            
        } onFailure:^(NSError *error, NSHTTPURLResponse *response, NSString *bodyString) {
            
            // Handle error case?
            NSLog(@"");
            
        }];
    }
    
    [self waitForExpectationsWithTimeout:[VLTestHelper defaultTimeOut] handler:nil];

}

- (void)testGetNextSetOfTripsWhereTimeSeriesOrderIsAscending
{
    XCTestExpectation *tripsExpectation = [self expectationWithDescription:@"Create Trip Pagination and get next set of trips in default sort order, descending."];
    
    if (!_tripPager)
    {
        VLTimeSeries *timeSeries = [VLTimeSeries timeSeriesFromPreviousNumberOfWeeks:12];
        timeSeries.sortOrder = VLTimerSeriesSortDirectionAscending;
        [self.service getTripsForDeviceWithId:[VLTestHelper deviceId] timeSeries:timeSeries onSuccess:^(VLTripPager *tripPager, NSHTTPURLResponse *response) {
            
            if (tripPager)
            {
                _tripPager = tripPager;
                
                XCTAssertNil(self.tripPager.priorURL, @"We expect priorURL to be nil because if we pass a nil time series then the back end will default to a time series where the order of trips coming back will be ascending and will only have a nextURL.");
                
                unsigned long copyRemaining = self.tripPager.remaining;
                NSURL *copyNextURL = self.tripPager.nextURL;
                
                [self.tripPager getNextTrips:^(NSArray<VLTrip *> * _Nullable nextTrips, NSError * _Nullable error) {
                    
                    if (error)
                    {
                        XCTAssertTrue(NO, @"this test should never fail");
                        [tripsExpectation fulfill];
                        return;
                    }
                    
                    XCTAssertNil(self.tripPager.priorURL, @"We expect priorURL to be nil because the initial VLTripPager call should only allow us to get a nextURL since its order is set ascending.");
                    
                    XCTAssertNil(error, @"Error should be nil");
                    if (copyNextURL)
                    {
                        XCTAssertNotEqualObjects(copyNextURL.absoluteString, self.tripPager.nextURL.absoluteString, @"nextURL should have been updated to grab the next set of trips.");
                    }
                    
                    XCTAssertGreaterThanOrEqual(copyRemaining, self.tripPager.remaining, @"The remaining property should be decreasing with each pagination.");
                    
                    XCTAssertNotNil(nextTrips, @"nextTrips should exist.");
                    XCTAssertLessThanOrEqual(nextTrips.count, self.tripPager.limit, @"The number of nextTrips returned back should be less than or equal to pager limit.");
                    XCTAssertGreaterThanOrEqual(nextTrips.count, 0, @"The number of nextTrips should always be at least zero.");
                    
                    BOOL containsEachTrip = YES;
                    for (VLTrip *aTrip in nextTrips)
                    {
                        if (![self.tripPager.trips containsObject:aTrip])
                        {
                            containsEachTrip = NO;
                            break;
                        }
                    }
                    
                    XCTAssertTrue(containsEachTrip, @"Each VLTrip returned in nextTrips should be in the VLTripPager's trips array.");
                    [tripsExpectation fulfill];
                    
                }];
                
                
            }
            
        } onFailure:^(NSError *error, NSHTTPURLResponse *response, NSString *bodyString) {
            
            // Handle error case?
            NSLog(@"");
            
        }];
    }
    
    [self waitForExpectationsWithTimeout:[VLTestHelper defaultTimeOut] handler:nil];
    
}

#pragma mark - Tests without Service
 
- (void)testGetNextSetOfTripsWithoutVLService
{
    VLTripPager *pager = [[VLTripPager alloc] init];
    
    [pager getNextTrips:^(NSArray<VLTrip *> * _Nullable nextTrips, NSError * _Nullable error) {
       
        XCTAssertNil(nextTrips, @"nextTrips should be nil becasue you not make a request without a VLService");
        XCTAssertNotNil(error, @"Error should explain that one needs a VLService in order to get next trips.");
        XCTAssertEqual(error.code, NSURLErrorUserAuthenticationRequired, @"The error codes should equal eachother in order to explain the error.");
        
    }];
}

- (void)testSomething {
    XCTestExpectation *tripsExpectation = [self expectationWithDescription:@"Create Trip Pagination and get next set of trips in default sort order, descending."];
    VLTimeSeries *timeSeries = [VLTimeSeries timeSeries];
    timeSeries.sortOrder = VLTimerSeriesSortDirectionAscending;
    timeSeries.limit = @(1);
    [self.service getTripsForDeviceWithId:[VLTestHelper deviceId] timeSeries:timeSeries onSuccess:^(VLTripPager *tripPager, NSHTTPURLResponse *response) {
        NSLog(@"Trip pager %@ \n\nURL = %@", tripPager.trips, tripPager.nextURL);
        [tripPager getNext:^(NSArray *newValues, NSError *error) {
            XCTAssertTrue(YES);
             NSLog(@"Trip pager %@ \n\nURL = %@", tripPager.trips, tripPager.nextURL);
            [tripsExpectation fulfill];
        }];
    } onFailure:^(NSError *error, NSHTTPURLResponse *response, NSString *bodyString) {
        XCTAssertTrue(NO);
        [tripsExpectation fulfill];
    }];
    

    [self waitForExpectationsWithTimeout:20 handler:nil];
}

@end
