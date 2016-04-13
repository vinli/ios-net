//
//  VLParametricFilter.h
//  VinliSDK
//
//  Created by Tommy Brown on 4/13/16.
//  Copyright © 2016 Vinli. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface VLParametricFilter : NSObject

@property (strong, nonatomic) NSString *deviceId;
@property (nonatomic) NSNumber *min;
@property (nonatomic) NSNumber *max;
@property (nonatomic, strong) NSString *parameter;

- (id) initWithParameter:(NSString *) parameter;
- (id) initWithParameter:(NSString *) parameter min:(NSNumber *) min max:(NSNumber *) max deviceId:(NSString *) deviceId;

- (NSDictionary *) toDictionary;

@end
