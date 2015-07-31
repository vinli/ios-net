//
//  VLTripServicesTests.m
//  VinliSDK
//
//  Created by Tommy Brown on 5/26/15.
//  Copyright (c) 2015 Vinli. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>
#import <OCMock/OCMock.h>
#import "VLService.h"
#import "VLTestHelper.h"

@interface VLTripServicesTests : XCTestCase{
    VLService *connection;
    NSString *deviceId;
    NSString *tripId;
    NSString *vehicleId;
}
@end

@implementation VLTripServicesTests

- (void)setUp {
    [super setUp];
    connection = [[VLService alloc] init];
    [connection useSession:[[VLSession alloc] initWithAccessToken:@"TEST"]];
    
    deviceId = @"11111111-2222-3333-4444-555555555555";
    tripId = @"11111111-2222-3333-4444-555555555555";
    vehicleId = @"11111111-2222-3333-4444-555555555555";
}

- (void)tearDown {
    [super tearDown];
}

- (void)testGetAllTripsForDeviceWithId{
    id mockConnection = OCMPartialMock(connection);
    
    NSDictionary *expectedJSON = [VLTestHelper getAllTripsJSON:deviceId];
    
    [[[mockConnection expect] andDo:^(NSInvocation *invocation) {
        NSDictionary *trip = [expectedJSON copy];
        NSHTTPURLResponse *response = [[NSHTTPURLResponse alloc] initWithURL:nil statusCode:200 HTTPVersion:nil headerFields:nil];
        
        void (^successBlock)(NSDictionary *result, NSHTTPURLResponse *response) = nil;
        [invocation getArgument:&successBlock atIndex:8];
        successBlock(trip, response);
        
    }] startWithHost:[OCMArg any] path:[OCMArg any] queries:[OCMArg any] HTTPMethod:[OCMArg any] parameters:[OCMArg any] token:[OCMArg any] onSuccess:[OCMArg any] onFailure:[OCMArg any]];
    
    [connection getTripsForDeviceWithId:deviceId onSuccess:^(VLTripPager *tripPager, NSHTTPURLResponse *response) {
        
        XCTAssertEqual(tripPager.trips.count, [expectedJSON[@"trips"] count]); // Make sure that there are two objects in the array.
        //XCTAssertEqual(tripPager.total, [expectedJSON[@"meta"][@"pagination"][@"total"] unsignedLongValue]); // Make sure that the Meta more or less translated correctly.
        XCTAssertEqual(((VLTrip*)[tripPager.trips objectAtIndex:0]).tripId, expectedJSON[@"trips"][0][@"id"]); // Make sure that the trips array more or less translated correctly
        
        
    } onFailure:^(NSError *error, NSHTTPURLResponse *response, NSString *bodyString) {
        XCTAssertTrue(NO);
    }];
}

- (void)testGetTripsForVehicleWithId{
    id mockConnection = OCMPartialMock(connection);
    
    NSDictionary *expectedJSON = [VLTestHelper getAllTripsJSON:deviceId];
    
    [[[mockConnection expect] andDo:^(NSInvocation *invocation) {
        NSDictionary *trip = [expectedJSON copy];
        NSHTTPURLResponse *response = [[NSHTTPURLResponse alloc] initWithURL:nil statusCode:200 HTTPVersion:nil headerFields:nil];
        
        void (^successBlock)(NSDictionary *result, NSHTTPURLResponse *response) = nil;
        [invocation getArgument:&successBlock atIndex:8];
        successBlock(trip, response);
        
    }] startWithHost:[OCMArg any] path:[OCMArg any] queries:[OCMArg any] HTTPMethod:[OCMArg any] parameters:[OCMArg any] token:[OCMArg any] onSuccess:[OCMArg any] onFailure:[OCMArg any]];
    
    [connection getTripsForVehicleWithId:vehicleId onSuccess:^(VLTripPager *tripPager, NSHTTPURLResponse *response) {
        
        XCTAssertEqual(tripPager.trips.count, [expectedJSON[@"trips"] count]); // Make sure that there are two objects in the array.
        //XCTAssertEqual(tripPager.total, [expectedJSON[@"meta"][@"pagination"][@"total"] unsignedLongValue]); // Make sure that the Meta more or less translated correctly.
        XCTAssertEqual(((VLTrip*)[tripPager.trips objectAtIndex:0]).tripId, expectedJSON[@"trips"][0][@"id"]); // Make sure that the trips array more or less translated correctly
        
    } onFailure:^(NSError *error, NSHTTPURLResponse *response, NSString *bodyString) {
        XCTAssertTrue(NO);
    }];
}

- (void)testGetSpecificTripWithId{
    id mockConnection = OCMPartialMock(connection);
    
    NSDictionary *expectedJSON = [VLTestHelper getTripJSON:tripId];
    
    [[[mockConnection expect] andDo:^(NSInvocation *invocation) {
        
        NSDictionary *trip = [expectedJSON copy];
        
        NSHTTPURLResponse *response = [[NSHTTPURLResponse alloc] initWithURL:nil statusCode:200 HTTPVersion:nil headerFields:nil];
        
        void (^successBlock)(NSDictionary *result, NSHTTPURLResponse *response) = nil;
        
        [invocation getArgument:&successBlock atIndex:8];
        
        successBlock(trip, response);
        
    }] startWithHost:[OCMArg any] path:[OCMArg any] queries:[OCMArg any] HTTPMethod:[OCMArg any] parameters:[OCMArg any] token:[OCMArg any] onSuccess:[OCMArg any] onFailure:[OCMArg any]];
    
    [connection getTripWithId:tripId onSuccess:^(VLTrip *trip, NSHTTPURLResponse *response) {
        
        XCTAssert(trip != nil);
        XCTAssert(trip.tripId != nil);
        XCTAssert(trip.selfURL != nil);
        
    } onFailure:^(NSError *error, NSHTTPURLResponse *response, NSString *bodyString) {
        XCTAssert(NO);
    }];
}



@end
