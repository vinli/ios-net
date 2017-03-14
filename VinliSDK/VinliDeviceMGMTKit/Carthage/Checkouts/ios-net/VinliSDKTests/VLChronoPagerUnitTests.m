//
//  VLChronoPagerUnitTests.m
//  VinliSDK
//
//  Created by Bryan on 9/28/16.
//  Copyright © 2016 Vinli. All rights reserved.
//

#import <XCTest/XCTest.h>

#import "VLService.h"
#import "VLChronoPager.h"

NSString * const kDateStringIdentifier = @"2015-12-15T06:00:00.000Z";
NSString * const kUrlStringIdentifier = @"https://vin.li";

@interface VLChronoPagerUnitTests : XCTestCase

@property (strong, nonatomic) NSDictionary *dictionary; // JSON Dict to initialize object
@property (strong, nonatomic) VLService *service;

@end

@implementation VLChronoPagerUnitTests

#pragma mark - Class Methods

- (void)createDictionaryWithRemaining:(NSNumber *)remaining since:(NSString *)since until:(NSString *)until nextURL:(NSString *)nextURL priorURL:(NSString *)priorURL
{
    NSMutableDictionary *mutableDict = [NSMutableDictionary new];
    [mutableDict setObject:[NSMutableDictionary new] forKey:@"meta"];
    [mutableDict[@"meta"] setObject:[NSMutableDictionary new] forKey:@"pagination"];
    if (remaining)
    {
        [mutableDict[@"meta"][@"pagination"] setObject:remaining forKey:@"remaining"];
    }
    if (since.length > 0)
    {
        [mutableDict[@"meta"][@"pagination"] setObject:since forKey:@"since"];
    }
    if (until.length > 0)
    {
        [mutableDict[@"meta"][@"pagination"] setObject:until forKey:@"until"];
    }
    
    if (nextURL.length > 0)
    {
        [mutableDict[@"meta"][@"pagination"] setObject:[NSMutableDictionary new] forKey:@"links"];
        [mutableDict[@"meta"][@"pagination"] setObject:nextURL forKey:@"next"];
    }
    
    if (priorURL.length > 0)
    {
        [mutableDict[@"meta"][@"pagination"] setObject:[NSMutableDictionary new] forKey:@"links"];
        [mutableDict[@"meta"][@"pagination"] setObject:priorURL forKey:@"prior"];
    }
    
    self.dictionary = mutableDict;
}

- (void)createNullKeyObjectJSONDict
{
    NSMutableDictionary *mutableDict = [NSMutableDictionary new];
    [mutableDict setObject:[NSMutableDictionary new] forKey:@"meta"];
    [mutableDict[@"meta"] setObject:[NSMutableDictionary new] forKey:@"pagination"];
    
    [mutableDict[@"meta"][@"pagination"] setObject:[NSNull null] forKey:@"remaining"];

    [mutableDict[@"meta"][@"pagination"] setObject:[NSNull null] forKey:@"since"];

    [mutableDict[@"meta"][@"pagination"] setObject:[NSNull null] forKey:@"until"];

    
    [mutableDict[@"meta"][@"pagination"] setObject:[NSMutableDictionary new] forKey:@"links"];
    [mutableDict[@"meta"][@"pagination"] setObject:[NSNull null] forKey:@"next"];
    
    [mutableDict[@"meta"][@"pagination"] setObject:[NSNull null] forKey:@"prior"];
    
    self.dictionary = mutableDict;
}

#pragma mark - Tests

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
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

#pragma mark - Remaining Tests

- (void)testInitWithDictionaryWithRemaining
{
    [self createDictionaryWithRemaining:@1 since:nil until:nil nextURL:nil priorURL:nil];
    VLChronoPager *pager = [[VLChronoPager alloc] initWithDictionary:self.dictionary];
    XCTAssertEqual(pager.remaining, [self.dictionary[@"meta"][@"pagination"][@"remaining"] unsignedLongValue], @"Remaing property should equal the remaining key value of the passing in dictionary.");
    XCTAssertNil(pager.service, @"serice should be nil");
}

- (void)testInitWithDictionaryAndServiceWithRemaining
{
    [self createDictionaryWithRemaining:@1 since:nil until:nil nextURL:nil priorURL:nil];
    VLChronoPager *pager = [[VLChronoPager alloc] initWithDictionary:self.dictionary service:self.service];
    XCTAssertEqual(pager.remaining, [self.dictionary[@"meta"][@"pagination"][@"remaining"] unsignedLongValue], @"Remaing property should equal the remaining key value of the passing in dictionary.");
    XCTAssertNotNil(pager.service, @"serice should not be nil");
}

- (void)testInitWithDictionaryWithoutRemaining
{
    [self createDictionaryWithRemaining:nil since:nil until:nil nextURL:nil priorURL:nil];
    VLChronoPager *pager = [[VLChronoPager alloc] initWithDictionary:self.dictionary];
    XCTAssertEqual(pager.remaining, 0, @"Remaing property should equal 0 if the key from the dictionary being passed in does not exist.");
    XCTAssertNil(pager.service, @"serice should be nil");
}

