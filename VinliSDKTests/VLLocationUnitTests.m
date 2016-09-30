//
//  VLLocationUnitTests.m
//  VinliSDK
//
//  Created by Bryan on 9/28/16.
//  Copyright © 2016 Vinli. All rights reserved.
//

#import <XCTest/XCTest.h>

#import "VLLocation.h"

@interface VLLocationUnitTests : XCTestCase

@property (strong, nonatomic) NSDictionary *dictionary; // JSON Dict to initialize object

@end

@implementation VLLocationUnitTests

#pragma mark - XCTestCase

- (void)setUp
{
    [super setUp];
}

- (void)tearDown
{
    [super tearDown];
}

#pragma mark - Class Methods

- (void)createDictionaryWithLocationType:(NSString *)locationType geometryType:(NSString *)geometryType longitude:(NSNumber *)longitude latitude:(NSNumber *)latitude properties:(NSDictionary *)properties
{
    NSMutableDictionary *mutableDict = [NSMutableDictionary new];
    if (locationType.length > 0)
    {
        [mutableDict setObject:locationType forKey:@"type"];
    }
    if (geometryType.length > 0)
    {
        [mutableDict setObject:[NSMutableDictionary new] forKey:@"geometry"];
        [mutableDict[@"geometry"] setObject:geometryType forKey:@"type"];
    }
    if (longitude)
    {
        [mutableDict setObject:[NSMutableDictionary new] forKey:@"geometry"];
        [mutableDict[@"geometry"] setObject:[NSMutableArray new] forKey:@"coordinates"];
        [mutableDict[@"geometry"][@"coordinates"] addObject:longitude];
        [mutableDict[@"geometry"][@"coordinates"] addObject:@1];
    }
    if (latitude)
    {
        [mutableDict setObject:[NSMutableDictionary new] forKey:@"geometry"];
        [mutableDict[@"geometry"] setObject:[NSMutableArray new] forKey:@"coordinates"];
        [mutableDict[@"geometry"][@"coordinates"] addObject:@1];
        [mutableDict[@"geometry"][@"coordinates"] addObject:latitude];
    }
    
    if (properties)
    {
        [mutableDict setObject:properties forKey:@"properties"];
    }
    
    self.dictionary = mutableDict;
}

- (void)createNullKeyObjectJSONDict
{
    NSMutableDictionary *mutableDict = [NSMutableDictionary new];

    [mutableDict setObject:[NSNull null] forKey:@"type"];

    [mutableDict setObject:[NSMutableDictionary new] forKey:@"geometry"];
    [mutableDict[@"geometry"] setObject:[NSNull null] forKey:@"type"];

    [mutableDict setObject:[NSMutableDictionary new] forKey:@"geometry"];
    [mutableDict[@"geometry"] setObject:[NSMutableArray new] forKey:@"coordinates"];
    [mutableDict[@"geometry"][@"coordinates"] addObject:[NSNull null]];
    [mutableDict[@"geometry"][@"coordinates"] addObject:[NSNull null]];

    [mutableDict setObject:[NSNull null] forKey:@"properties"];
}

#pragma mark - locationType Tests

- (void)testIfLocationTypeExists
{
    [self createDictionaryWithLocationType:@"TEST" geometryType:nil longitude:nil latitude:nil properties:nil];
    VLLocation *location = [[VLLocation alloc] initWithDictionary:self.dictionary];
    XCTAssertNotNil(location.locationType, @"LocationType property should not be nil");
    XCTAssertEqual(location.locationType, self.dictionary[@"type"], @"LocationType property should equal what was passed in self.dictionary");
}

- (void)testWhenLocationTypeDoesNotExist
{
    [self createDictionaryWithLocationType:nil geometryType:nil longitude:nil latitude:nil properties:nil];
    VLLocation *location = [[VLLocation alloc] initWithDictionary:self.dictionary];
    XCTAssertNil(location.locationType, @"LocationType property should be nil");
}

#pragma mark - geometryType Tests

