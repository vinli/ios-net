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
#import "VLSupportedPids.h"
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
    if ([pidIdentifier isEqualToString:@"41"]) {
        if (pidAndValue.length >= 4) {
            NSString* pid = [pidAndValue substringWithRange:NSMakeRange(2, 2)];
            NSString* value = [pidAndValue substringWithRange:NSMakeRange(4, pidAndValue.length - 4)];
            return [self parsePid:pid hexValue:value];
        }
    }
    else {
        
        if(pidAndValue == nil || [pidAndValue stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]].length < 2){
            return nil;
        }
        
        
        NSString *pidType = nil;
        NSString *dataStr = nil;
        if([pidAndValue containsString:@":"]){
            NSArray* subComponents = [pidAndValue componentsSeparatedByString:@":"];
            pidType = subComponents[0];
            dataStr = subComponents[1];
        }else if(pidAndValue.length == 2){
            pidType = pidAndValue;
            dataStr = nil;
        }else{
            return nil;
        }
        
        if ([pidType isEqualToString:@"A"]) { // Accel
            VLAccelData *accelData = [[VLAccelData alloc] initWithData:[dataStr dataUsingEncoding:NSASCIIStringEncoding]];
//            NSLog(@"Accel = %@", accelData.description);
            return [accelData toStreamDictionary];
        }
        else if ([pidType isEqualToString:@"G"]) { // GPS
            return [self parseGPS:dataStr];
        }
        else if ([pidType isEqualToString:@"B"]) { // Voltage
            return [self parseVoltage:dataStr];
        }
        else if ([pidType isEqualToString:@"S"]) { // Cell Signal
            VLSIMSignal* signal = [[VLSIMSignal alloc] initWithRawString:dataStr];
//            NSLog(@"Signal = %@", signal);
            return [signal toDictionary];
        }
        else if ([pidType isEqualToString:@"SVER"]) {
            NSString *sver = dataStr;
//            NSLog(@"SVER = %@", sver);
            return (sver != nil) ? @{@"udpStmVersion" : sver} : nil;
        }
        else if([pidType isEqualToString:@"HVER"]) {
            NSString *hver = dataStr;
//            NSLog(@"HVER = %@", hver);
            return (hver != nil) ? @{@"udpHeVersion" : hver} : nil;
        }
        else if([pidType isEqualToString:@"BVER"]){
            NSString *bver = dataStr;
//            NSLog(@"BVER = %@", bver);
            return (bver != nil) ? @{@"udpBleVersion" : bver} : nil;
        }
        else if([pidType isEqualToString:@"K"]){
            VLSupportedPids *supportedPids = [[VLSupportedPids alloc] initWithDataString:dataStr];
            NSArray<NSString *> *support = supportedPids.support;
//            NSLog(@"SupportedPids = %@", support);
            return @{@"udpSupportedPids" : support};
        }
        else if([pidType isEqualToString:@"V"]){
            NSDictionary *vinDic = [self parseVin:dataStr];
//            NSLog(@"VIN: %@", (vinDic != nil) ? dataStr : nil);
            return vinDic;
        }
        else if([pidType isEqualToString:@"D"]){
            NSDictionary *dtcDic = [self parseDTCs:dataStr];
//            NSLog(@"udpDtcs = %@", (dtcDic != nil) ? [dtcDic valueForKey:@"udpDtcs"] : nil);
            return dtcDic;
        }
        else if([pidType isEqualToString:@"P0"]){
//            NSLog(@"udpPower = NO");
            return @{@"udpPower" : [NSNumber numberWithBool:NO]};
        }
        else if([pidType isEqualToString:@"P1"]){
//            NSLog(@"udpPower = YES");
            return @{@"udpPower" : [NSNumber numberWithBool:YES]};
        }
        else {
             NSLog(@"Pid Identifier = %@", pidIdentifier);
        }
        
    }
    
    return  nil;
}

