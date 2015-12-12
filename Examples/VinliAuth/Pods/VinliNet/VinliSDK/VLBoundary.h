//
//  VLBoundary.h
//  VinliSDK
//
//  Created by Tommy Brown on 5/20/15.
//  Copyright (c) 2015 Cheng Gu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface VLBoundary : NSObject

@property NSString *type;

- (id) initWithType: (NSString *) type;
- (id) initWithDictionary: (NSDictionary *) dictionary;
- (NSDictionary *) toDictionary;

@end
