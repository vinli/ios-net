//
//  VLTripPager.h
//  VinliSDK
//
//  Created by Tommy Brown on 5/26/15.
//  Copyright (c) 2015 Vinli. All rights reserved.
//

#import "VLChronoPager.h"
#import "VLTrip.h"

@class VLService;

/**
 VLTripPager is a subclass of both VLChronoPager and VLPager. It allows one to maintain a reference to a list of trips but also to paginate trips instead of maintaining a reference to all of a device's list of trips. The VLTripPager will allow paginating based on its superclass's, VLChronoPager, properties remaining, priorURL, and nextURL.
 */
@interface VLTripPager : VLChronoPager

/**
 Trip is the array of trips the VLTripPager is paginating from. Everytime you call, getNextTrips: the trips array should be updated with the new trips as long as the VLTripPager still has remaining trips.
 */
@property (readonly) NSMutableArray * _Nullable trips;

/**
 initWithDictionary:service: initializes the VLTripPager object

 @param dictionary dictionary is the JSON object typically associated for creating the VLTripPager. This dictionary should contain all the property values of its superclass, VLChronoPager.
 
 @param service    A VLService object has to be passed along to initialize the VLTripPager because a pager object will need to be authenticated in order to query for more trips.

 @return should return a VLTripPager object
 */
- (nullable instancetype)initWithDictionary:(NSDictionary * _Nullable)dictionary service:(VLService * _Nullable)service;

/**
 getNextTrips will return a list of VLTrip objects. The number of VLTrip objects is dependent on two properties of VLTripPager. Depending on the number in the limit property, the return call should return the same number of VLTrip objects as the limit. Also, if the remaining property is less than the limit property, then the return call should return the number of remaining trips for VLTrip objects instead of number associated with the limit property.
 
 If you try to get the next set of trips when remaining equals zero, then the return call will pass back an empty NSArray. 
 
 The error object for the block should only exist if you improperly call for more trips. This can happen for a number reasons like if
 you are not properly authenticated.

 @param completion completion is a block that will return an NSArray of VLTrips or an NSError. There will never be a case where both are returned.
 */
- (void)getNextTrips:(void(^_Nonnull)(NSArray<VLTrip*> * _Nullable nextTrips, NSError * _Nullable error))completion;

@end
