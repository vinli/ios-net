//
//  VLObjectRef.h
//  VinliSDK
//
//  Created by Tommy Brown on 6/23/15.
//  Copyright (c) 2015 Vinli. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface VLObjectRef : NSObject

@property NSString *type;
@property NSString *objectId;

- (id) initWithDictionary: (NSDictionary *)dictionary;
- (id) initWithType: (NSString *) type objectId:(NSString *)objectId;

- (NSDictionary *) toDictionary;

@end
