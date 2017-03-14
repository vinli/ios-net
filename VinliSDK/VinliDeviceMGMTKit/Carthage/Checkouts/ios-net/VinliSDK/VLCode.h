//
//  VLCode.h
//  VinliSDK
//
//  Created by Andrew Wells on 11/28/16.
//  Copyright © 2016 Vinli. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "VLOffsetPager.h"
#import "VLParsable.h"

@interface VLCode : NSObject

@property (readonly) NSString *codeId;
@property (readonly) NSString *make;
@property (readonly) NSString *system;
@property (readonly) NSString *subSystem;
@property (readonly) NSString *pid;
@property (readonly) NSString *codeDescription;

@property (readonly) NSDictionary *twoByte;
@property (readonly) NSDictionary *threeByte;

- (instancetype)initWithDictionary:(NSDictionary *)json;


@end

@interface VLCodePager : VLOffsetPager <VLParsable>
@property (readonly) NSArray *codes;
@end
