//
//  VLStreamMessage.m
//  VinliSDK
//
//  Created by Tommy Brown on 4/12/16.
//  Copyright © 2016 Vinli. All rights reserved.
//

#import "VLStreamMessage.h"

@interface VLStreamMessage(){
    NSDictionary *subject;
    NSDictionary *payload;
    NSNumber *statusCode;
}
@end

@implementation VLStreamMessage

- (id) initWithDictionary:(NSDictionary *)dictionary{
    self = [super init];
    if(self){
        self.type = [dictionary objectForKey:@"type"];
        
        if([dictionary objectForKey:@"statusCode"] != nil){
            statusCode = [dictionary objectForKey:@"statusCode"];
        }
        
        if([dictionary objectForKey:@"subject"] != nil){
            subject = [dictionary objectForKey:@"subject"];
            
            if([[subject objectForKey:@"type"] isEqualToString:@"device"]){
                self.deviceId = [subject objectForKey:@"id"];
            }
        }
        
        if([dictionary objectForKey:@"payload"] != nil){
            payload = [dictionary objectForKey:@"payload"];
            
            self.timestamp = [payload objectForKey:@"timestamp"];
            
        }
    }
    return self;
}

- (VLAccelData *) accel{
    NSDictionary *accelDictionary = (NSDictionary *)[self rawValueForKey:@"accel"];
    if(accelDictionary != nil){
        return [[VLAccelData alloc] initWithDictionary:accelDictionary];
    }else{
        return nil;
    }
}

- (VLLocation *) coord {
    NSDictionary *coordData = (NSDictionary *) [self rawValueForKey:@"location"];
    if(coordData != nil){
        return [[VLLocation alloc] initWithDictionary:coordData];
    }else{
        return nil;
    }
}

- (NSError *) error{
    if(payload != nil && [payload objectForKey:@"error"] != nil){
        NSString *errorDomain = [payload objectForKey:@"error"];
        NSString *errorMessage = [payload objectForKey:@"message"];
        return [NSError errorWithDomain:errorDomain code:statusCode.integerValue userInfo:@{@"NSLocalizedDescriptionKey" : errorMessage}];
    }else{
        return nil;
    }
}

- (NSObject *) rawValueForKey:(NSString *)key{
    
    if(payload == nil || [payload objectForKey:@"data"] == nil){
        return nil;
    }
    
    id value = [[payload objectForKey:@"data"] objectForKey:key];
    
    if(value == nil){
        return nil;
    }
    
    if([value isKindOfClass:NSString.class]){
        return (NSString *) value;
    }else if([value isKindOfClass:NSNumber.class]){
        return ((NSNumber *) value);
    }else if([value isKindOfClass:NSDictionary.class]){
        return ((NSDictionary *) value);
    }else if([value isKindOfClass:NSArray.class]){
        return ((NSArray *) value);
    }else{
        return nil;
    }
}

- (double) doubleForKey:(NSString *)key defaultValue:(double)defaultValue{
    NSNumber *value = (NSNumber *)[self rawValueForKey:key];
    
    if(value == nil){
        return defaultValue;
    }else{
        return value.doubleValue;
    }
}

- (long) longForKey:(NSString *)key defaultValue:(long)defaultValue{
    return round([self doubleForKey:key defaultValue:defaultValue]);
}

- (float) floatForKey:(NSString *)key defaultValue:(float)defaultValue{
    return [NSNumber numberWithDouble:[self doubleForKey:key defaultValue:defaultValue]].floatValue;
}

- (int) integerForKey:(NSString *)key defaultValue:(int)defaultValue{
    return [NSNumber numberWithLong:[self longForKey:key defaultValue:defaultValue]].intValue;
}



@end
