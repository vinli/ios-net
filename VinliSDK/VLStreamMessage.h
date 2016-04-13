//
//  VLStreamMessage.h
//  VinliSDK
//
//  Created by Tommy Brown on 4/12/16.
//  Copyright © 2016 Vinli. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "VLAccelData.h"
#import "VLLocation.h"

@interface VLStreamMessage : NSObject

@property (nonatomic, strong) NSString *type;
@property (nonatomic, strong) NSString *deviceId;
@property (nonatomic, strong) NSString *timestamp;
@property (nonatomic, readonly) VLAccelData *accel;
@property (nonatomic, readonly) VLLocation *coord;

- (id) initWithDictionary:(NSDictionary *) dictionary;

- (NSObject *) rawValueForKey:(NSString *)key;
- (int) integerForKey:(NSString *)key defaultValue:(int) defaultValue;
- (double) doubleForKey:(NSString *)key defaultValue:(double) defaultValue;
- (long) longForKey:(NSString *)key defaultValue:(long) defaultValue;
- (float) floatForKey:(NSString *)key defaultValue:(float) defaultValue;


@end
