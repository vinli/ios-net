//
//  VLPagerUnitTests.m
//  VinliSDK
//
//  Created by Bryan on 9/27/16.
//  Copyright © 2016 Vinli. All rights reserved.
//

#import <XCTest/XCTest.h>

#import "VLPager.h"
#import "VLService.h"

@interface VLPagerUnitTests : XCTestCase

@property (strong, nonatomic) NSDictionary *dictionary; // JSON Dict to initialize object
@property (strong, nonatomic) VLService *service;

@end

@implementation VLPagerUnitTests

#pragma mark - Class Methods

- (void)createDictionaryWithLimit:(NSNumber * _Nullable)limit
{
    self.dictionary = @{ @"meta": @{
                                 @"pagination" : @{
                                         @"limit" : limit
                                         }
                                 }
                         };
}

- (void)createDictionaryWithNullLimit
{
    self.dictionary = @{ @"meta": @{
                                 @"pagination" : @{
                                         @"limit" : [NSNull null]
                                         }
                                 }
                         };
}

#pragma mark - Tests

- (void)setUp
{
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
    
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

- (void)testInitWithDictionaryWithSmallLimit
{
    [self createDictionaryWithLimit:@1];
    VLPager *pager = [[VLPager alloc] initWithDictionary:self.dictionary];
    XCTAssertEqual(pager.limit, [self.dictionary[@"meta"][@"pagination"][@"limit"] unsignedLongValue], @"Limit should equal the limit passed in by the dictionary as long as it is less than the limit: 50.");
    XCTAssertNil(pager.service, @"serice should be nil");
    XCTAssertLessThanOrEqual(pager.limit, 50, @"Limit should always be less than or equal the limit: 50");
}

- (void)testInitWithDictionaryWithBigLimit
{
    [self createDictionaryWithLimit:@100];
    VLPager *pager = [[VLPager alloc] initWithDictionary:self.dictionary];
    XCTAssertNotEqual(pager.limit, [self.dictionary[@"meta"][@"pagination"][@"limit"] unsignedLongValue], @"Limit should not be equal to the dictionary limit since it is greater than the limit of pagination we allow.");
    XCTAssertNil(pager.service, @"serice should be nil");
    XCTAssertEqual(pager.limit, 50, @"Limit should always be equal the limit, 50, if it greater than the limit we allow");
}

- (void)testInitWithDictionaryAndServiceWithSmallLimit
{
    [self createDictionaryWithLimit:@1];
    VLPager *pager = [[VLPager alloc] initWithDictionary:self.dictionary service:self.service];
    XCTAssertEqual(pager.limit, [self.dictionary[@"meta"][@"pagination"][@"limit"] unsignedLongValue], @"Limit should equal the limit passed in by the dictionary as long as it is less than the limit: 50.");
    XCTAssertNotNil(pager.service, @"Service should not be nil");
    XCTAssertLessThanOrEqual(pager.limit, 50, @"Limit should always be less than or equal the limit: 50");
}

- (void)testInitWithDictionaryAndServiceWithBigLimit
{
    [self createDictionaryWithLimit:@100];
    VLPager *pager = [[VLPager alloc] initWithDictionary:self.dictionary service:self.service];
    XCTAssertNotEqual(pager.limit, [self.dictionary[@"meta"][@"pagination"][@"limit"] unsignedLongValue], @"Limit should not be equal to the dictionary limit since it is greater than the limit of pagination we allow.");
    XCTAssertNotNil(pager.service, @"Service should not be nil");
    XCTAssertEqual(pager.limit, 50, @"Limit should always be equal the limit, 50, if it greater than the limit we allow");
}

#pragma mark - NSNull Tests

- (void)testDictionaryWithNullValuesAndWithService
{
    [self createDictionaryWithNullLimit];
    
    VLPager *pager = [[VLPager alloc] initWithDictionary:self.dictionary service:self.service];
    XCTAssertNotNil(pager.service, @"Service should not be nil");
    XCTAssertEqual(pager.limit, 0, @"Limit should be zero if key-value object is NSNull");
}

@end
