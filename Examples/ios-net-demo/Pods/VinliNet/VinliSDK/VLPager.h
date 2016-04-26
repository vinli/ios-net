//
//  VLPager.h
//  VinliSDK
//
//  Created by Tommy Brown on 5/26/15.
//  Copyright (c) 2015 Vinli. All rights reserved.
//

#import <Foundation/Foundation.h>



@class VLService;

@interface VLPager : NSObject


@property (readonly) unsigned long limit; // Max = 50;
@property (weak, nonatomic) VLService* service;

- (id) initWithDictionary: (NSDictionary *) dictionary;
- (id) initWithDictionary:(NSDictionary *)dictionary service:(VLService *)service;

@end
