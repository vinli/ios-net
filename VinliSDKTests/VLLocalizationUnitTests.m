//
//  VLLocalizationUnitTests.m
//  VinliSDKTests
//
//  Created by Shawn Casey on 12/13/19.
//  Copyright © 2019 Vinli. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "VLUnitLocalizer.h"

@interface VLLocalizationUnitTests : XCTestCase

@end

@implementation VLLocalizationUnitTests

- (void)setUp {
	// Put setup code here. This method is called before the invocation of each test method in the class.
	[VLUnitLocalizer initialize];
}

- (void)tearDown {
	// Put teardown code here. This method is called after the invocation of each test method in the class.
}

- (void)testMpg {
	[VLUnitLocalizer setLocalizedUnitWithUnitString:kVLLocalizationManagerUnitImperialUK];
	XCTAssertEqualWithAccuracy([VLUnitLocalizer localizedFuelEconomy:@(100.0f)].floatValue, 120.09f, 0.01f);
	XCTAssertEqualWithAccuracy([VLUnitLocalizer localizedFuelEconomy:@(0.0f)].floatValue, 0.0f, 0.01f);
	[VLUnitLocalizer setLocalizedUnitWithUnitString:kVLLocalizationManagerUnitImperialUS];
	XCTAssertEqualWithAccuracy([VLUnitLocalizer localizedFuelEconomy:@(100.0f)].floatValue, 100.0f, 0.01f);
	XCTAssertEqualWithAccuracy([VLUnitLocalizer localizedFuelEconomy:@(0.0f)].floatValue, 0.0f, 0.01f);
	[VLUnitLocalizer setLocalizedUnitWithUnitString:kVLLocalizationManagerUnitMetric];
	XCTAssertEqualWithAccuracy([VLUnitLocalizer localizedFuelEconomy:@(100.0f)].floatValue, 2.35f, 0.01f);
	XCTAssertEqualWithAccuracy([VLUnitLocalizer localizedFuelEconomy:@(0.0f)].floatValue, 0.0f, 0.01f);
}

- (void)testLiquidCapacity {
	[VLUnitLocalizer setLocalizedUnitWithUnitString:kVLLocalizationManagerUnitMetric];
	XCTAssertEqualWithAccuracy([VLUnitLocalizer localizedLiquidCapacity:@(100.0f)].floatValue, 100.0f, 0.01f);
	XCTAssertEqualWithAccuracy([VLUnitLocalizer localizedLiquidCapacity:@(0.0f)].floatValue, 0.0f, 0.01f);
	[VLUnitLocalizer setLocalizedUnitWithUnitString:kVLLocalizationManagerUnitImperialUK];
	XCTAssertEqualWithAccuracy([VLUnitLocalizer localizedLiquidCapacity:@(100.0f)].floatValue, 21.9969f, 0.01f);
	XCTAssertEqualWithAccuracy([VLUnitLocalizer localizedLiquidCapacity:@(0.0f)].floatValue, 0.0f, 0.01f);
	[VLUnitLocalizer setLocalizedUnitWithUnitString:kVLLocalizationManagerUnitImperialUS];
	XCTAssertEqualWithAccuracy([VLUnitLocalizer localizedLiquidCapacity:@(100.0f)].floatValue, 26.4172f, 0.01f);
	XCTAssertEqualWithAccuracy([VLUnitLocalizer localizedLiquidCapacity:@(0.0f)].floatValue, 0.0f, 0.01f);
}