- (void)testInitWithDictionaryAndServiceWithoutRemaining
{
    [self createDictionaryWithRemaining:nil since:nil until:nil nextURL:nil priorURL:nil];
    VLChronoPager *pager = [[VLChronoPager alloc] initWithDictionary:self.dictionary service:self.service];
    XCTAssertEqual(pager.remaining, 0, @"Remaing property should equal 0 if the key from the dictionary being passed in does not exist.");
    XCTAssertNotNil(pager.service, @"serice should not be nil");
}

#pragma mark - Since Tests

- (void)testInitWithDictionaryWithSince
{
    [self createDictionaryWithRemaining:nil since:kDateStringIdentifier until:nil nextURL:nil priorURL:nil];
    VLChronoPager *pager = [[VLChronoPager alloc] initWithDictionary:self.dictionary];
    XCTAssertEqualObjects(pager.since, self.dictionary[@"meta"][@"pagination"][@"since"], @"Since property should equal the since key value of the passing in dictionary.");
    XCTAssertNil(pager.service, @"serice should be nil");
}

- (void)testInitWithDictionaryAndServiceWithSince
{
    [self createDictionaryWithRemaining:nil since:kDateStringIdentifier until:nil nextURL:nil priorURL:nil];
    VLChronoPager *pager = [[VLChronoPager alloc] initWithDictionary:self.dictionary service:self.service];
    XCTAssertEqualObjects(pager.since, self.dictionary[@"meta"][@"pagination"][@"since"], @"Since property should equal the since key value of the passing in dictionary.");
    XCTAssertNotNil(pager.service, @"serice should not be nil");
}

- (void)testInitWithDictionaryWithoutSince
{
    [self createDictionaryWithRemaining:nil since:nil until:nil nextURL:nil priorURL:nil];
    VLChronoPager *pager = [[VLChronoPager alloc] initWithDictionary:self.dictionary];
    XCTAssertNil(pager.since, @"Since should be nil because key value does not exist.");
    XCTAssertNil(pager.service, @"serice should be nil");
}

- (void)testInitWithDictionaryAndServiceWithoutSince
{
    [self createDictionaryWithRemaining:nil since:nil until:nil nextURL:nil priorURL:nil];
    VLChronoPager *pager = [[VLChronoPager alloc] initWithDictionary:self.dictionary service:self.service];
    XCTAssertNil(pager.since, @"Since should be nil because key value does not exist.");
    XCTAssertNotNil(pager.service, @"serice should not be nil");
}


#pragma mark - Until Tests

- (void)testInitWithDictionaryWithUntil
{
    [self createDictionaryWithRemaining:nil since:nil until:kDateStringIdentifier nextURL:nil priorURL:nil];
    VLChronoPager *pager = [[VLChronoPager alloc] initWithDictionary:self.dictionary];
    XCTAssertEqualObjects(pager.until, self.dictionary[@"meta"][@"pagination"][@"until"], @"Until property should equal the until key value of the passing in dictionary.");
    XCTAssertNil(pager.service, @"serice should be nil");
}

- (void)testInitWithDictionaryAndServiceWithUntil
{
    [self createDictionaryWithRemaining:nil since:nil until:kDateStringIdentifier nextURL:nil priorURL:nil];
    VLChronoPager *pager = [[VLChronoPager alloc] initWithDictionary:self.dictionary service:self.service];
    XCTAssertEqualObjects(pager.until, self.dictionary[@"meta"][@"pagination"][@"until"], @"Until property should equal the until key value of the passing in dictionary.");
    XCTAssertNotNil(pager.service, @"serice should not be nil");
}

- (void)testInitWithDictionaryWithoutUntil
{
    [self createDictionaryWithRemaining:nil since:nil until:nil nextURL:nil priorURL:nil];
    VLChronoPager *pager = [[VLChronoPager alloc] initWithDictionary:self.dictionary];
    XCTAssertNil(pager.until, @"Until should be nil because key value does not exist.");
    XCTAssertNil(pager.service, @"serice should be nil");
}

- (void)testInitWithDictionaryAndServiceWithoutUntil
{
    [self createDictionaryWithRemaining:nil since:nil until:nil nextURL:nil priorURL:nil];
    VLChronoPager *pager = [[VLChronoPager alloc] initWithDictionary:self.dictionary service:self.service];
    XCTAssertNil(pager.until, @"Until should be nil because key value does not exist.");
    XCTAssertNotNil(pager.service, @"serice should not be nil");
}

#pragma mark - nextURL Tests

