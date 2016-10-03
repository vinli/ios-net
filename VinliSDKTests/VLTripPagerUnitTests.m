//
//  VLTripPagerUnitTests.m
//  VinliSDK
//
//  Created by Bryan on 9/28/16.
//  Copyright © 2016 Vinli. All rights reserved.
//

#import <XCTest/XCTest.h>

#import <OCMock/OCMock.h>

#import "VLTestHelper.h"

#import "VLService.h"
#import "VLTripPager.h"

@interface VLTripPagerUnitTests : XCTestCase

@property (strong, nonatomic) NSDictionary *dictionary; // JSON Dict to initialize object
@property (strong, nonatomic) VLService *service;

@end

@implementation VLTripPagerUnitTests

#pragma mark - Class Methods

- (void)createDictionaryWithTrips:(NSArray *)trips
{
    NSMutableDictionary *mutableDict = [NSMutableDictionary new];
    if (trips)
    {
        [mutableDict setObject:trips forKey:@"trips"];
    }
    
    self.dictionary = mutableDict;
}

- (NSDictionary *)createInitialPagerDictionary
{
    NSMutableDictionary *mutableDict = [NSMutableDictionary new];
    [mutableDict setObject:[NSMutableArray new] forKey:@"trips"];
    [mutableDict[@"trips"] addObject:[NSDictionary new]];
     
    [mutableDict setObject:[NSMutableDictionary new] forKey:@"meta"];
    
    [mutableDict[@"meta"] setObject:[NSMutableDictionary new] forKey:@"pagination"];
    [mutableDict[@"meta"][@"pagination"] setObject:@1 forKey:@"limit"];
    [mutableDict[@"meta"][@"pagination"] setObject:@2 forKey:@"remaining"];
    [mutableDict[@"meta"][@"pagination"] setObject:[NSMutableDictionary new] forKey:@"links"];
    [mutableDict[@"meta"][@"pagination"][@"links"] setObject:@"https://initialPriorURL" forKey:@"prior"];
    [mutableDict[@"meta"][@"pagination"][@"links"] setObject:@"https://initialNextURL" forKey:@"next"];
    
    return mutableDict;
}

- (NSDictionary *)createNextPagerDictionary
{
    NSMutableDictionary *mutableDict = [NSMutableDictionary new];
    [mutableDict setObject:[NSMutableArray new] forKey:@"trips"];
    [mutableDict[@"trips"] addObject:[NSDictionary new]];
    
    [mutableDict setObject:[NSMutableDictionary new] forKey:@"meta"];
    
    [mutableDict[@"meta"] setObject:[NSMutableDictionary new] forKey:@"pagination"];
    [mutableDict[@"meta"][@"pagination"] setObject:@1 forKey:@"remaining"];
    [mutableDict[@"meta"][@"pagination"] setObject:[NSMutableDictionary new] forKey:@"links"];
    [mutableDict[@"meta"][@"pagination"][@"links"] setObject:@"https://nextPriorURL" forKey:@"prior"];
    [mutableDict[@"meta"][@"pagination"][@"links"] setObject:@"https://nextNextURL" forKey:@"next"];
    
    return mutableDict;
}

// This is the case where there are no next trips
- (NSDictionary *)createEmptyNextPagerDictionary
{
    NSMutableDictionary *mutableDict = [NSMutableDictionary new];
    [mutableDict setObject:[NSMutableArray new] forKey:@"trips"];
    
    [mutableDict setObject:[NSMutableDictionary new] forKey:@"meta"];
    [mutableDict[@"meta"] setObject:[NSMutableDictionary new] forKey:@"pagination"];
    [mutableDict[@"meta"][@"pagination"] setObject:@0 forKey:@"remaining"];
    [mutableDict[@"meta"][@"pagination"] setObject:[NSMutableDictionary new] forKey:@"links"];
    
    return mutableDict;
}

