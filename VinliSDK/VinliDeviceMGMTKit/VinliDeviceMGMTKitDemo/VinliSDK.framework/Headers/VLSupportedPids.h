//
//  VLSupportedPids.h
//  VinliSDK
//
//  Created by Tommy Brown on 6/13/16.
//  Copyright © 2016 Vinli. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface VLSupportedPids : NSObject

@property (strong, nonatomic, readonly) NSString *rawDataString;
@property (strong, nonatomic, readonly) NSArray<NSString *> *support;

- (instancetype) initWithDataString:(NSString *)dataString;

- (BOOL) supportsPid:(NSString *)code;

@end