- (id)parsePid:(NSString *)pid hexValue:(NSString *)hexValue {
    
    if (pid.length == 0 || hexValue.length == 0) {
        NSLog(@"Pid and Hex values required for parsing.");
        return nil;
    }
    
    JSValue* mainLib = self.context[@"mainlib"];
    JSValue* parseFunction = [mainLib valueForProperty:@"translate"];
    
    NSString* pidValue = [NSString stringWithFormat:@"01-%@", pid];
    
    JSValue* parsedVal = [parseFunction callWithArguments:@[pidValue, hexValue]];
    
    if (parsedVal.isObject) {
        NSDictionary *dictionary = parsedVal.toDictionary;
        return [self parseAsDictionary:dictionary];
    }else if (parsedVal.isArray){
        NSArray *array = parsedVal.toArray;
        return [self parseAsArray:array];
    }else{
        return nil;
    }
}

- (NSDictionary *) parseAsDictionary:(NSDictionary *)dictionary{
    NSString *key = [dictionary objectForKey:@"key"];
    if(key == nil) return nil;
    NSString *dataType = [dictionary objectForKey:@"dataType"];
    if(dataType == nil) return nil;
    
    if([dictionary objectForKey:@"value"] == nil){
        return nil;
    }
    
    if([dataType isEqualToString:@"decimal"]){
        NSNumber *val = [dictionary objectForKey:@"value"];
        return @{key : val};
    }else{ // string
        NSString *val = [dictionary objectForKey:@"value"];
        return @{key : val};
    }
}

- (NSDictionary *) parseAsArray:(NSArray *)array{
    if(array == nil || array.count == 0){
        return nil;
    }
    
    NSMutableDictionary *dictionary = [[NSMutableDictionary alloc] init];
    
    for(NSDictionary *d in array){
        [dictionary addEntriesFromDictionary:d];
    }
    
    NSLog(@"Hey we caught a double dictionary thing: %@", dictionary);
    
    return dictionary;
}

- (NSDictionary *) parseVin:(NSString *)dataStr{
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:@"^[A-Z0-9]{17}$" options:0 error:nil];
    
    if(dataStr == nil || [dataStr hasPrefix:@"NULL"] || [regex numberOfMatchesInString:dataStr options:0 range:NSMakeRange(0, dataStr.length)] > 0){
        return @{@"udpVin" : dataStr};
    }else{
        return nil;
    }
}

- (NSDictionary *) parseDTCs:(NSString *)dataStr{
    if(dataStr == nil){
        return nil;
    }
    
    NSMutableSet *dtcSet = [[NSMutableSet alloc] init];
    
    NSArray<NSString *> *dtcs = [dataStr componentsSeparatedByString:@","];
    for(NSString *dtc in dtcs){
        if(dtc != nil && [dtc stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]].length > 0){
            [dtcSet addObject:dtc];
        }
    }
    
    return @{@"udpDtcs" : [dtcSet allObjects]};
}

- (NSDictionary *) parseVoltage:(NSString *)dataStr{
    NSData* voltageData = [dataStr dataUsingEncoding:NSASCIIStringEncoding];
    
    if (voltageData.length < 4) {
        NSLog(@"Failed to parse Voltage from data. Not enough bytes.");
        return nil;
    }
    
    char *buffer = malloc(voltageData.length);
    [voltageData getBytes:buffer range:NSMakeRange(0, 4)];
    short rawValue = strtol(buffer, NULL, 16);
    float voltage = rawValue * .006f;
//    NSLog(@"Voltage = %f", voltage);
    return @{@"udpBatteryVoltage": [NSNumber numberWithFloat:voltage]};
}

- (NSDictionary *) parseGPS:(NSString *)dataStr{
    NSArray* coords = [dataStr componentsSeparatedByString:@","];
    if (coords.count < 2) {
        return nil;
    }
    
    coords = [[coords reverseObjectEnumerator] allObjects];
    NSDictionary* location =  @{@"coordinates": coords ,@"type": @"Point"};
    
//    VLLocation* loc = [[VLLocation alloc] initWithDictionary:@{@"coordinates" : coords}];
//    NSLog(@"loc = %@", loc);
    
    return @{@"location" : location};
    //Note: GeoJSON expects coordinates as [lon, lat] but we recieve it as [lat, lon]
}


@end