- (NSDictionary *)createZeroRemaingTripsPagerDictionaryWithLink
{
    NSMutableDictionary *mutableDict = [NSMutableDictionary new];
    [mutableDict setObject:[NSMutableArray new] forKey:@"trips"];
    
    [mutableDict setObject:[NSMutableDictionary new] forKey:@"meta"];
    [mutableDict[@"meta"] setObject:[NSMutableDictionary new] forKey:@"pagination"];
    [mutableDict[@"meta"][@"pagination"] setObject:@0 forKey:@"remaining"];
    [mutableDict[@"meta"][@"pagination"] setObject:[NSMutableDictionary new] forKey:@"links"];
    [mutableDict[@"meta"][@"pagination"][@"links"] setObject:@"https://nextPriorURL" forKey:@"prior"];
    
    return mutableDict;
}

- (NSDictionary *)createNullTripsJSONResponse
{
    NSMutableDictionary *mutableDict = [NSMutableDictionary new];
    [mutableDict setObject:[NSNull null] forKey:@"trips"];
    
    return mutableDict;
}

- (NSDictionary *)createTripsJSONResponseForNullKeyValueObjects
{
    NSMutableDictionary *mutableDict = [NSMutableDictionary new];
    [mutableDict setObject:[NSMutableArray new] forKey:@"trips"];
    
    [mutableDict setObject:[NSMutableDictionary new] forKey:@"meta"];

    [mutableDict[@"meta"] setObject:[NSMutableDictionary new] forKey:@"pagination"];
    [mutableDict[@"meta"][@"pagination"] setObject:[NSNull null] forKey:@"remaining"];
    [mutableDict[@"meta"][@"pagination"] setObject:[NSMutableDictionary new] forKey:@"links"];
    [mutableDict[@"meta"][@"pagination"][@"links"] setObject:[NSNull null] forKey:@"prior"];
    [mutableDict[@"meta"][@"pagination"][@"links"] setObject:[NSNull null] forKey:@"next"];
    
    return mutableDict;
}

#pragma mark - XCTestCase Methods

- (void)setUp
{
    [super setUp];
    
    if (!_service)
    {
        _service = [[VLService alloc] init];
        [_service useSession:[[VLSession alloc] initWithAccessToken:@"TEST"]];
    }
}

- (void)tearDown
{
    [super tearDown];
}

#pragma mark - InitWithDictionary Tests

- (void)testInitWithDictWithTrips
{
    [self createDictionaryWithTrips:@[]];
    VLTripPager *tripPager = [[VLTripPager alloc] initWithDictionary:self.dictionary];
    XCTAssertNil(tripPager.service , @"Service should be nil");
    XCTAssertNotNil(tripPager.trips, @"Trips shoud not be nil");
    XCTAssertEqual(tripPager.trips.count, [self.dictionary[@"trips"] count], @"Trips count should equal the number of trips passed in");
}

- (void)testInitWithDictWithoutTrips
{
    [self createDictionaryWithTrips:nil];
    VLTripPager *tripPager = [[VLTripPager alloc] initWithDictionary:self.dictionary];
    XCTAssertNil(tripPager.service , @"Service should be nil");
    XCTAssertEqual(tripPager.trips.count, 0, @"Trips shoud be zero when we do not pass in a dictionary");
}

#pragma mark - InitWithDictionary:AndService Tests

- (void)testInitWithDictAndServiceWithTrips
{
    [self createDictionaryWithTrips:@[]];
    VLTripPager *tripPager = [[VLTripPager alloc] initWithDictionary:self.dictionary service:self.service];
    XCTAssertNotNil(tripPager.service , @"Service should be nil");
    XCTAssertNotNil(tripPager.trips, @"Trips shoud not be nil");
    XCTAssertEqual(tripPager.trips.count, [self.dictionary[@"trips"] count], @"Trips count should equal the number of trips passed in");
}

