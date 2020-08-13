//
//  VLVehicle.m
//  VinliSDK
//
//  Created by Tommy Brown on 5/21/15.
//  Copyright (c) 2015 Cheng Gu. All rights reserved.
//

#import "VLVehicle.h"
#import "NSDictionary+NonNullable.h"

@implementation VLVehicle

- (id)initWithDictionary:(NSDictionary *)dictionary{
	if (self = [super init]) {
		if (dictionary) {
			NSDictionary *vehicle = [dictionary vl_getDictionaryAttributeForKey:@"vehicle" defaultValue:nil];
			if (vehicle == nil) {
				vehicle = dictionary;
			}

			_rawDictionary = vehicle;
			_vehicleId = [vehicle vl_getStringAttributeForKey:@"id" defaultValue:nil];
			_year = [vehicle vl_getStringAttributeForKey:@"year" defaultValue:nil];
			_make = [vehicle vl_getStringAttributeForKey:@"make" defaultValue:nil];
			_model = [vehicle vl_getStringAttributeForKey:@"model" defaultValue:nil];
			_trim = [vehicle vl_getStringAttributeForKey:@"trim" defaultValue:nil];
			_vin = [vehicle vl_getStringAttributeForKey:@"vin" defaultValue:nil];
			_registrationNumber = [vehicle vl_getStringAttributeForKey:@"registrationNumber" defaultValue:nil];
		}
	}
	return self;
}

- (NSString *)description {
	return [NSString stringWithFormat: @"Vehicle ID: %@, Year: %@, Make: %@, Model: %@, VIN: %@, RegNum: %@", _vehicleId, _year, _make, _model, _vin, _registrationNumber];
}

- (NSDictionary *)toDictionary {
	return @{
		@"id" : _vehicleId.length > 0 ? _vehicleId : @"",
		@"year" : _year.length > 0 ? _year : @"",
		@"make" : _make.length > 0 ? _make : @"",
		@"model" : _model.length > 0 ? _model : @"",
		@"trim" : _trim.length > 0 ? _trim : @"",
		@"vin" : _vin.length > 0 ? _vin : @"",
		@"registrationNumber" : _registrationNumber.length > 0 ? _registrationNumber : @"",
	};
}

@end
