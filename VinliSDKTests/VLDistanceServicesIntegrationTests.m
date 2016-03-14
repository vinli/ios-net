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


@interface VLDistanceServicesIntegrationTests : XCTestCase
@property NSDictionary *distances;
@end

@implementation VLDistanceServicesIntegrationTests

- (void)setUp {
    [super setUp];
    
    XCTestExpectation *expectationDistances = [self expectationWithDescription:@"URI call to get vehicle distances"];
    [[VLSessionManager sharedManager].service startWithHost:[VLTestHelper accessToken] requestUri:[NSString stringWithFormat:@"https://distance.vin.li/api/v1/vehicles/%@/distances", [VLTestHelper vehicleId]] onSuccess:^(NSDictionary *result, NSHTTPURLResponse *response) {
        [expectationDistances fulfill];
        self.distances = result;
    } onFailure:^(NSError *error, NSHTTPURLResponse *response, NSString *msg) {
        XCTAssertTrue(NO);
    }];
    
    [self waitForExpectationsWithTimeout:[VLTestHelper defaultTimeOut] handler:nil];

    
    
}


- (void)testGetDistancesForVehicleWithId {
    NSDictionary *expectedJSON = [VLTestHelper cleanDictionary:self.distances];
    XCTestExpectation *distancesExpected = [self expectationWithDescription:@"service call distances"];
    [[VLSessionManager sharedManager].service getDistancesForVehicleWithId:[VLTestHelper vehicleId] onSuccess:^(VLDistancePager *distancePager, NSHTTPURLResponse *response) {
        [distancesExpected fulfill];
        XCTAssertEqual(distancePager.distances.count, [expectedJSON[@"distances"] count]);
        VLDistance *distance = (distancePager.distances.count > 0) ? distancePager.distances[0] : nil;
        
        if (distance) {
           NSDictionary *expectedDistanceJson = [VLTestHelper cleanDictionary:expectedJSON[@"distances"][0]];
            
            
            
            
            XCTAssertEqualObjects(distance.confidenceMax, expectedDistanceJson[@"confidenceMax"]);
            XCTAssertEqual(distance.confidenceMin, expectedDistanceJson[@"confidenceMin"]);
            XCTAssertEqualObjects(distance.lastOdometerDate, expectedDistanceJson[@"lastOdometerDate"]);
            XCTAssertEqualObjects([distance.value stringValue], [expectedDistanceJson[@"value"] stringValue]);
            
        }
        
        
        
    } onFailure:^(NSError *error, NSHTTPURLResponse *response, NSString *bodyString) {
        XCTAssertTrue(NO);
    }];
    
    [self waitForExpectationsWithTimeout:[VLTestHelper defaultTimeOut] handler:nil];
}





- (void)tearDown {
    [super tearDown];
}



@end