- (void)testInitWithDictAndServiceWithoutTrips
{
    [self createDictionaryWithTrips:nil];
    VLTripPager *tripPager = [[VLTripPager alloc] initWithDictionary:self.dictionary service:self.service];
    XCTAssertNotNil(tripPager.service , @"Service should be nil");
    XCTAssertEqual(tripPager.trips.count, 0, @"Trips shoud be zero when we do not pass in a dictionary");
}

#pragma mark - getNextTrips Tests

- (void)testGetNextTripsOnSuccess
{
    id mockConnection = OCMPartialMock(self.service);
    
    NSDictionary *initialResponse = [self createInitialPagerDictionary];
    
    [[[mockConnection expect] andDo:^(NSInvocation *invocation) {
        NSDictionary *nextTripsResponse = [self createNextPagerDictionary];
        NSHTTPURLResponse *response = [[NSHTTPURLResponse alloc] initWithURL:[NSURL new] statusCode:200 HTTPVersion:nil headerFields:nil];
        
        void (^successBlock)(NSDictionary *result, NSHTTPURLResponse *response) = nil;
        [invocation getArgument:&successBlock atIndex:4];
        successBlock(nextTripsResponse, response);
        
    }] startWithHost:[OCMArg any] requestUri:[OCMArg any] onSuccess:[OCMArg any] onFailure:[OCMArg any]];
    
    VLTripPager *tripPager = [[VLTripPager alloc] initWithDictionary:initialResponse service:mockConnection];
    
    unsigned long copyRemaining = tripPager.remaining;
    NSURL *copyNextURL = tripPager.nextURL;
    NSURL *copyPriorURL = tripPager.priorURL;
    
    [tripPager getNextTrips:^(NSArray<VLTrip *> * _Nullable nextTrips, NSError * _Nullable error) {
       
        XCTAssertNil(error, @"Error should be nil");
        
        XCTAssertNotEqualObjects(copyNextURL.absoluteString, tripPager.nextURL.absoluteString, @"nextURL should have been updated to grab the next set of trips.");
        XCTAssertNotEqualObjects(copyPriorURL.absoluteString, tripPager.priorURL.absoluteString, @"priorURL should have been updated to grab the next set of trips.");
        XCTAssertGreaterThanOrEqual(copyRemaining, tripPager.remaining, @"The remaining property should be decreasing with each pagination.");
        
        XCTAssertNotNil(nextTrips, @"nextTrips should exist.");
        XCTAssertLessThanOrEqual(nextTrips.count, tripPager.limit, @"The number of nextTrips returned back should be less than or equal to pager limit.");
        XCTAssertGreaterThanOrEqual(nextTrips.count, 0, @"The number of nextTrips should always be at least zero.");
        
        BOOL containsEachTrip = YES;
        for (VLTrip *aTrip in nextTrips)
        {
            if (![tripPager.trips containsObject:aTrip])
            {
                containsEachTrip = NO;
                break;
            }
        }
        
        XCTAssertTrue(containsEachTrip, @"Each VLTrip returned in nextTrips should be in the VLTripPager's trips array.");
        
    }];
}

