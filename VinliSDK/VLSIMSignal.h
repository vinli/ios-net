//
//  VLSIMSignal.h
//  streamservicetest
//
//  Created by Andrew Wells on 6/1/16.
//  Copyright © 2016 Vinli, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface VLSIMSignal : NSObject

@property (readonly) NSString *network;
@property (readonly) NSString *signalStrengthStr;
@property (readonly) NSInteger signalStrength;

- (instancetype)initWithRawString:(NSString *)str;


@end
