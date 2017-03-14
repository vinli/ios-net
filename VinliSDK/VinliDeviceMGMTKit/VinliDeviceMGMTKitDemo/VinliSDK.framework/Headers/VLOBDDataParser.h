//
//  VLOBDDataParser.h
//  streamservicetest
//
//  Created by Andrew Wells on 5/31/16.
//  Copyright © 2016 Vinli, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface VLOBDDataParser : NSObject

- (id)parsePid:(NSString *)pid hexValue:(NSString *)hexValue;
- (id)parseData:(NSData *)data;

@end
