//
//  VLPager.h
//  VinliSDK
//
//  Created by Tommy Brown on 5/26/15.
//  Copyright (c) 2015 Vinli. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface VLPager : NSObject

@property (readonly) unsigned long limit; // Max = 50;

- (id) initWithDictionary: (NSDictionary *) dictionary;

@end
