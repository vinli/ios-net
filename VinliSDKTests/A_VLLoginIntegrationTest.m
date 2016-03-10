//
//  A_VLLoginIntegrationTest.m
//  VinliSDK
//
//  Created by Jai Ghanekar on 2/22/16.
//  Copyright © 2016 Vinli. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "VLSessionManager.h"
#import "VLService.h"
#import "VLTestHelper.h"


@interface A_VLLoginIntegrationTest : XCTestCase
@property NSString *userId;
@end

@implementation A_VLLoginIntegrationTest

- (void)setUp {
    [super setUp];
    self.userId = @"1f9e308a-60e9-4503-83d3-7e6b157fb304";
}


- (void)testLogin {
    
    [[VLSessionManager sharedManager].service useSession:[[VLSession alloc]initWithAccessToken:[VLTestHelper accessToken] userId:self.userId]];
    
}


- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}


@end