// This is when there are zero remaining trips
- (void)testGetEmptyNextTripsOnSuccess
{
    id mockConnection = OCMPartialMock(self.service);
    
    NSDictionary *initialResponse = [self createInitialPagerDictionary];
    
    [[[mockConnection expect] andDo:^(NSInvocation *invocation) {
        NSDictionary *nextTripsResponse = [self createEmptyNextPagerDictionary];
        NSHTTPURLResponse *response = [[NSHTTPURLResponse alloc] initWithURL:[NSURL new] statusCode:200 HTTPVersion:nil headerFields:nil];
        
        void (^successBlock)(NSDictionary *result, NSHTTPURLResponse *response) = nil;
        [invocation getArgument:&successBlock atIndex:4];
        successBlock(nextTripsResponse, response);
        
    }] startWithHost:[OCMArg any] requestUri:[OCMArg any] onSuccess:[OCMArg any] onFailure:[OCMArg any]];
    
    VLTripPager *tripPager = [[VLTripPager alloc] initWithDictionary:initialResponse service:mockConnection];
    
    [tripPager getNextTrips:^(NSArray<VLTrip *> * _Nullable nextTrips, NSError * _Nullable error) {
        
        XCTAssertNil(error, @"Error should be nil");
        
        XCTAssertNotNil(nextTrips, @"nextTrips should exist.");
        
        XCTAssertEqual(nextTrips.count, 0, @"Since there are no remaining trips nextTrips should be zero.");
        XCTAssertEqual(tripPager.remaining, 0, @"There should be zero remaining trips.");
        
        XCTAssertNil(tripPager.nextURL, @"Since there are no remaining trips, then we should expect links dictionary to be empty since there is no new link to get more trips.");
        XCTAssertNil(tripPager.priorURL, @"Since there are no remaining trips, then we should expect links dictionary to be empty since there is no new link to get more trips.");
    }];
}

- (void)testGetNextTripsWithZeroRemainingAndPriorURLOnSuccess
{
    id mockConnection = OCMPartialMock(self.service);
    
    NSDictionary *initialResponse = [self createZeroRemaingTripsPagerDictionaryWithLink];
    
    VLTripPager *tripPager = [[VLTripPager alloc] initWithDictionary:initialResponse service:mockConnection];
    
    NSURL *copyNextURL = tripPager.nextURL;
    NSURL *copyPriorURL = tripPager.priorURL;
    
    [tripPager getNextTrips:^(NSArray<VLTrip *> * _Nullable nextTrips, NSError * _Nullable error) {
        
        XCTAssertNotNil(error, @"Error should not be nil");
        XCTAssertEqual(error.code, NSURLErrorUnknown, @"The error codes should equal eachother in order to explain the error.");

        XCTAssertNil(nextTrips, @"nextTrips should not exist.");
        
        if (copyPriorURL.absoluteString.length > 0)
        {
            XCTAssertNotNil(tripPager.priorURL, @"Since there are no remaining trips, then we should expect links dictionary to be empty since there is no new link to get more trips. However, there shoudld be an error if there is this one exists.");
        }
        
        if (copyNextURL.absoluteString.length > 0)
        {
            XCTAssertNotNil(tripPager.nextURL, @"Since there are no remaining trips, then we should expect links dictionary to be empty since there is no new link to get more trips. However, there shoudld be an error if there is this one exists.");
        }
        
    }];
}

- (void)testGetNextTripsWithZeroRemainingOnSuccess
{
    id mockConnection = OCMPartialMock(self.service);
    
    NSDictionary *initialResponse = [self createEmptyNextPagerDictionary];
    
    VLTripPager *tripPager = [[VLTripPager alloc] initWithDictionary:initialResponse service:mockConnection];
    
    [tripPager getNextTrips:^(NSArray<VLTrip *> * _Nullable nextTrips, NSError * _Nullable error) {
        
        XCTAssertNil(error, @"Error should be nil");
        
        XCTAssertNotNil(nextTrips, @"nextTrips should exist.");
        
        XCTAssertEqual(nextTrips.count, 0, @"Since there are no remaining trips nextTrips should be zero.");
        XCTAssertEqual(tripPager.remaining, 0, @"There should be zero remaining trips.");
        
        XCTAssertNil(tripPager.nextURL, @"Since there are no remaining trips, then we should expect links dictionary to be empty since there is no new link to get more trips.");
        XCTAssertNil(tripPager.priorURL, @"Since there are no remaining trips, then we should expect links dictionary to be empty since there is no new link to get more trips.");
    }];
}

