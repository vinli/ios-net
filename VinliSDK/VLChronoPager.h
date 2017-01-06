//
//  VLChronoPager.h
//  VinliSDK
//
//  Created by Tommy Brown on 5/26/15.
//  Copyright (c) 2015 Vinli. All rights reserved.
//

#import "VLPager.h"


@class VLService;

/**
 VLChronoPager is a pagination object. Instead of maintaining a reference to a huge list of objects, VLChronoPager allows one to see the list of objects by pagination. Its pagination is based of a time series. For an exambple of a time series, see VLTimeSeries.
 */
@interface VLChronoPager : VLPager

/**
 This should return the number trips left to be paginated
 */
@property (readonly) NSInteger remaining;

/**
 Based on the time series passed into the service call, until can represent many values. The default value is the start date of the time series and the since value will represent a date in the past. This is a string representation of an ISO formmatted date.
 */
@property (readonly) NSString * _Nullable until;

/**
 Based on the time series passed into the service call, until can represent many values. The default value is the end date of the time series and the until value will represent the most current date. This is a string representation of an ISO formmatted date.
 */
@property (readonly) NSString * _Nullable since;

/**
 nextURL is an NSURL object representing the next endpoint to hit for pagination. nextURL will only exist if the VLChronoPager is paginating in an ascending order. This means that the VLChronoPager is paginating from the past to the most current date associated with until. Note, the default value of VLChronoPager will have a priorURL and nextURL will be nil.
 */
@property (readonly) NSURL * _Nullable nextURL;

/**
 priorURL is an NSURL object representing the next endpoint to hit for pagination. priorURL will only exist if the VLChronoPager is paginating in an descending order. This means that the VLChronoPager is paginating from the most current date, which should be assiciated with until property. Note, the default value of VLChronoPager will have a priorURL and nextURL will be nil.
 */
@property (readonly) NSURL * _Nullable priorURL;

/**
 initWithDictionary:service: is class initializer of VLChronoPager

 @param dictionary dictionary is the JSON object typically associated for creating the VLChronoPager. This dictionary should contain all the property
 values of its superclass, VLPager.
 @param service    A VLService object has to be passed along to initialize the VLChronoPager because a pager object will need to be authenticated in order to query for more objects.

 @return should an instance of VLChronoPager
 */
- (nullable instancetype)initWithDictionary:(NSDictionary * _Nullable)dictionary service:(VLService * _Nullable)service;

// TODO -- update documentation
- (void)getNext:(void (^ _Nullable)( NSArray * _Nullable newValues, NSError * _Nullable error))completion;

@end
