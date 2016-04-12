//
//  VLStreamMessage.m
//  VinliSDK
//
//  Created by Tommy Brown on 4/12/16.
//  Copyright © 2016 Vinli. All rights reserved.
//

#import "VLStreamMessage.h"

@interface VLStreamMessage(){
    NSString *type;
    NSDictionary *subject;
    NSDictionary *payload;
}
@end

@implementation VLStreamMessage

- (id) initWithDictionary:(NSDictionary *)dictionary{
    self = [super init];
    if(self){
        type = [dictionary objectForKey:@"type"];
        
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

- (NSString *) rawValueForKey:(NSString *)key{
    
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
        return ((NSNumber *) value).stringValue;
    }else{
        return nil; // TODO do stuff here
    }
}

- (double) doubleForKey:(NSString *)key defaultValue:(double)defaultValue{
    NSString *value = [self rawValueForKey:key];
    
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