- (void)testGetNextTripsOnFailure
{
    id mockConnection = OCMPartialMock(self.service);
    
    NSDictionary *initialResponse = [self createInitialPagerDictionary];
    
    [[[mockConnection expect] andDo:^(NSInvocation *invocation) {
        NSHTTPURLResponse *response = [[NSHTTPURLResponse alloc] initWithURL:[NSURL new] statusCode:400 HTTPVersion:nil headerFields:nil];
        
        NSError *error = [[NSError alloc] initWithDomain:NSURLErrorDomain code:NSURLErrorBadURL userInfo:nil];
        void (^failureBlock)(NSError *error, NSHTTPURLResponse *response) = nil;
        [invocation getArgument:&failureBlock atIndex:5];
        failureBlock(error, response);
        
    }] startWithHost:[OCMArg any] requestUri:[OCMArg any] onSuccess:[OCMArg any] onFailure:[OCMArg any]];
    
    VLTripPager *tripPager = [[VLTripPager alloc] initWithDictionary:initialResponse service:mockConnection];
    
    [tripPager getNextTrips:^(NSArray<VLTrip *> * _Nullable nextTrips, NSError * _Nullable error) {
        
        XCTAssertNotNil(error, @"Error should not be nil");
        
        XCTAssertNil(nextTrips, @"nextTrips should not exist.");
    }];
}

- (void)testGetNextTripsWithoutVLService
{
    VLTripPager *pager = [[VLTripPager alloc] initWithDictionary:nil service:nil];
    
    [pager getNextTrips:^(NSArray<VLTrip *> * _Nullable nextTrips, NSError * _Nullable error) {
        
        XCTAssertNil(nextTrips);
        XCTAssertNotNil(error);
        XCTAssertEqual(error.code, NSURLErrorUserAuthenticationRequired);
        
    }];
}

#pragma mark - Null tests

- (void)testForNullTrips
{
    VLTripPager *tripPager = [[VLTripPager alloc] initWithDictionary:[self createNullTripsJSONResponse]];
    
    XCTAssertEqual(tripPager.trips.count, 0, @"When we get a null value of trips back, we return an empty array");
}

// This is when there are null key value objects
- (void)testForNullKeyValueObjects
{
    id mockConnection = OCMPartialMock(self.service);
    
    NSDictionary *initialResponse = [self createInitialPagerDictionary];
    
    [[[mockConnection expect] andDo:^(NSInvocation *invocation) {
        NSDictionary *nextTripsResponse = [self createTripsJSONResponseForNullKeyValueObjects];
        NSHTTPURLResponse *response = [[NSHTTPURLResponse alloc] initWithURL:[NSURL new] statusCode:200 HTTPVersion:nil headerFields:nil];
        
        void (^successBlock)(NSDictionary *result, NSHTTPURLResponse *response) = nil;
        [invocation getArgument:&successBlock atIndex:4];
        successBlock(nextTripsResponse, response);
        
    }] startWithHost:[OCMArg any] requestUri:[OCMArg any] onSuccess:[OCMArg any] onFailure:[OCMArg any]];
    
    VLTripPager *tripPager = [[VLTripPager alloc] initWithDictionary:initialResponse service:mockConnection];
    
    [tripPager getNextTrips:^(NSArray<VLTrip *> * _Nullable nextTrips, NSError * _Nullable error) {
        
        XCTAssertNil(error, @"Error should be nil");
        
        XCTAssertNotNil(nextTrips, @"nextTrips should exist.");
        
        XCTAssertEqual(nextTrips.count, 0, @"Since there are no remaining trips nextTrips should be zero.");
        XCTAssertEqual(tripPager.remaining, 0, @"There should be zero remaining trips.");
        
        XCTAssertNil(tripPager.nextURL, @"Since there are no remaining trips, then we should expect links dictionary to be empty since there is no new link to get more trips.");
        XCTAssertNil(tripPager.priorURL, @"Since there are no remaining trips, then we should expect links dictionary to be empty since there is no new link to get more trips.");
    }];
}
@end
