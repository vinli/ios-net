//
//  VLPager.h
//  VinliSDK
//
//  Created by Tommy Brown on 5/26/15.
//  Copyright (c) 2015 Vinli. All rights reserved.
//

#import <Foundation/Foundation.h>

@class VLService;

/**
 VLPager is a pagination object. Instead of maintaining a reference to a huge list of objects, VLPager allows one to see the list of objects by pagination. VLPager is the parent pagination object.
 */
@interface VLPager : NSObject

/**
 Limit is the number of objects that are allowed to be paginated at a time. Limit will default to 50 objects at a time if the service returns a higher value for limit. Therefore, limit will always be at most 50 objects at a time.
 */
@property (readonly) unsigned long limit;

/**
 Service is the main property needed for pagination. If one is not properly authenticated to a vinli service, then they will not have the ability to paginate the next set of objects.
 */
@property (weak, nonatomic) VLService * _Nullable service;

/**
 initWithDictionary is the class initializer without a VLService object

 @param dictionary dictionary is the JSON object typically associated for creating the VLPager.

 @return Should return a instance of VLPager
 */
- (nullable instancetype)initWithDictionary:(NSDictionary * _Nonnull)dictionary;

/**
 initWithDictionary is the class initializer with a VLService object

 @param dictionary dictionary is the JSON object typically associated for creating the VLPager.
 @param service    A VLService object has to be passed along to initialize the VLPager because a pager object will need to be authenticated in order to query for more objects.

 @return Should return a instance of VLPager
 */
- (nullable instancetype)initWithDictionary:(NSDictionary * _Nullable)dictionary service:(VLService * _Nullable)service;

@end
