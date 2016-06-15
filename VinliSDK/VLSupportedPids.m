//
//  SupportedPids.m
//  VinliSDK
//
//  Created by Tommy Brown on 6/10/16.
//  Copyright © 2016 Vinli. All rights reserved.
//

#import "VLSupportedPids.h"

static NSMutableSet<NSString *> *knownUnsupportedPids;

@interface VLSupportedPids()

@property (strong, nonatomic) NSDictionary<NSString *, NSNumber *> *supportMap;

@end

@implementation VLSupportedPids

+ (void)initalize {
    if(knownUnsupportedPids == nil){
        
        // Markers for supported pids
        [knownUnsupportedPids addObject:@"01-00"];
        [knownUnsupportedPids addObject:@"01-20"];
        [knownUnsupportedPids addObject:@"01-40"];
        [knownUnsupportedPids addObject:@"01-60"];
        [knownUnsupportedPids addObject:@"01-80"];
        
        // Dtcs
        [knownUnsupportedPids addObject:@"01-01"];
        
        // Accelerometer
        [knownUnsupportedPids addObject:@"01-0c"];
        
        // >2 byte pids from https://en.wikipedia.org/wiki/OBD-II_PIDs#Standard_PIDs
        [knownUnsupportedPids addObject:@"01-24"];
        [knownUnsupportedPids addObject:@"01-25"];
        [knownUnsupportedPids addObject:@"01-26"];
        [knownUnsupportedPids addObject:@"01-27"];
        [knownUnsupportedPids addObject:@"01-28"];
        [knownUnsupportedPids addObject:@"01-29"];
        [knownUnsupportedPids addObject:@"01-2a"];
        [knownUnsupportedPids addObject:@"01-2b"];
        
        [knownUnsupportedPids addObject:@"01-34"];
        [knownUnsupportedPids addObject:@"01-35"];
        [knownUnsupportedPids addObject:@"01-36"];
        [knownUnsupportedPids addObject:@"01-37"];
        [knownUnsupportedPids addObject:@"01-38"];
        [knownUnsupportedPids addObject:@"01-39"];
        [knownUnsupportedPids addObject:@"01-3a"];
        [knownUnsupportedPids addObject:@"01-3b"];
        
        [knownUnsupportedPids addObject:@"01-41"];
        [knownUnsupportedPids addObject:@"01-4f"];
        [knownUnsupportedPids addObject:@"01-50"];
        
        [knownUnsupportedPids addObject:@"01-64"];
        //        [knownUnsupportedPids addObject:@"01-66"];
        [knownUnsupportedPids addObject:@"01-67"];
        [knownUnsupportedPids addObject:@"01-68"];
        [knownUnsupportedPids addObject:@"01-69"];
        [knownUnsupportedPids addObject:@"01-6a"];
        [knownUnsupportedPids addObject:@"01-6b"];
        [knownUnsupportedPids addObject:@"01-6c"];
        [knownUnsupportedPids addObject:@"01-6d"];
        [knownUnsupportedPids addObject:@"01-6e"];
        [knownUnsupportedPids addObject:@"01-6f"];
        
        [knownUnsupportedPids addObject:@"01-70"];
        [knownUnsupportedPids addObject:@"01-71"];
        [knownUnsupportedPids addObject:@"01-72"];
        [knownUnsupportedPids addObject:@"01-73"];
        [knownUnsupportedPids addObject:@"01-74"];
        [knownUnsupportedPids addObject:@"01-75"];
        [knownUnsupportedPids addObject:@"01-76"];
        [knownUnsupportedPids addObject:@"01-77"];
        [knownUnsupportedPids addObject:@"01-78"];
        [knownUnsupportedPids addObject:@"01-79"];
        [knownUnsupportedPids addObject:@"01-7a"];
        [knownUnsupportedPids addObject:@"01-7b"];
        [knownUnsupportedPids addObject:@"01-7c"];
        [knownUnsupportedPids addObject:@"01-7f"];
        
        [knownUnsupportedPids addObject:@"01-81"];
        [knownUnsupportedPids addObject:@"01-82"];
        [knownUnsupportedPids addObject:@"01-83"];
        
        [knownUnsupportedPids addObject:@"01-a0"];
        [knownUnsupportedPids addObject:@"01-c0"];
    }
}

- (instancetype) initWithDataString:(NSString *)dataString{
    self = [super init];
    if(self){
        _rawDataString = dataString;
    }
    return self;
}