- (void)testInitWithDictionaryWithNextURL
{
    [self createDictionaryWithRemaining:nil since:nil until:nil nextURL:kUrlStringIdentifier priorURL:nil];
    VLChronoPager *pager = [[VLChronoPager alloc] initWithDictionary:self.dictionary];
    XCTAssertEqualObjects(pager.nextURL, self.dictionary[@"meta"][@"pagination"][@"nextURL"], @"nextURL property should equal the nextURL key value of the passing in dictionary.");
    XCTAssertNil(pager.service, @"serice should be nil");
}

- (void)testInitWithDictionaryAndServiceWithNextURL
{
    [self createDictionaryWithRemaining:nil since:nil until:nil nextURL:kUrlStringIdentifier priorURL:nil];
    VLChronoPager *pager = [[VLChronoPager alloc] initWithDictionary:self.dictionary service:self.service];
    XCTAssertEqualObjects(pager.nextURL, self.dictionary[@"meta"][@"pagination"][@"nextURL"], @"nextURL property should equal the nextURL key value of the passing in dictionary.");
    XCTAssertNotNil(pager.service, @"serice should not be nil");
}

- (void)testInitWithDictionaryWithoutNextURL
{
    [self createDictionaryWithRemaining:nil since:nil until:nil nextURL:nil priorURL:nil];
    VLChronoPager *pager = [[VLChronoPager alloc] initWithDictionary:self.dictionary];
    XCTAssertNil(pager.nextURL, @"Until should be nil because key value does not exist.");
    XCTAssertNil(pager.service, @"serice should be nil");
}

- (void)testInitWithDictionaryAndServiceWithoutNextURL
{
    [self createDictionaryWithRemaining:nil since:nil until:nil nextURL:nil priorURL:nil];
    VLChronoPager *pager = [[VLChronoPager alloc] initWithDictionary:self.dictionary service:self.service];
    XCTAssertNil(pager.nextURL, @"Until should be nil because key value does not exist.");
    XCTAssertNotNil(pager.service, @"serice should not be nil");
}

#pragma mark - priorURL Tests

- (void)testInitWithDictionaryWithPriorURL
{
    [self createDictionaryWithRemaining:nil since:nil until:nil nextURL:nil priorURL:kUrlStringIdentifier];
    VLChronoPager *pager = [[VLChronoPager alloc] initWithDictionary:self.dictionary];
    XCTAssertEqualObjects(pager.priorURL, self.dictionary[@"meta"][@"pagination"][@"priorURL"], @"priorURL property should equal the priorURL key value of the passing in dictionary.");
    XCTAssertNil(pager.service, @"serice should be nil");
}

- (void)testInitWithDictionaryAndServiceWithPriorURL
{
    [self createDictionaryWithRemaining:nil since:nil until:nil nextURL:nil priorURL:kUrlStringIdentifier];
    VLChronoPager *pager = [[VLChronoPager alloc] initWithDictionary:self.dictionary service:self.service];
    XCTAssertEqualObjects(pager.priorURL, self.dictionary[@"meta"][@"pagination"][@"priorURL"], @"priorURL property should equal the priorURL key value of the passing in dictionary.");
    XCTAssertNotNil(pager.service, @"serice should not be nil");
}

- (void)testInitWithDictionaryWithoutPriorURL
{
    [self createDictionaryWithRemaining:nil since:nil until:nil nextURL:nil priorURL:nil];
    VLChronoPager *pager = [[VLChronoPager alloc] initWithDictionary:self.dictionary];
    XCTAssertNil(pager.priorURL, @"Until should be nil because key value does not exist.");
    XCTAssertNil(pager.service, @"serice should be nil");
}

- (void)testInitWithDictionaryAndServiceWithoutPriorURL
{
    [self createDictionaryWithRemaining:nil since:nil until:nil nextURL:nil priorURL:nil];
    VLChronoPager *pager = [[VLChronoPager alloc] initWithDictionary:self.dictionary service:self.service];
    XCTAssertNil(pager.priorURL, @"Until should be nil because key value does not exist.");
    XCTAssertNotNil(pager.service, @"serice should not be nil");
}

#pragma mark - Null tests

- (void)testInitWithDictionaryWithNullKeyValueDictionary
{
    [self createNullKeyObjectJSONDict];
    
    VLChronoPager *chronoPager = [[VLChronoPager alloc] initWithDictionary:self.dictionary];
    
    XCTAssertEqual(chronoPager.remaining, 0, @"Remainig should equal zero when the JSON object's remaining key is NSNull because it is a primitive type.");
    XCTAssertNil(chronoPager.until, @"Until should be nil when the JSON object's key until is NSNull");
    XCTAssertNil(chronoPager.since, @"Since should be nil when the JSON object's key since is NSNull");
    XCTAssertNil(chronoPager.nextURL, @"NextURL should be nil when the JSON object's key nextURL is NSNull");
    XCTAssertNil(chronoPager.priorURL, @"PriorURL should be nil when the JSON object's key priorURL is NSNull");
}

@end
