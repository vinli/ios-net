//
//  VLErrorConstants.m
//  VinliSDK
//
//  Created by Bryan on 10/12/16.
//  Copyright © 2016 Vinli. All rights reserved.
//

#import "VLErrorConstants.h"

@implementation VLErrorConstants

#pragma mark - Error Domains

NSString * const VLErrorDomainExistingOdometerWithSameValues = @"Conflict: Existing odometer has same values";
NSString * const VLErrorDomainExistingOdometerWithSmallerReadingThanPrevious = @"Conflict: Existing odometer has larger reading than new odometer";
NSString * const VLErrorDomainExistingOdometerWithOlderDateThanPrevious = @"Conflict: Existing odometer has older date than new odometer";

#pragma mark - Error Messages

NSString * const VLErrorMessageExistingOdometerWithSameValues = @"An odometer with these qualities already exists for vehicle with id:";
NSString * const VLErrorMessageExistingOdometerWithSmallerReadingThanPrevious = @"Cannot create an newer odometer with a lesser reading than an existing older odometer";
NSString * const VLErrorMessageExistingOdometerWithOlderDateThanPrevious = @"Cannot create an older odometer with a greater reading than an existing newer odometer";

#pragma mark - Error Codes

NSInteger const VLErrorCodeExistingOdometerWithSameValues = 4091;
NSInteger const VLErrorCodeExistingOdometerWithSmallerReadingThanPrevious = 4092;
NSInteger const VLErrorCodeExistingOdometerWithOlderDateThanPrevious = 4093;

@end