- (BOOL) supportsPid:(NSString *)code{
    if(!([[code lowercaseString] hasPrefix:@"01-"])){
        return false;
    }
    
    if([knownUnsupportedPids containsObject:code]){
        return false;
    }
    
    if(_supportMap == nil){
        [self buildSupportMap];
    }
    
    NSNumber *result = [_supportMap objectForKey:code];
    return (result == nil) ? NO : YES;
}

- (NSArray<NSString *> *) support{
    if(_supportMap == nil){
        [self buildSupportMap];
    }
    NSMutableSet<NSString *> *support = [[NSMutableSet alloc] init];
    for(NSString *e in _supportMap.allKeys){
        if([_supportMap objectForKey:e] != nil && [_supportMap objectForKey:e]){
            [support addObject:e.uppercaseString];
        }
    }
    return [support allObjects];
}

- (NSString *) description{
    if(_supportMap == nil){
        [self buildSupportMap];
    }
    
    NSMutableString *mutableString = [[NSMutableString alloc] init];
    for(NSString *e in _supportMap.allKeys){
        NSString *key = e;
        NSNumber *value = [_supportMap objectForKey:key];
        if(mutableString.length != 0){
            [mutableString appendString:@"::"];
        }
        [mutableString appendString:[NSString stringWithFormat:@"key='%@',val='%@'", key, (value == nil || value.boolValue == false) ? @"false" : @"true"]];
    }
    return mutableString;
}

- (void) buildSupportMap{
    _supportMap = [[NSMutableDictionary alloc] init];
    NSMutableArray<NSString *> *groups = [[NSMutableArray alloc] init];
    NSMutableString *mutableString = [[NSMutableString alloc] init];
    for(int i = 0; i < _rawDataString.length; i++){
        if(mutableString.length == 8){
            [groups addObject:[NSString stringWithString:mutableString]];
            [mutableString deleteCharactersInRange:NSMakeRange(0, mutableString.length)];
        }
        [mutableString appendString:[NSString stringWithFormat:@"%c", [_rawDataString characterAtIndex:i]]];
    }
    if(mutableString.length == 8){
        [groups addObject:[NSString stringWithString:mutableString]];
    }
    for(int i = 0; i < groups.count; i++){
        [self parseBitflags:[groups objectAtIndex:i] group:i];
    }
}

- (void) parseBitflags:(NSString *)bitflags group:(int)group{
    int groupStart = group * 32 + 1;
    for(int i = 0; i < 8; i++){
        int j = i * 4;
        unsigned int hexInt;
        NSScanner *scanner = [NSScanner scannerWithString:[bitflags substringWithRange:NSMakeRange(i, 1)]];
        [scanner scanHexInt:&hexInt];
        NSString *bin = [self intToBinary:hexInt];
        while(bin.length < 4){
            bin = [@"0" stringByAppendingString:bin];
        }
        
        [self putIntoMap:([bin characterAtIndex:0] == '1') atIndex:(groupStart + j)];
        [self putIntoMap:([bin characterAtIndex:1] == '1') atIndex:(groupStart + j + 1)];
        [self putIntoMap:([bin characterAtIndex:2] == '1') atIndex:(groupStart + j + 2)];
        [self putIntoMap:([bin characterAtIndex:3] == '1') atIndex:(groupStart + j + 3)];
    }
}

- (void) putIntoMap:(bool)flag atIndex:(int)index{
    NSString *hex = [[NSString stringWithFormat:@"%x", index] lowercaseString];
    while(hex.length < 2){
        hex = [@"0" stringByAppendingString:hex];
    }
    [_supportMap setValue:[NSNumber numberWithBool:flag] forKey:[@"01-" stringByAppendingString:hex]];
}

- (NSString *)intToBinary:(int)intValue
{
    int byteBlock = 8,            // 8 bits per byte
    totalBits = (sizeof(int)) * byteBlock, // Total bits
    binaryDigit = totalBits; // Which digit are we processing
    
    // C array - storage plus one for null
    char ndigit[totalBits + 1];
    
    while (binaryDigit-- > 0)
    {
        // Set digit in array based on rightmost bit
        ndigit[binaryDigit] = (intValue & 1) ? '1' : '0';
        
        // Shift incoming value one to right
        intValue >>= 1;
    }
    
    // Append null
    ndigit[totalBits] = 0;
    
    // Return the binary string
    return [NSString stringWithUTF8String:ndigit];
}

@end