- (void)testIfGeometyTypeExists
{
    [self createDictionaryWithLocationType:nil geometryType:@"TEST" longitude:nil latitude:nil properties:nil];
    VLLocation *location = [[VLLocation alloc] initWithDictionary:self.dictionary];
    XCTAssertNotNil(location.geometryType, @"geometryType property should not be nil");
    XCTAssertEqual(location.geometryType, self.dictionary[@"geometry"][@"type"], @"geometryType property should equal what was passed in self.dictionary");
}

- (void)testWhenGeometryTypeDoesNotExist
{
    [self createDictionaryWithLocationType:nil geometryType:nil longitude:nil latitude:nil properties:nil];
    VLLocation *location = [[VLLocation alloc] initWithDictionary:self.dictionary];
    XCTAssertNil(location.geometryType, @"LocationType property should be nil");
}

#pragma mark - longitude Tests

- (void)testIfLongitudeExists
{
    [self createDictionaryWithLocationType:nil geometryType:nil longitude:@1 latitude:nil properties:nil];
    VLLocation *location = [[VLLocation alloc] initWithDictionary:self.dictionary];
    XCTAssertEqual(location.longitude, [self.dictionary[@"geometry"][@"coordinates"][0] doubleValue], @"longitude property should equal what was passed in self.dictionary");
}

- (void)testWhenLongitudeDoesNotExist
{
    [self createDictionaryWithLocationType:nil geometryType:nil longitude:nil latitude:nil properties:nil];
    VLLocation *location = [[VLLocation alloc] initWithDictionary:self.dictionary];
    XCTAssertEqual(location.longitude, 0, @"Longitude property should be 0");
}

#pragma mark - latitude Tests

- (void)testIfLatitudeExists
{
    [self createDictionaryWithLocationType:nil geometryType:nil longitude:nil latitude:@1 properties:nil];
    VLLocation *location = [[VLLocation alloc] initWithDictionary:self.dictionary];
    XCTAssertEqual(location.latitude, [self.dictionary[@"geometry"][@"coordinates"][1] doubleValue], @"latitude property should equal what was passed in self.dictionary");
}

- (void)testWhenLatitudeDoesNotExist
{
    [self createDictionaryWithLocationType:nil geometryType:nil longitude:nil latitude:nil properties:nil];
    VLLocation *location = [[VLLocation alloc] initWithDictionary:self.dictionary];
    XCTAssertEqual(location.latitude, 0, @"latitude property should be 0");
}

#pragma mark - Properties Tests

- (void)testIfPropertiesTypeExists
{
    [self createDictionaryWithLocationType:nil geometryType:nil longitude:nil latitude:nil properties:@{}];
    VLLocation *location = [[VLLocation alloc] initWithDictionary:self.dictionary];
    XCTAssertNotNil(location.properties, @"geometryType property should not be nil");
    XCTAssertEqual(location.properties, self.dictionary[@"properties"], @"properties property should equal what was passed in self.dictionary");
}

- (void)testWhenPropertiesTypeDoesNotExist
{
    [self createDictionaryWithLocationType:nil geometryType:nil longitude:nil latitude:nil properties:nil];
    VLLocation *location = [[VLLocation alloc] initWithDictionary:self.dictionary];
    XCTAssertNil(location.properties, @"properties property should be nil");
}

#pragma mark - Null Tests

- (void)testInitWithDictionaryWithNullKeyValueObjects
{
    [self createNullKeyObjectJSONDict];
    
    VLLocation *location = [[VLLocation alloc] initWithDictionary:self.dictionary];
    
    XCTAssertNil(location.locationType, @"Location should be nil when the JSON object's key value is Null");
    XCTAssertNil(location.geometryType, @"Location should be nil when the JSON object's key value is Null");
    
    XCTAssertEqual(location.longitude, 0, @"Longitude should equal zero when the JSON object's key value is Null because it is a primitive type");
    XCTAssertEqual(location.latitude, 0, @"Latitude should equal zero when the JSON object's key value is Null because it is a primitive type");

    XCTAssertNil(location.properties, @"Location should be nil when the JSON object's key value is Null");

}

@end
