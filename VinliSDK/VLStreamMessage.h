//
//  VLStreamMessage.h
//  VinliSDK
//
//  Created by Tommy Brown on 4/12/16.
//  Copyright © 2016 Vinli. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface VLStreamMessage : NSObject

- (id) initWithDictionary:(NSDictionary *) dictionary;

- (NSString *) rawValueForValue:(NSString *)value defaultValue:(NSString *) defaultValue;
- (int) integerForValue:(NSString *)value defaultValue:(int) defaultValue;
- (double) doubleForValue:(NSString *)value defaultValue:(double) defaultValue;
- (long) longForValue:(NSString *)value defaultValue:(long) defaultValue;
- (float) floatForValue:(NSString *)value defaultValue:(float) defaultValue;


@end
