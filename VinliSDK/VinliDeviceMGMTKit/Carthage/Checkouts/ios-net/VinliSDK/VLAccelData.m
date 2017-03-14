//
//  VLAccelData.m
//  VinliSDK
//
//  Created by Tommy Brown on 4/13/16.
//  Copyright © 2016 Vinli. All rights reserved.
//

#import "VLAccelData.h"

static const double ACCEL_MULTIPLIER = (9.807f / 16384.0f);

@interface VLAccelData()

@property (strong, nonatomic) NSNumber *collisionDetected; // BOOL
@property (nonatomic) bool validAccelData;

@end

@implementation VLAccelData

- (instancetype)initWithDictionary:(NSDictionary *)dictionary{
    self = [super init];
    
    if(self){
        _maxX = [[dictionary objectForKey:@"maxX"] doubleValue];
        _maxY = [[dictionary objectForKey:@"maxY"] doubleValue];
        _maxZ = [[dictionary objectForKey:@"maxZ"] doubleValue];
        _minX = [[dictionary objectForKey:@"minX"] doubleValue];
        _minY = [[dictionary objectForKey:@"minY"] doubleValue];
        _minZ = [[dictionary objectForKey:@"minZ"] doubleValue];
    }
    
    return self;
}

- (instancetype)initWithData:(NSData *)data {
    
    if (self = [super init]) {
        
        if (data.length == 14) {
            
            //NSLog(@"Accel data = %@", data);
        
            char* buffer = malloc(4);
            
            [data getBytes:buffer range:NSMakeRange(0, 4)];
            short x = strtol(buffer, NULL, 16);
            
            _maxX =  x * ACCEL_MULTIPLIER;
            _minX = _maxX;
            
            
            [data getBytes:buffer range:NSMakeRange(4, 4)];
            short y = strtol(buffer, NULL, 16);
            
            _maxY = y * ACCEL_MULTIPLIER;
            _minY = _maxY;
            
            
            [data getBytes:buffer range:NSMakeRange(8, 4)];
            short z = strtol(buffer, NULL, 16);
            
            _maxZ = z * ACCEL_MULTIPLIER;
            _minZ = _maxZ;
            
            char* collisionBuffer = malloc(2);
            [data getBytes:collisionBuffer range:NSMakeRange(12, 2)];
            short collisionVal = strtol(collisionBuffer, NULL, 16);
            self.collisionDetected = [NSNumber numberWithBool:(collisionVal == 1)];
            
            free(buffer);
            free(collisionBuffer);
            
            _validAccelData = YES;
        }
        else if (data.length == 4) // This is deprecated but leaving in case we test older devices
        {
            char* accelBytes = malloc(4);
            
            [data getBytes:accelBytes length:4];
            _maxX = accelBytes[0];
            _minX = _maxX;
            
            _maxY = accelBytes[1];
            _minY = _maxY;
            
            _maxZ = accelBytes[2];
            _minZ = _maxZ;
            
            BOOL collision = accelBytes[3] == 1;
            self.collisionDetected = [NSNumber numberWithBool:collision];
            
            free(accelBytes);
            
            _validAccelData = YES;
        }else{
            _validAccelData = NO;
        }
    }
    return self;
}

- (NSString *)description {
    if(_collisionDetected != nil){
        return  [NSString stringWithFormat:@"%@:\nminX:%f maxX:%f,\n minY:%f maxY:%f,\n minZ:%f maxZ:%f collision:%d", [super description], _minX, _maxX, _minY, _maxY, _minZ, _maxZ, _collisionDetected.boolValue];
    }else{
        return  [NSString stringWithFormat:@"%@:\nminX:%f maxX:%f,\n minY:%f maxY:%f,\n minZ:%f maxZ:%f", [super description], _minX, _maxX, _minY, _maxY, _minZ, _maxZ];
    }
}

- (NSDictionary *) toStreamDictionary{
    NSMutableDictionary *dictionary = [[NSMutableDictionary alloc] init];
    
    if(_collisionDetected != nil){
        [dictionary setObject:_collisionDetected forKey:@"udpCollision"];
    }
    
    if(_validAccelData){
        NSMutableDictionary *accelDictionary = [[NSMutableDictionary alloc] init];
        [accelDictionary setObject:[NSNumber numberWithDouble:_maxX] forKey:@"maxX"];
        [accelDictionary setObject:[NSNumber numberWithDouble:_minX] forKey:@"minX"];
        [accelDictionary setObject:[NSNumber numberWithDouble:_maxY] forKey:@"maxY"];
        [accelDictionary setObject:[NSNumber numberWithDouble:_minY] forKey:@"minY"];
        [accelDictionary setObject:[NSNumber numberWithDouble:_maxZ] forKey:@"maxZ"];
        [accelDictionary setObject:[NSNumber numberWithDouble:_minZ] forKey:@"minZ"];
        [dictionary setObject:accelDictionary forKey:@"accel"];
    }
    
    return dictionary;
}


@end