//
- (void)testSpeed {
	[VLUnitLocalizer setLocalizedUnitWithUnitString:kVLLocalizationManagerUnitMetric]; // kph -> kph
	XCTAssertEqualWithAccuracy([VLUnitLocalizer localizedSpeed:@(100.0f)].floatValue, 100.0f, 0.01f);
	XCTAssertEqualWithAccuracy([VLUnitLocalizer localizedSpeed:@(0.0f)].floatValue, 0.0f, 0.01f);
	[VLUnitLocalizer setLocalizedUnitWithUnitString:kVLLocalizationManagerUnitImperialUK]; // kph -> mph
	XCTAssertEqualWithAccuracy([VLUnitLocalizer localizedSpeed:@(100.0f)].floatValue, 62.13712f, 0.01f);
	XCTAssertEqualWithAccuracy([VLUnitLocalizer localizedSpeed:@(0.0f)].floatValue, 0.0f, 0.01f);
	[VLUnitLocalizer setLocalizedUnitWithUnitString:kVLLocalizationManagerUnitImperialUS]; // kph -> mph
	XCTAssertEqualWithAccuracy([VLUnitLocalizer localizedSpeed:@(100.0f)].floatValue, 62.13712f, 0.01f);
	XCTAssertEqualWithAccuracy([VLUnitLocalizer localizedSpeed:@(0.0f)].floatValue, 0.0f, 0.01f);
}

- (void)testDistance {
	[VLUnitLocalizer setLocalizedUnitWithUnitString:kVLLocalizationManagerUnitMetric]; // meters -> km
	XCTAssertEqualWithAccuracy([VLUnitLocalizer localizedDistance:@(10000.0f)].floatValue, 10.0f, 0.01f);
	XCTAssertEqualWithAccuracy([VLUnitLocalizer localizedDistance:@(0.0f)].floatValue, 0.0f, 0.01f);
	[VLUnitLocalizer setLocalizedUnitWithUnitString:kVLLocalizationManagerUnitImperialUK]; // meters -> mi
	XCTAssertEqualWithAccuracy([VLUnitLocalizer localizedDistance:@(10000.0f)].floatValue, 6.213712f, 0.01f);
	XCTAssertEqualWithAccuracy([VLUnitLocalizer localizedDistance:@(0.0f)].floatValue, 0.0f, 0.01f);
	[VLUnitLocalizer setLocalizedUnitWithUnitString:kVLLocalizationManagerUnitImperialUS]; // meters -> mi
	XCTAssertEqualWithAccuracy([VLUnitLocalizer localizedDistance:@(10000.0f)].floatValue, 6.213712f, 0.01f);
	XCTAssertEqualWithAccuracy([VLUnitLocalizer localizedDistance:@(0.0f)].floatValue, 0.0f, 0.01f);
}

- (void)testBooleans {
	[VLUnitLocalizer setLocalizedUnitWithUnitString:kVLLocalizationManagerUnitMetric];
	XCTAssertTrue([VLUnitLocalizer isMetric]);
	[VLUnitLocalizer setLocalizedUnitWithUnitString:kVLLocalizationManagerUnitImperialUK];
	XCTAssertTrue([VLUnitLocalizer isImperialUK]);
	[VLUnitLocalizer setLocalizedUnitWithUnitString:kVLLocalizationManagerUnitImperialUS];
	XCTAssertTrue([VLUnitLocalizer isImperialUS]);
}

- (void)testUnitsUK {
	[VLUnitLocalizer setLocalizedUnitWithUnitString:kVLLocalizationManagerUnitImperialUK];
	XCTAssertTrue([[VLUnitLocalizer localizedDistanceUnit] isEqualToString:@"mile"]);
	XCTAssertTrue([[VLUnitLocalizer localizedDistanceUnitPlural] isEqualToString:@"miles"]);
	XCTAssertTrue([[VLUnitLocalizer localizedDistanceUnitPluralShort] isEqualToString:@"mi"]);
	XCTAssertTrue([[VLUnitLocalizer localizedSpeedUnit] isEqualToString:@"miles per hour"]);
	XCTAssertTrue([[VLUnitLocalizer localizedSpeedUnitShort] isEqualToString:@"Mi/h"]);
	XCTAssertTrue([[VLUnitLocalizer localizedSpeedUnitShortLettersOnly] isEqualToString:@"mph"]);
	XCTAssertTrue([[VLUnitLocalizer localizedLiquidCapacityUnit] isEqualToString:@"gallon"]);
	XCTAssertTrue([[VLUnitLocalizer localizedLiquidCapacityUnitShort] isEqualToString:@"gal"]);
	XCTAssertTrue([[VLUnitLocalizer localizedLiquidCapacityUnitPlural] isEqualToString:@"gallons"]);
	XCTAssertTrue([[VLUnitLocalizer localizedFuelEconomyUnit] isEqualToString:@"miles per gallon"]);
	XCTAssertTrue([[VLUnitLocalizer localizedFuelEconomyUnitShort] isEqualToString:@"mpg"]);
}

