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

@property (nonatomic, readonly) NSString *type;
@property (nonatomic, readonly) NSString *deviceId;
@property (nonatomic, readonly) NSString *timestamp;
@property (nonatomic, readonly) VLAccelData *accel;
@property (nonatomic, readonly) VLLocation *coord;
@property (nonatomic, strong)   NSNumber *bearing;
@property (nonatomic, readonly) NSError *error;

@property (nonatomic, readonly) NSDictionary* payload;

- (instancetype) initWithDictionary:(NSDictionary *) dictionary;

- (id) rawValueForKey:(NSString *)key;
- (int) integerForKey:(NSString *)key defaultValue:(int) defaultValue;
- (double) doubleForKey:(NSString *)key defaultValue:(double) defaultValue;
- (long) longForKey:(NSString *)key defaultValue:(long) defaultValue;
- (float) floatForKey:(NSString *)key defaultValue:(float) defaultValue;

@end
