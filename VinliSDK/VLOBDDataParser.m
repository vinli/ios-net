//
//  VLOBDDataParser.m
//  streamservicetest
//
//  Created by Andrew Wells on 5/31/16.
//  Copyright © 2016 Vinli, Inc. All rights reserved.
//

#import "VLOBDDataParser.h"
#import "JavaScriptCore/JavaScriptCore.h"

#import "VLStreamMessage.h"

#import "VLSIMSignal.h"

@interface VLOBDDataParser()
@property (strong, nonatomic) JSContext* context;
@end

@implementation VLOBDDataParser

- (instancetype)init {
    if (self = [super init]) {
        [self setupParser];
    }
    return self;
}

- (void)setupParser {
    self.context = [[JSContext alloc] init];
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"compressed_JS_lib" ofType:@"js"];
    NSError* error = nil;
    NSString* parseLibJS = [NSString stringWithContentsOfFile:filePath encoding:NSUTF8StringEncoding error:&error];
    if (error) {
        NSLog(@"Failed to load javascript lib from filepath %@ with error: %@", filePath, error);
        return;
    }
    [self.context evaluateScript:parseLibJS];

}

- (void)parse {
    JSValue* mainLib = self.context[@"mainlib"];
    JSValue* parseFunction = [mainLib valueForProperty:@"translate"];
    JSValue* parsedVal = [parseFunction callWithArguments:@[@"01-0D", @"FF"]];
    NSLog(@"Parsed Value = %@", parsedVal.toDictionary);
    
}

- (id)parseData:(NSData *)data {
    
    NSString* dataStr = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    
    // Get Pid Identifier
    NSArray* dataComponents = [dataStr componentsSeparatedByString:@"#"];
    if (dataComponents.count < 2) {
        NSLog(@"Unable to parse data. Incorrect Pid data format.");
        return nil;
    }
    
    NSString* pidAndValue = dataComponents[1];
    NSString* pidIdentifier = [pidAndValue substringWithRange:NSMakeRange(0, 2)];
    
    
    // Parse based on Pid Identifier
    //return [self _parseWithIdentifier:pidIdentifier];
    
    
    if ([pidIdentifier isEqualToString:@"41"]) {
        if (pidAndValue.length >= 4) {
            NSString* pid = [pidAndValue substringWithRange:NSMakeRange(2, 2)];
            NSString* value = [pidAndValue substringWithRange:NSMakeRange(4, pidAndValue.length - 4)];
            return [self parsePid:pid hexValue:value];
        }
    }
    else {
        
        NSArray* subComponents = [pidAndValue componentsSeparatedByString:@":"];
        if (subComponents.count < 2) {
            NSLog(@"Failed to parse OBD data with data: %@", pidAndValue);
            return nil;
        }
        
        NSString* pidType = subComponents[0];
        NSString* dataStr = subComponents[1];
        
        if ([pidType isEqualToString:@"A"]) { // Accel
            
            [self updateAccelerometerInfoWithData:[dataStr dataUsingEncoding:NSASCIIStringEncoding]];
            
        }
        else if ([pidType isEqualToString:@"G"]) { // GPS
            
            NSArray* coords = [dataStr componentsSeparatedByString:@","];
            if (coords.count < 2) {
                return nil;
            }
            
            coords = [[coords reverseObjectEnumerator] allObjects];
            NSDictionary* location =  @{@"coordinates": coords ,@"type": @"Point"};
            return @{@"location" : location};
            //Note: GeoJSON expects coordinates as [lon, lat] but we recieve it as [lat, lon]
            //VLLocation* loc = [[VLLocation alloc] initWithDictionary:@{@"coordinates" : coords}];
            //NSLog(@"loc = %@", loc);
        }
        else if ([pidType isEqualToString:@"B"]) { // Voltage
           
            NSData* voltageData = [dataStr dataUsingEncoding:NSASCIIStringEncoding];
           
            if (voltageData.length < 4) {
                NSLog(@"Failed to parse Voltage from data. Not enough bytes.");
                return nil;
            }
            
            char *buffer = malloc(voltageData.length);
            [voltageData getBytes:buffer range:NSMakeRange(0, 4)];
            short rawValue = strtol(buffer, NULL, 16);
            float voltage = rawValue * .006f;
            return @{@"voltage": [NSNumber numberWithFloat:voltage]};
            //NSLog(@"Voltage = %f", voltage);
        }
        else if ([pidType isEqualToString:@"S"]) { // Cell Signal
            VLSIMSignal* signal = [[VLSIMSignal alloc] initWithRawString:dataStr];
            //NSLog(@"Signal = %@", signal);
        }
        else if ([pidType isEqualToString:@"SVER"]) { //BLE Software Version
            NSString* bleVersion = dataStr;
        }
        else if ([pidType isEqualToString:@"K"]) {
            
        }
        else {
             NSLog(@"Pid Identifier = %@", pidIdentifier);
        }
        
    }
    //[self parsePid:@"0D" hexValue:@"FF"];
    
    return  nil;
}

//- (id)_parseWithIdentifier:(NSString *)pidIdentifier {
//    
//}

- (id)parsePid:(NSString *)pid hexValue:(NSString *)hexValue {
    
    if (pid.length == 0 || hexValue.length == 0) {
        NSLog(@"Pid and Hex values required for parsing.");
        return nil;
    }
    
    JSValue* mainLib = self.context[@"mainlib"];
    JSValue* parseFunction = [mainLib valueForProperty:@"translate"];
    
    NSString* pidValue = [NSString stringWithFormat:@"01-%@", pid];
    
    JSValue* parsedVal = [parseFunction callWithArguments:@[pidValue, hexValue]];
    //NSLog(@"Parsed Value = %@", parsedVal.toDictionary);
    
    id retVal = nil;
    if (parsedVal.isObject) {
        retVal = parsedVal.toDictionary;
    }
    return retVal;
}

- (void)updateAccelerometerInfoWithData:(NSData *)data
{
    VLAccelData* accelData = [[VLAccelData alloc] initWithData:data];
    //NSLog(@"Accel Data = %@", accelData.description);
}


@end
