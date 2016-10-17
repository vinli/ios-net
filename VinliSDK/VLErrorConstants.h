//
//  VLErrorConstants.h
//  VinliSDK
//
//  Created by Bryan on 10/12/16.
//  Copyright © 2016 Vinli. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 These constants will represent out custom error messaging system.
 */
@interface VLErrorConstants : NSObject

#pragma mark - Error Domains

extern NSString * const VLErrorDomainExistingOdometerWithSameValues;
extern NSString * const VLErrorDomainExistingOdometerWithSmallerReadingThanPrevious;
extern NSString * const VLErrorDomainExistingOdometerWithOlderDateThanPrevious;

#pragma mark - Error Messages

extern NSString * const VLErrorMessageExistingOdometerWithSameValues;
extern NSString * const VLErrorMessageExistingOdometerWithSmallerReadingThanPrevious;
extern NSString * const VLErrorMessageExistingOdometerWithOlderDateThanPrevious;

#pragma mark - Error Codes

extern NSInteger const VLErrorCodeExistingOdometerWithSameValues;
extern NSInteger const VLErrorCodeExistingOdometerWithSmallerReadingThanPrevious;
extern NSInteger const VLErrorCodeExistingOdometerWithOlderDateThanPrevious;

@end