- (void)testUnitsUS {
	[VLUnitLocalizer setLocalizedUnitWithUnitString:kVLLocalizationManagerUnitImperialUK];
	XCTAssertTrue([[VLUnitLocalizer localizedDistanceUnit] isEqualToString:@"mile"]);
	XCTAssertTrue([[VLUnitLocalizer localizedDistanceUnitPlural] isEqualToString:@"miles"]);
	XCTAssertTrue([[VLUnitLocalizer localizedDistanceUnitPluralShort] isEqualToString:@"mi"]);
	XCTAssertTrue([[VLUnitLocalizer localizedSpeedUnit] isEqualToString:@"miles per hour"]);
	XCTAssertTrue([[VLUnitLocalizer localizedSpeedUnitShort] isEqualToString:@"Mi/h"]);
	XCTAssertTrue([[VLUnitLocalizer localizedSpeedUnitShortLettersOnly] isEqualToString:@"mph"]);
	XCTAssertTrue([[VLUnitLocalizer localizedLiquidCapacityUnit] isEqualToString:@"gallon"]);
	XCTAssertTrue([[VLUnitLocalizer localizedLiquidCapacityUnitShort] isEqualToString:@"gal"]);
	XCTAssertTrue([[VLUnitLocalizer localizedLiquidCapacityUnitPlural] isEqualToString:@"gallons"]);
	XCTAssertTrue([[VLUnitLocalizer localizedFuelEconomyUnit] isEqualToString:@"miles per gallon"]);
	XCTAssertTrue([[VLUnitLocalizer localizedFuelEconomyUnitShort] isEqualToString:@"mpg"]);
}

- (void)testUnitsMetric {
	[VLUnitLocalizer setLocalizedUnitWithUnitString:kVLLocalizationManagerUnitMetric];
	XCTAssertTrue([[VLUnitLocalizer localizedDistanceUnit] isEqualToString:@"kilometer"]);
	XCTAssertTrue([[VLUnitLocalizer localizedDistanceUnitPlural] isEqualToString:@"kilometers"]);
	XCTAssertTrue([[VLUnitLocalizer localizedDistanceUnitPluralShort] isEqualToString:@"km"]);
	XCTAssertTrue([[VLUnitLocalizer localizedSpeedUnit] isEqualToString:@"kilometers per hour"]);
	XCTAssertTrue([[VLUnitLocalizer localizedSpeedUnitShort] isEqualToString:@"Km/h"]);
	XCTAssertTrue([[VLUnitLocalizer localizedSpeedUnitShortLettersOnly] isEqualToString:@"kph"]);
	XCTAssertTrue([[VLUnitLocalizer localizedLiquidCapacityUnit] isEqualToString:@"liter"]);
	XCTAssertTrue([[VLUnitLocalizer localizedLiquidCapacityUnitShort] isEqualToString:@"L"]);
	XCTAssertTrue([[VLUnitLocalizer localizedLiquidCapacityUnitPlural] isEqualToString:@"liters"]);
	XCTAssertTrue([[VLUnitLocalizer localizedFuelEconomyUnit] isEqualToString:@"liters per 100 kilometers"]);
	XCTAssertTrue([[VLUnitLocalizer localizedFuelEconomyUnitShort] isEqualToString:@"L/100 km"]);
}

@end
