//
//  VLSIMSignal.m
//  streamservicetest
//
//  Created by Andrew Wells on 6/1/16.
//  Copyright © 2016 Vinli, Inc. All rights reserved.
//

#import "VLSIMSignal.h"

@implementation VLSIMSignal

- (instancetype)initWithRawString:(NSString *)str {
    if (self = [super init]) {
        NSArray* signalComponents = [str componentsSeparatedByString:@","];
        if (signalComponents.count == 2) {
            _network = signalComponents[0];
            _signalStrengthStr = signalComponents[1];
            _signalStrength = [_signalStrengthStr integerValue];
        }
    }
    return self;
}

- (NSString *)description {
    return [NSString stringWithFormat:@"%@: Network: %@, Signal Strength:%@", [super description], _network, _signalStrengthStr];
}

@end
