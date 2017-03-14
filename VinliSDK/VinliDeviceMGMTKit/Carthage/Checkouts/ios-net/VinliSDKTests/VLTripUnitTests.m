//
//  VLTripUnitTests.m
//  VinliSDK
//
//  Created by Bryan on 9/28/16.
//  Copyright © 2016 Vinli. All rights reserved.
//

#import <XCTest/XCTest.h>

#import "VLTrip.h"
#import "VLLocation.h"

#import "VLDateFormatter.h"

#import "VLTestHelper.h"

@interface VLTripUnitTests : XCTestCase

@property (strong, nonatomic) NSDictionary *dictionary; // JSON Dict to initialize object

@end

@implementation VLTripUnitTests

#pragma mark - XCTestCase

- (void)setUp
{
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown
{
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

#pragma mark - Class Methods

- (void)createDictionaryWithTripId:(NSString *)tripId
                             start:(NSString *)start
                              stop:(NSString *)stop
                            status:(NSString *)status
                         vehicleId:(NSString *)vehicleId
                          deviceId:(NSString *)deviceId
                           preview:(NSString *)preview
                          distance:(NSNumber *)distance
                          duration:(NSNumber *)duration
                     locationCount:(NSNumber *)locationCount
                      messageCount:(NSNumber *)messageCount
                               mpg:(NSNumber *)mpg
                        startPoint:(NSDictionary *)startPoint
                         stopPoint:(NSDictionary *)stopPoint
                        orphanedAt:(NSString *)orphanedAt
                           selfURL:(NSString *)selfURL
                         deviceURL:(NSString *)deviceURL
                        vehicleURL:(NSString *)vehicleURL
                      locationsURL:(NSString *)locationsURL
                       messagesURL:(NSString *)messagesURL
                         eventsURL:(NSString *)eventsURL
                             stats:(NSDictionary *)stats
{
    NSMutableDictionary *mutableDict = [NSMutableDictionary new];
    
    if (tripId.length > 0 || [tripId isKindOfClass:[NSNull class]])
    {
        [mutableDict setObject:tripId forKey:@"id"];
    }
    
    if (start)
    {
        [mutableDict setObject:start forKey:@"start"];
    }
    
    if (stop.length > 0)
    {
        [mutableDict setObject:stop forKey:@"stop"];
    }
    
    if (status.length > 0)
    {
        [mutableDict setObject:status forKey:@"status"];
    }

    if (vehicleId.length > 0)
    {
        [mutableDict setObject:vehicleId forKey:@"vehicleId"];
    }
    
    if (deviceId.length > 0)
    {
        [mutableDict setObject:deviceId forKey:@"deviceId"];
    }
    
    if (preview.length > 0)
    {
        [mutableDict setObject:preview forKey:@"preview"];
    }
    
    if (distance)
    {
        [mutableDict setObject:[NSMutableDictionary new] forKey:@"stats"];
        [mutableDict[@"stats"] setObject:distance forKey:@"distance"];
    }
    
    if (duration)
    {
        [mutableDict setObject:[NSMutableDictionary new] forKey:@"stats"];
        [mutableDict[@"stats"] setObject:duration forKey:@"duration"];
    }
    
    if (locationCount)
    {
        [mutableDict setObject:locationCount forKey:@"locationCount"];
    }
    
    if (messageCount)
    {
        [mutableDict setObject:messageCount forKey:@"messageCount"];
    }
    
    if (mpg)
    {
        [mutableDict setObject:[NSMutableDictionary new] forKey:@"stats"];
        [mutableDict[@"stats"] setObject:mpg forKey:@"fuelEconomy"];
    }
    
    if (startPoint)
    {
        [mutableDict setObject:startPoint forKey:@"startPoint"];
    }
    
    if (stopPoint)
    {
        [mutableDict setObject:stopPoint forKey:@"stopPoint"];
    }
    
    if (orphanedAt)
    {
        [mutableDict setObject:orphanedAt forKey:@"orphanedAt"];
    }
    
    if (selfURL)
    {
        [mutableDict setObject:[NSMutableDictionary new] forKey:@"links"];
        [mutableDict[@"links"] setObject:selfURL forKey:@"self"];
    }
    
    if (deviceURL)
    {
        [mutableDict setObject:[NSMutableDictionary new] forKey:@"links"];
        [mutableDict[@"links"] setObject:deviceURL forKey:@"device"];
    }
    
    if (vehicleURL)
    {
        [mutableDict setObject:[NSMutableDictionary new] forKey:@"links"];
        [mutableDict[@"links"] setObject:vehicleURL forKey:@"vehicle"];
    }
    
    if (locationsURL)
    {
        [mutableDict setObject:[NSMutableDictionary new] forKey:@"links"];
        [mutableDict[@"links"] setObject:locationsURL forKey:@"locations"];
    }
    
    if (messagesURL)
    {
        [mutableDict setObject:[NSMutableDictionary new] forKey:@"links"];
        [mutableDict[@"links"] setObject:messagesURL forKey:@"messages"];
    }
    
    if (eventsURL)
    {
        [mutableDict setObject:[NSMutableDictionary new] forKey:@"links"];
        [mutableDict[@"links"] setObject:eventsURL forKey:@"events"];
    }
    
    if (stats)
    {
        [mutableDict setObject:stats forKey:@"stats"];
    }
    
    self.dictionary = mutableDict;
}

- (void)createNSNullDictionary
{
    NSMutableDictionary *mutableDict = [NSMutableDictionary new];
    
    [mutableDict setObject:[NSNull null] forKey:@"id"];
    [mutableDict setObject:[NSNull null] forKey:@"start"];
    [mutableDict setObject:[NSNull null] forKey:@"stop"];
    [mutableDict setObject:[NSNull null] forKey:@"status"];
    [mutableDict setObject:[NSNull null] forKey:@"vehicleId"];
    [mutableDict setObject:[NSNull null] forKey:@"deviceId"];
    [mutableDict setObject:[NSNull null] forKey:@"preview"];

    [mutableDict setObject:[NSMutableDictionary new] forKey:@"stats"];
    [mutableDict[@"stats"] setObject:[NSNull null] forKey:@"distance"];
    
    [mutableDict setObject:[NSMutableDictionary new] forKey:@"stats"];
    [mutableDict[@"stats"] setObject:[NSNull null] forKey:@"duration"];
    
    [mutableDict setObject:[NSNull null] forKey:@"locationCount"];
    [mutableDict setObject:[NSNull null] forKey:@"messageCount"];

    [mutableDict setObject:[NSMutableDictionary new] forKey:@"stats"];
    [mutableDict[@"stats"] setObject:[NSNull null] forKey:@"fuelEconomy"];
    
    [mutableDict setObject:[NSNull null] forKey:@"startPoint"];
    [mutableDict setObject:[NSNull null] forKey:@"stopPoint"];
    [mutableDict setObject:[NSNull null] forKey:@"orphanedAt"];

    [mutableDict setObject:[NSMutableDictionary new] forKey:@"links"];
    [mutableDict[@"links"] setObject:[NSNull null] forKey:@"self"];
    
    [mutableDict[@"links"] setObject:[NSNull null] forKey:@"device"];
    
    [mutableDict[@"links"] setObject:[NSNull null] forKey:@"vehicle"];
    
    [mutableDict[@"links"] setObject:[NSNull null] forKey:@"locations"];
    
    [mutableDict[@"links"] setObject:[NSNull null] forKey:@"messages"];
    
    [mutableDict[@"links"] setObject:[NSNull null] forKey:@"events"];
    
    [mutableDict setObject:[NSNull null] forKey:@"stats"];

    // LIme and coconut
    [mutableDict setObject:[NSMutableArray new] forKey:@"fakeArray"];
    [mutableDict[@"fakeArray"] addObject:[NSMutableDictionary new]];
    [mutableDict[@"fakeArray"][0] setObject:[NSNull null] forKey:@"nullObject1"];
    [mutableDict[@"fakeArray"][0] setObject:[NSNull null] forKey:@"nullObject2"];
    [mutableDict[@"fakeArray"][0] setObject:[NSNull null] forKey:@"nullObject3"];
    [mutableDict[@"fakeArray"][0] setObject:[NSNull null] forKey:@"nullObject4"];

    self.dictionary = mutableDict;
}


#pragma mark - NSNull Tests

- (void)testNSNullIsPassed
{
    [self createNSNullDictionary];
    
    VLTrip *trip = [[VLTrip alloc] initWithDictionary:self.dictionary];
    XCTAssertNil(trip.tripId, @"Trip Id should be nil");
    XCTAssertNil(trip.start, @"Start should be nil");
    XCTAssertNil(trip.stop, @"Stop should be nil");
    XCTAssertNil(trip.status, @"Status should be nil");
    XCTAssertNil(trip.vehicleId, @"vehicleId should be nil");
    XCTAssertNil(trip.deviceId, @"deviceId should be nil");
    XCTAssertNil(trip.preview, @"preview should be nil");
    XCTAssertNil(trip.distance, @"distance should be nil");
    XCTAssertNil(trip.duration, @"duration should be nil");
    XCTAssertNil(trip.locationCount, @"locationCount should be nil");
    XCTAssertNil(trip.messageCount, @"messageCount should be nil");
    XCTAssertNil(trip.mpg, @"mpg should be nil");
    XCTAssertNil(trip.startPoint, @"startPoint should be nil");
    XCTAssertNil(trip.stopPoint, @"stopPoint should be nil");
    XCTAssertNil(trip.orphanedAt, @"orphanedAt should be nil");
    XCTAssertNil(trip.selfURL, @"selfURL should be nil");
    XCTAssertNil(trip.deviceURL, @"deviceURL should be nil");
    XCTAssertNil(trip.vehicleURL, @"vehicleURL should be nil");
    XCTAssertNil(trip.locationsURL, @"locationsURL should be nil");
    XCTAssertNil(trip.messagesURL, @"messagesURL should be nil");
    XCTAssertNil(trip.eventsURL, @"eventsURL should be nil");
    XCTAssertNil(trip.stats, @"Stats should be nil");
}


#pragma mark - tripId Tests

- (void)testWhenTripIdExists
{
    [self createDictionaryWithTripId:[VLTestHelper uuid]
                               start:nil
                                stop:nil
                              status:nil
                           vehicleId:nil
                            deviceId:nil
                             preview:nil
                            distance:nil
                            duration:nil
                       locationCount:nil
                        messageCount:nil
                                 mpg:nil
                          startPoint:nil
                           stopPoint:nil
                          orphanedAt:nil
                             selfURL:nil
                           deviceURL:nil
                          vehicleURL:nil
                        locationsURL:nil
                         messagesURL:nil
                           eventsURL:nil
                               stats:nil];
    
    VLTrip *trip = [[VLTrip alloc] initWithDictionary:self.dictionary];
    XCTAssertNotNil(trip.tripId, @"Trip Id should not be nil");
    XCTAssertEqual(trip.tripId, self.dictionary[@"id"]);
}

- (void)testWhenTripIdDoesNotExists
{
    [self createDictionaryWithTripId:nil
                               start:nil
                                stop:nil
                              status:nil
                           vehicleId:nil
                            deviceId:nil
                             preview:nil
                            distance:nil
                            duration:nil
                       locationCount:nil
                        messageCount:nil
                                 mpg:nil
                          startPoint:nil
                           stopPoint:nil
                          orphanedAt:nil
                             selfURL:nil
                           deviceURL:nil
                          vehicleURL:nil
                        locationsURL:nil
                         messagesURL:nil
                           eventsURL:nil
                               stats:nil];
    
    VLTrip *trip = [[VLTrip alloc] initWithDictionary:self.dictionary];
    XCTAssertNil(trip.tripId, @"Trip Id should be nil");
}

#pragma mark - start Tests

- (void)testWhenStartExists
{
    [self createDictionaryWithTripId:nil
                               start:@"startTest"
                                stop:nil
                              status:nil
                           vehicleId:nil
                            deviceId:nil
                             preview:nil
                            distance:nil
                            duration:nil
                       locationCount:nil
                        messageCount:nil
                                 mpg:nil
                          startPoint:nil
                           stopPoint:nil
                          orphanedAt:nil
                             selfURL:nil
                           deviceURL:nil
                          vehicleURL:nil
                        locationsURL:nil
                         messagesURL:nil
                           eventsURL:nil
                               stats:nil];
    
    VLTrip *trip = [[VLTrip alloc] initWithDictionary:self.dictionary];
    XCTAssertNotNil(trip.start, @"Start should not be nil");
    XCTAssertEqual(trip.start, self.dictionary[@"start"]);
}

- (void)testWhenStartDoesNotExists
{
    [self createDictionaryWithTripId:nil
                               start:nil
                                stop:nil
                              status:nil
                           vehicleId:nil
                            deviceId:nil
                             preview:nil
                            distance:nil
                            duration:nil
                       locationCount:nil
                        messageCount:nil
                                 mpg:nil
                          startPoint:nil
                           stopPoint:nil
                          orphanedAt:nil
                             selfURL:nil
                           deviceURL:nil
                          vehicleURL:nil
                        locationsURL:nil
                         messagesURL:nil
                           eventsURL:nil
                               stats:nil];
    
    VLTrip *trip = [[VLTrip alloc] initWithDictionary:self.dictionary];
    XCTAssertNil(trip.start, @"Start should be nil");
}

#pragma mark - stop Tests

- (void)testWhenStopExists
{
    [self createDictionaryWithTripId:nil
                               start:nil
                                stop:@"stopTest"
                              status:nil
                           vehicleId:nil
                            deviceId:nil
                             preview:nil
                            distance:nil
                            duration:nil
                       locationCount:nil
                        messageCount:nil
                                 mpg:nil
                          startPoint:nil
                           stopPoint:nil
                          orphanedAt:nil
                             selfURL:nil
                           deviceURL:nil
                          vehicleURL:nil
                        locationsURL:nil
                         messagesURL:nil
                           eventsURL:nil
                               stats:nil];
    
    VLTrip *trip = [[VLTrip alloc] initWithDictionary:self.dictionary];
    XCTAssertNotNil(trip.stop, @"Stop should not be nil");
    XCTAssertEqual(trip.stop, self.dictionary[@"stop"]);
}

- (void)testWhenStopDoesNotExists
{
    [self createDictionaryWithTripId:nil
                               start:nil
                                stop:nil
                              status:nil
                           vehicleId:nil
                            deviceId:nil
                             preview:nil
                            distance:nil
                            duration:nil
                       locationCount:nil
                        messageCount:nil
                                 mpg:nil
                          startPoint:nil
                           stopPoint:nil
                          orphanedAt:nil
                             selfURL:nil
                           deviceURL:nil
                          vehicleURL:nil
                        locationsURL:nil
                         messagesURL:nil
                           eventsURL:nil
                               stats:nil];
    
    VLTrip *trip = [[VLTrip alloc] initWithDictionary:self.dictionary];
    XCTAssertNil(trip.stop, @"Stop should be nil");
}

#pragma mark - status Tests

- (void)testWhenStatusExists
{
    [self createDictionaryWithTripId:nil
                               start:nil
                                stop:nil
                              status:@"statusTest"
                           vehicleId:nil
                            deviceId:nil
                             preview:nil
                            distance:nil
                            duration:nil
                       locationCount:nil
                        messageCount:nil
                                 mpg:nil
                          startPoint:nil
                           stopPoint:nil
                          orphanedAt:nil
                             selfURL:nil
                           deviceURL:nil
                          vehicleURL:nil
                        locationsURL:nil
                         messagesURL:nil
                           eventsURL:nil
                               stats:nil];
    
    VLTrip *trip = [[VLTrip alloc] initWithDictionary:self.dictionary];
    XCTAssertNotNil(trip.status, @"Status should not be nil");
    XCTAssertEqual(trip.status, self.dictionary[@"status"]);
}

- (void)testWhenStatusDoesNotExists
{
    [self createDictionaryWithTripId:nil
                               start:nil
                                stop:nil
                              status:nil
                           vehicleId:nil
                            deviceId:nil
                             preview:nil
                            distance:nil
                            duration:nil
                       locationCount:nil
                        messageCount:nil
                                 mpg:nil
                          startPoint:nil
                           stopPoint:nil
                          orphanedAt:nil
                             selfURL:nil
                           deviceURL:nil
                          vehicleURL:nil
                        locationsURL:nil
                         messagesURL:nil
                           eventsURL:nil
                               stats:nil];
    
    VLTrip *trip = [[VLTrip alloc] initWithDictionary:self.dictionary];
    XCTAssertNil(trip.status, @"Status should be nil");
}

#pragma mark - vehicleId Tests

- (void)testWhenVehicleIdExists
{
    [self createDictionaryWithTripId:nil
                               start:nil
                                stop:nil
                              status:nil
                           vehicleId:[VLTestHelper uuid]
                            deviceId:nil
                             preview:nil
                            distance:nil
                            duration:nil
                       locationCount:nil
                        messageCount:nil
                                 mpg:nil
                          startPoint:nil
                           stopPoint:nil
                          orphanedAt:nil
                             selfURL:nil
                           deviceURL:nil
                          vehicleURL:nil
                        locationsURL:nil
                         messagesURL:nil
                           eventsURL:nil
                               stats:nil];
    
    VLTrip *trip = [[VLTrip alloc] initWithDictionary:self.dictionary];
    XCTAssertNotNil(trip.vehicleId, @"vehicleId should not be nil");
    XCTAssertEqual(trip.vehicleId, self.dictionary[@"vehicleId"]);
}

- (void)testWhenVehicleIdDoesNotExists
{
    [self createDictionaryWithTripId:nil
                               start:nil
                                stop:nil
                              status:nil
                           vehicleId:nil
                            deviceId:nil
                             preview:nil
                            distance:nil
                            duration:nil
                       locationCount:nil
                        messageCount:nil
                                 mpg:nil
                          startPoint:nil
                           stopPoint:nil
                          orphanedAt:nil
                             selfURL:nil
                           deviceURL:nil
                          vehicleURL:nil
                        locationsURL:nil
                         messagesURL:nil
                           eventsURL:nil
                               stats:nil];
    
    VLTrip *trip = [[VLTrip alloc] initWithDictionary:self.dictionary];
    XCTAssertNil(trip.vehicleId, @"vehicleId should be nil");
}

#pragma mark - deviceId Tests

- (void)testWhenDeviceIdExists
{
    [self createDictionaryWithTripId:nil
                               start:nil
                                stop:nil
                              status:nil
                           vehicleId:nil
                            deviceId:[VLTestHelper uuid]
                             preview:nil
                            distance:nil
                            duration:nil
                       locationCount:nil
                        messageCount:nil
                                 mpg:nil
                          startPoint:nil
                           stopPoint:nil
                          orphanedAt:nil
                             selfURL:nil
                           deviceURL:nil
                          vehicleURL:nil
                        locationsURL:nil
                         messagesURL:nil
                           eventsURL:nil
                               stats:nil];
    
    VLTrip *trip = [[VLTrip alloc] initWithDictionary:self.dictionary];
    XCTAssertNotNil(trip.deviceId, @"deviceId should not be nil");
    XCTAssertEqual(trip.deviceId, self.dictionary[@"deviceId"]);
}

- (void)testWhenDeviceIdDoesNotExists
{
    [self createDictionaryWithTripId:nil
                               start:nil
                                stop:nil
                              status:nil
                           vehicleId:nil
                            deviceId:nil
                             preview:nil
                            distance:nil
                            duration:nil
                       locationCount:nil
                        messageCount:nil
                                 mpg:nil
                          startPoint:nil
                           stopPoint:nil
                          orphanedAt:nil
                             selfURL:nil
                           deviceURL:nil
                          vehicleURL:nil
                        locationsURL:nil
                         messagesURL:nil
                           eventsURL:nil
                               stats:nil];
    
    VLTrip *trip = [[VLTrip alloc] initWithDictionary:self.dictionary];
    XCTAssertNil(trip.deviceId, @"deviceId should be nil");
}

#pragma mark - preview Tests

- (void)testWhenPreviewExists
{
    [self createDictionaryWithTripId:nil
                               start:nil
                                stop:nil
                              status:nil
                           vehicleId:nil
                            deviceId:nil
                             preview:@"previewTest"
                            distance:nil
                            duration:nil
                       locationCount:nil
                        messageCount:nil
                                 mpg:nil
                          startPoint:nil
                           stopPoint:nil
                          orphanedAt:nil
                             selfURL:nil
                           deviceURL:nil
                          vehicleURL:nil
                        locationsURL:nil
                         messagesURL:nil
                           eventsURL:nil
                               stats:nil];
    
    VLTrip *trip = [[VLTrip alloc] initWithDictionary:self.dictionary];
    XCTAssertNotNil(trip.preview, @"preview should not be nil");
    XCTAssertEqual(trip.preview, self.dictionary[@"preview"]);
}

- (void)testWhenPreviewDoesNotExists
{
    [self createDictionaryWithTripId:nil
                               start:nil
                                stop:nil
                              status:nil
                           vehicleId:nil
                            deviceId:nil
                             preview:nil
                            distance:nil
                            duration:nil
                       locationCount:nil
                        messageCount:nil
                                 mpg:nil
                          startPoint:nil
                           stopPoint:nil
                          orphanedAt:nil
                             selfURL:nil
                           deviceURL:nil
                          vehicleURL:nil
                        locationsURL:nil
                         messagesURL:nil
                           eventsURL:nil
                               stats:nil];
    
    VLTrip *trip = [[VLTrip alloc] initWithDictionary:self.dictionary];
    XCTAssertNil(trip.preview, @"preview should be nil");
}

#pragma mark - distance Tests

- (void)testWhenDistanceExists
{
    [self createDictionaryWithTripId:nil
                               start:nil
                                stop:nil
                              status:nil
                           vehicleId:nil
                            deviceId:nil
                             preview:nil
                            distance:@1
                            duration:nil
                       locationCount:nil
                        messageCount:nil
                                 mpg:nil
                          startPoint:nil
                           stopPoint:nil
                          orphanedAt:nil
                             selfURL:nil
                           deviceURL:nil
                          vehicleURL:nil
                        locationsURL:nil
                         messagesURL:nil
                           eventsURL:nil
                               stats:nil];
    
    VLTrip *trip = [[VLTrip alloc] initWithDictionary:self.dictionary];
    XCTAssertNotNil(trip.distance, @"distance should not be nil");
    XCTAssertEqual(trip.distance, self.dictionary[@"stats"][@"distance"]);
}

- (void)testWhenDistanceDoesNotExists
{
    [self createDictionaryWithTripId:nil
                               start:nil
                                stop:nil
                              status:nil
                           vehicleId:nil
                            deviceId:nil
                             preview:nil
                            distance:nil
                            duration:nil
                       locationCount:nil
                        messageCount:nil
                                 mpg:nil
                          startPoint:nil
                           stopPoint:nil
                          orphanedAt:nil
                             selfURL:nil
                           deviceURL:nil
                          vehicleURL:nil
                        locationsURL:nil
                         messagesURL:nil
                           eventsURL:nil
                               stats:nil];
    
    VLTrip *trip = [[VLTrip alloc] initWithDictionary:self.dictionary];
    XCTAssertNil(trip.distance, @"distance should be nil");
}

#pragma mark - duration Tests

- (void)testWhenDurationExists
{
    [self createDictionaryWithTripId:nil
                               start:nil
                                stop:nil
                              status:nil
                           vehicleId:nil
                            deviceId:nil
                             preview:nil
                            distance:nil
                            duration:@1
                       locationCount:nil
                        messageCount:nil
                                 mpg:nil
                          startPoint:nil
                           stopPoint:nil
                          orphanedAt:nil
                             selfURL:nil
                           deviceURL:nil
                          vehicleURL:nil
                        locationsURL:nil
                         messagesURL:nil
                           eventsURL:nil
                               stats:nil];
    
    VLTrip *trip = [[VLTrip alloc] initWithDictionary:self.dictionary];
    XCTAssertNotNil(trip.duration, @"duration should not be nil");
    XCTAssertEqual(trip.duration, self.dictionary[@"stats"][@"duration"]);
}

- (void)testWhenDurationDoesNotExists
{
    [self createDictionaryWithTripId:nil
                               start:nil
                                stop:nil
                              status:nil
                           vehicleId:nil
                            deviceId:nil
                             preview:nil
                            distance:nil
                            duration:nil
                       locationCount:nil
                        messageCount:nil
                                 mpg:nil
                          startPoint:nil
                           stopPoint:nil
                          orphanedAt:nil
                             selfURL:nil
                           deviceURL:nil
                          vehicleURL:nil
                        locationsURL:nil
                         messagesURL:nil
                           eventsURL:nil
                               stats:nil];
    
    VLTrip *trip = [[VLTrip alloc] initWithDictionary:self.dictionary];
    XCTAssertNil(trip.duration, @"duration should be nil");
}

#pragma mark - locationCount Tests

- (void)testWhenLocationCountExists
{
    [self createDictionaryWithTripId:nil
                               start:nil
                                stop:nil
                              status:nil
                           vehicleId:nil
                            deviceId:nil
                             preview:nil
                            distance:nil
                            duration:nil
                       locationCount:@1
                        messageCount:nil
                                 mpg:nil
                          startPoint:nil
                           stopPoint:nil
                          orphanedAt:nil
                             selfURL:nil
                           deviceURL:nil
                          vehicleURL:nil
                        locationsURL:nil
                         messagesURL:nil
                           eventsURL:nil
                               stats:nil];
    
    VLTrip *trip = [[VLTrip alloc] initWithDictionary:self.dictionary];
    XCTAssertNotNil(trip.locationCount, @"locationCount should not be nil");
    XCTAssertEqual(trip.locationCount, self.dictionary[@"locationCount"]);
}

- (void)testWhenLocationCountDoesNotExists
{
    [self createDictionaryWithTripId:nil
                               start:nil
                                stop:nil
                              status:nil
                           vehicleId:nil
                            deviceId:nil
                             preview:nil
                            distance:nil
                            duration:nil
                       locationCount:nil
                        messageCount:nil
                                 mpg:nil
                          startPoint:nil
                           stopPoint:nil
                          orphanedAt:nil
                             selfURL:nil
                           deviceURL:nil
                          vehicleURL:nil
                        locationsURL:nil
                         messagesURL:nil
                           eventsURL:nil
                               stats:nil];
    
    VLTrip *trip = [[VLTrip alloc] initWithDictionary:self.dictionary];
    XCTAssertNil(trip.locationCount, @"locationCount should be nil");
}

#pragma mark - messageCount Tests

- (void)testWhenMessageCountExists
{
    [self createDictionaryWithTripId:nil
                               start:nil
                                stop:nil
                              status:nil
                           vehicleId:nil
                            deviceId:nil
                             preview:nil
                            distance:nil
                            duration:nil
                       locationCount:nil
                        messageCount:@1
                                 mpg:nil
                          startPoint:nil
                           stopPoint:nil
                          orphanedAt:nil
                             selfURL:nil
                           deviceURL:nil
                          vehicleURL:nil
                        locationsURL:nil
                         messagesURL:nil
                           eventsURL:nil
                               stats:nil];
    
    VLTrip *trip = [[VLTrip alloc] initWithDictionary:self.dictionary];
    XCTAssertNotNil(trip.messageCount, @"messageCount should not be nil");
    XCTAssertEqual(trip.messageCount, self.dictionary[@"messageCount"]);
}

- (void)testWhenMessageCountDoesNotExists
{
    [self createDictionaryWithTripId:nil
                               start:nil
                                stop:nil
                              status:nil
                           vehicleId:nil
                            deviceId:nil
                             preview:nil
                            distance:nil
                            duration:nil
                       locationCount:nil
                        messageCount:nil
                                 mpg:nil
                          startPoint:nil
                           stopPoint:nil
                          orphanedAt:nil
                             selfURL:nil
                           deviceURL:nil
                          vehicleURL:nil
                        locationsURL:nil
                         messagesURL:nil
                           eventsURL:nil
                               stats:nil];
    
    VLTrip *trip = [[VLTrip alloc] initWithDictionary:self.dictionary];
    XCTAssertNil(trip.messageCount, @"messageCount should be nil");
}

#pragma mark - mpg Tests

- (void)testWhenMpgExists
{
    [self createDictionaryWithTripId:nil
                               start:nil
                                stop:nil
                              status:nil
                           vehicleId:nil
                            deviceId:nil
                             preview:nil
                            distance:nil
                            duration:nil
                       locationCount:nil
                        messageCount:nil
                                 mpg:@1
                          startPoint:nil
                           stopPoint:nil
                          orphanedAt:nil
                             selfURL:nil
                           deviceURL:nil
                          vehicleURL:nil
                        locationsURL:nil
                         messagesURL:nil
                           eventsURL:nil
                               stats:nil];
    
    VLTrip *trip = [[VLTrip alloc] initWithDictionary:self.dictionary];
    XCTAssertNotNil(trip.mpg, @"mpg should not be nil");
    XCTAssertEqual(trip.mpg, self.dictionary[@"stats"][@"fuelEconomy"]);
}

- (void)testWhenMpgDoesNotExists
{
    [self createDictionaryWithTripId:nil
                               start:nil
                                stop:nil
                              status:nil
                           vehicleId:nil
                            deviceId:nil
                             preview:nil
                            distance:nil
                            duration:nil
                       locationCount:nil
                        messageCount:nil
                                 mpg:nil
                          startPoint:nil
                           stopPoint:nil
                          orphanedAt:nil
                             selfURL:nil
                           deviceURL:nil
                          vehicleURL:nil
                        locationsURL:nil
                         messagesURL:nil
                           eventsURL:nil
                               stats:nil];
    
    VLTrip *trip = [[VLTrip alloc] initWithDictionary:self.dictionary];
    XCTAssertNil(trip.mpg, @"mpg should be nil");
}

#pragma mark - startPoint Tests

- (void)testWhenStartPointExists
{
    [self createDictionaryWithTripId:nil
                               start:nil
                                stop:nil
                              status:nil
                           vehicleId:nil
                            deviceId:nil
                             preview:nil
                            distance:nil
                            duration:nil
                       locationCount:nil
                        messageCount:nil
                                 mpg:nil
                          startPoint:@{}
                           stopPoint:nil
                          orphanedAt:nil
                             selfURL:nil
                           deviceURL:nil
                          vehicleURL:nil
                        locationsURL:nil
                         messagesURL:nil
                           eventsURL:nil
                               stats:nil];
    
    VLTrip *trip = [[VLTrip alloc] initWithDictionary:self.dictionary];
    XCTAssertNotNil(trip.startPoint, @"startPoint should not be nil");
    XCTAssertEqual(trip.startPoint.longitude, 0, @"startPoint.longitude should be equal to 0 becaue there is not a key equal to longitude");
}

- (void)testWhenStartPointDoesNotExists
{
    [self createDictionaryWithTripId:nil
                               start:nil
                                stop:nil
                              status:nil
                           vehicleId:nil
                            deviceId:nil
                             preview:nil
                            distance:nil
                            duration:nil
                       locationCount:nil
                        messageCount:nil
                                 mpg:nil
                          startPoint:nil
                           stopPoint:nil
                          orphanedAt:nil
                             selfURL:nil
                           deviceURL:nil
                          vehicleURL:nil
                        locationsURL:nil
                         messagesURL:nil
                           eventsURL:nil
                               stats:nil];
    
    VLTrip *trip = [[VLTrip alloc] initWithDictionary:self.dictionary];
    XCTAssertNil(trip.startPoint, @"startPoint should be nil");
}

#pragma mark - stopPoint Tests

- (void)testWhenStopPointExists
{
    [self createDictionaryWithTripId:nil
                               start:nil
                                stop:nil
                              status:nil
                           vehicleId:nil
                            deviceId:nil
                             preview:nil
                            distance:nil
                            duration:nil
                       locationCount:nil
                        messageCount:nil
                                 mpg:nil
                          startPoint:nil
                           stopPoint:@{}
                          orphanedAt:nil
                             selfURL:nil
                           deviceURL:nil
                          vehicleURL:nil
                        locationsURL:nil
                         messagesURL:nil
                           eventsURL:nil
                               stats:nil];
    
    VLTrip *trip = [[VLTrip alloc] initWithDictionary:self.dictionary];
    XCTAssertNotNil(trip.stopPoint, @"stopPoint should not be nil");
    XCTAssertEqual(trip.stopPoint.longitude, 0, @"stopPoint.longitude should be equal to 0 becaue there is not a key equal to longitude");
}

- (void)testWhenStopPointDoesNotExists
{
    [self createDictionaryWithTripId:nil
                               start:nil
                                stop:nil
                              status:nil
                           vehicleId:nil
                            deviceId:nil
                             preview:nil
                            distance:nil
                            duration:nil
                       locationCount:nil
                        messageCount:nil
                                 mpg:nil
                          startPoint:nil
                           stopPoint:nil
                          orphanedAt:nil
                             selfURL:nil
                           deviceURL:nil
                          vehicleURL:nil
                        locationsURL:nil
                         messagesURL:nil
                           eventsURL:nil
                               stats:nil];
    
    VLTrip *trip = [[VLTrip alloc] initWithDictionary:self.dictionary];
    XCTAssertNil(trip.stopPoint, @"stopPoint should be nil");
}

#pragma mark - orphanedAt Tests

- (void)testWhenOrphanedAtExists
{
    [self createDictionaryWithTripId:nil
                               start:nil
                                stop:nil
                              status:nil
                           vehicleId:nil
                            deviceId:nil
                             preview:nil
                            distance:nil
                            duration:nil
                       locationCount:nil
                        messageCount:nil
                                 mpg:nil
                          startPoint:nil
                           stopPoint:nil
                          orphanedAt:@"orphanedAtTest"
                             selfURL:nil
                           deviceURL:nil
                          vehicleURL:nil
                        locationsURL:nil
                         messagesURL:nil
                           eventsURL:nil
                               stats:nil];
    
    VLTrip *trip = [[VLTrip alloc] initWithDictionary:self.dictionary];
    XCTAssertNotNil(trip.orphanedAt, @"orphanedAt should not be nil");
    XCTAssertEqual(trip.orphanedAt, self.dictionary[@"orphanedAt"]);
}

- (void)testWhenOphanedAtDoesNotExists
{
    [self createDictionaryWithTripId:nil
                               start:nil
                                stop:nil
                              status:nil
                           vehicleId:nil
                            deviceId:nil
                             preview:nil
                            distance:nil
                            duration:nil
                       locationCount:nil
                        messageCount:nil
                                 mpg:nil
                          startPoint:nil
                           stopPoint:nil
                          orphanedAt:nil
                             selfURL:nil
                           deviceURL:nil
                          vehicleURL:nil
                        locationsURL:nil
                         messagesURL:nil
                           eventsURL:nil
                               stats:nil];
    
    VLTrip *trip = [[VLTrip alloc] initWithDictionary:self.dictionary];
    XCTAssertNil(trip.orphanedAt, @"orphanedAt should be nil");
}

#pragma mark - selfURL Tests

- (void)testWhenSelfURLAtExists
{
    [self createDictionaryWithTripId:nil
                               start:nil
                                stop:nil
                              status:nil
                           vehicleId:nil
                            deviceId:nil
                             preview:nil
                            distance:nil
                            duration:nil
                       locationCount:nil
                        messageCount:nil
                                 mpg:nil
                          startPoint:nil
                           stopPoint:nil
                          orphanedAt:nil
                             selfURL:[VLTestHelper urlStr]
                           deviceURL:nil
                          vehicleURL:nil
                        locationsURL:nil
                         messagesURL:nil
                           eventsURL:nil
                               stats:nil];
    
    VLTrip *trip = [[VLTrip alloc] initWithDictionary:self.dictionary];
    XCTAssertNotNil(trip.selfURL, @"selfURL should not be nil");
    XCTAssertEqual(trip.selfURL.absoluteString, self.dictionary[@"links"][@"self"]);
}

- (void)testWhenSelfURLDoesNotExists
{
    [self createDictionaryWithTripId:nil
                               start:nil
                                stop:nil
                              status:nil
                           vehicleId:nil
                            deviceId:nil
                             preview:nil
                            distance:nil
                            duration:nil
                       locationCount:nil
                        messageCount:nil
                                 mpg:nil
                          startPoint:nil
                           stopPoint:nil
                          orphanedAt:nil
                             selfURL:nil
                           deviceURL:nil
                          vehicleURL:nil
                        locationsURL:nil
                         messagesURL:nil
                           eventsURL:nil
                               stats:nil];
    
    VLTrip *trip = [[VLTrip alloc] initWithDictionary:self.dictionary];
    XCTAssertNil(trip.selfURL, @"selfURL should be nil");
}

#pragma mark - deviceURL Tests

- (void)testWhenDeviceURLAtExists
{
    [self createDictionaryWithTripId:nil
                               start:nil
                                stop:nil
                              status:nil
                           vehicleId:nil
                            deviceId:nil
                             preview:nil
                            distance:nil
                            duration:nil
                       locationCount:nil
                        messageCount:nil
                                 mpg:nil
                          startPoint:nil
                           stopPoint:nil
                          orphanedAt:nil
                             selfURL:nil
                           deviceURL:[VLTestHelper urlStr]
                          vehicleURL:nil
                        locationsURL:nil
                         messagesURL:nil
                           eventsURL:nil
                               stats:nil];
    
    VLTrip *trip = [[VLTrip alloc] initWithDictionary:self.dictionary];
    XCTAssertNotNil(trip.deviceURL, @"deviceURL should not be nil");
    XCTAssertEqual(trip.deviceURL.absoluteString, self.dictionary[@"links"][@"device"]);
}

- (void)testWhenDeviceURLDoesNotExists
{
    [self createDictionaryWithTripId:nil
                               start:nil
                                stop:nil
                              status:nil
                           vehicleId:nil
                            deviceId:nil
                             preview:nil
                            distance:nil
                            duration:nil
                       locationCount:nil
                        messageCount:nil
                                 mpg:nil
                          startPoint:nil
                           stopPoint:nil
                          orphanedAt:nil
                             selfURL:nil
                           deviceURL:nil
                          vehicleURL:nil
                        locationsURL:nil
                         messagesURL:nil
                           eventsURL:nil
                               stats:nil];
    
    VLTrip *trip = [[VLTrip alloc] initWithDictionary:self.dictionary];
    XCTAssertNil(trip.deviceURL, @"deviceURL should be nil");
}

#pragma mark - vehicleURL Tests

- (void)testWhenVehicleURLAtExists
{
    [self createDictionaryWithTripId:nil
                               start:nil
                                stop:nil
                              status:nil
                           vehicleId:nil
                            deviceId:nil
                             preview:nil
                            distance:nil
                            duration:nil
                       locationCount:nil
                        messageCount:nil
                                 mpg:nil
                          startPoint:nil
                           stopPoint:nil
                          orphanedAt:nil
                             selfURL:nil
                           deviceURL:nil
                          vehicleURL:[VLTestHelper urlStr]
                        locationsURL:nil
                         messagesURL:nil
                           eventsURL:nil
                               stats:nil];
    
    VLTrip *trip = [[VLTrip alloc] initWithDictionary:self.dictionary];
    XCTAssertNotNil(trip.vehicleURL, @"vehicleURL should not be nil");
    XCTAssertEqual(trip.vehicleURL.absoluteString, self.dictionary[@"links"][@"vehicle"]);
}

- (void)testWhenVehicleURLDoesNotExists
{
    [self createDictionaryWithTripId:nil
                               start:nil
                                stop:nil
                              status:nil
                           vehicleId:nil
                            deviceId:nil
                             preview:nil
                            distance:nil
                            duration:nil
                       locationCount:nil
                        messageCount:nil
                                 mpg:nil
                          startPoint:nil
                           stopPoint:nil
                          orphanedAt:nil
                             selfURL:nil
                           deviceURL:nil
                          vehicleURL:nil
                        locationsURL:nil
                         messagesURL:nil
                           eventsURL:nil
                               stats:nil];
    
    VLTrip *trip = [[VLTrip alloc] initWithDictionary:self.dictionary];
    XCTAssertNil(trip.vehicleURL, @"vehicleURL should be nil");
}

#pragma mark - locationsURL Tests

- (void)testWhenLocationsURLAtExists
{
    [self createDictionaryWithTripId:nil
                               start:nil
                                stop:nil
                              status:nil
                           vehicleId:nil
                            deviceId:nil
                             preview:nil
                            distance:nil
                            duration:nil
                       locationCount:nil
                        messageCount:nil
                                 mpg:nil
                          startPoint:nil
                           stopPoint:nil
                          orphanedAt:nil
                             selfURL:nil
                           deviceURL:nil
                          vehicleURL:nil
                        locationsURL:[VLTestHelper urlStr]
                         messagesURL:nil
                           eventsURL:nil
                               stats:nil];
    
    VLTrip *trip = [[VLTrip alloc] initWithDictionary:self.dictionary];
    XCTAssertNotNil(trip.locationsURL, @"locationsURL should not be nil");
    XCTAssertEqual(trip.locationsURL.absoluteString, self.dictionary[@"links"][@"locations"]);
}

- (void)testWhenLocationsURLDoesNotExists
{
    [self createDictionaryWithTripId:nil
                               start:nil
                                stop:nil
                              status:nil
                           vehicleId:nil
                            deviceId:nil
                             preview:nil
                            distance:nil
                            duration:nil
                       locationCount:nil
                        messageCount:nil
                                 mpg:nil
                          startPoint:nil
                           stopPoint:nil
                          orphanedAt:nil
                             selfURL:nil
                           deviceURL:nil
                          vehicleURL:nil
                        locationsURL:nil
                         messagesURL:nil
                           eventsURL:nil
                               stats:nil];
    
    VLTrip *trip = [[VLTrip alloc] initWithDictionary:self.dictionary];
    XCTAssertNil(trip.locationsURL, @"locationsURL should be nil");
}

#pragma mark - messagesURL Tests

- (void)testWhenMessagesURLAtExists
{
    [self createDictionaryWithTripId:nil
                               start:nil
                                stop:nil
                              status:nil
                           vehicleId:nil
                            deviceId:nil
                             preview:nil
                            distance:nil
                            duration:nil
                       locationCount:nil
                        messageCount:nil
                                 mpg:nil
                          startPoint:nil
                           stopPoint:nil
                          orphanedAt:nil
                             selfURL:nil
                           deviceURL:nil
                          vehicleURL:nil
                        locationsURL:nil
                         messagesURL:[VLTestHelper urlStr]
                           eventsURL:nil
                               stats:nil];
    
    VLTrip *trip = [[VLTrip alloc] initWithDictionary:self.dictionary];
    XCTAssertNotNil(trip.messagesURL, @"messagesURL should not be nil");
    XCTAssertEqual(trip.messagesURL.absoluteString, self.dictionary[@"links"][@"messages"]);
}

- (void)testWhenMessagesURLDoesNotExists
{
    [self createDictionaryWithTripId:nil
                               start:nil
                                stop:nil
                              status:nil
                           vehicleId:nil
                            deviceId:nil
                             preview:nil
                            distance:nil
                            duration:nil
                       locationCount:nil
                        messageCount:nil
                                 mpg:nil
                          startPoint:nil
                           stopPoint:nil
                          orphanedAt:nil
                             selfURL:nil
                           deviceURL:nil
                          vehicleURL:nil
                        locationsURL:nil
                         messagesURL:nil
                           eventsURL:nil
                               stats:nil];
    
    VLTrip *trip = [[VLTrip alloc] initWithDictionary:self.dictionary];
    XCTAssertNil(trip.messagesURL, @"messagesURL should be nil");
}

#pragma mark - eventsURL Tests

- (void)testWhenEventsURLAtExists
{
    [self createDictionaryWithTripId:nil
                               start:nil
                                stop:nil
                              status:nil
                           vehicleId:nil
                            deviceId:nil
                             preview:nil
                            distance:nil
                            duration:nil
                       locationCount:nil
                        messageCount:nil
                                 mpg:nil
                          startPoint:nil
                           stopPoint:nil
                          orphanedAt:nil
                             selfURL:nil
                           deviceURL:nil
                          vehicleURL:nil
                        locationsURL:nil
                         messagesURL:nil
                           eventsURL:[VLTestHelper urlStr]
                               stats:nil];
    
    VLTrip *trip = [[VLTrip alloc] initWithDictionary:self.dictionary];
    XCTAssertNotNil(trip.eventsURL, @"messagesURL should not be nil");
    XCTAssertEqual(trip.eventsURL.absoluteString, self.dictionary[@"links"][@"events"]);
}

- (void)testWhenEventsURLDoesNotExists
{
    [self createDictionaryWithTripId:nil
                               start:nil
                                stop:nil
                              status:nil
                           vehicleId:nil
                            deviceId:nil
                             preview:nil
                            distance:nil
                            duration:nil
                       locationCount:nil
                        messageCount:nil
                                 mpg:nil
                          startPoint:nil
                           stopPoint:nil
                          orphanedAt:nil
                             selfURL:nil
                           deviceURL:nil
                          vehicleURL:nil
                        locationsURL:nil
                         messagesURL:nil
                           eventsURL:nil
                               stats:nil];
    
    VLTrip *trip = [[VLTrip alloc] initWithDictionary:self.dictionary];
    XCTAssertNil(trip.eventsURL, @"eventsURL should be nil");
}

#pragma mark - stats Tests

- (void)testWhenStatsAtExists
{
    [self createDictionaryWithTripId:nil
                               start:nil
                                stop:nil
                              status:nil
                           vehicleId:nil
                            deviceId:nil
                             preview:nil
                            distance:nil
                            duration:nil
                       locationCount:nil
                        messageCount:nil
                                 mpg:nil
                          startPoint:nil
                           stopPoint:nil
                          orphanedAt:nil
                             selfURL:nil
                           deviceURL:nil
                          vehicleURL:nil
                        locationsURL:nil
                         messagesURL:nil
                           eventsURL:nil
                               stats:@{}];
    
    VLTrip *trip = [[VLTrip alloc] initWithDictionary:self.dictionary];
    XCTAssertNotNil(trip.stats, @"stats should not be nil");
    XCTAssertEqual(trip.stats, self.dictionary[@"stats"]);
}

- (void)testWhenStatsDoesNotExists
{
    [self createDictionaryWithTripId:nil
                               start:nil
                                stop:nil
                              status:nil
                           vehicleId:nil
                            deviceId:nil
                             preview:nil
                            distance:nil
                            duration:nil
                       locationCount:nil
                        messageCount:nil
                                 mpg:nil
                          startPoint:nil
                           stopPoint:nil
                          orphanedAt:nil
                             selfURL:nil
                           deviceURL:nil
                          vehicleURL:nil
                        locationsURL:nil
                         messagesURL:nil
                           eventsURL:nil
                               stats:nil];
    
    VLTrip *trip = [[VLTrip alloc] initWithDictionary:self.dictionary];
    XCTAssertNil(trip.stats, @"Stats should be nil");
}

@end
