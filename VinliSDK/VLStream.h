//
//  VLStream.h
//  VinliSDK
//
//  Created by Tommy Brown on 4/12/16.
//  Copyright © 2016 Vinli. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "VLStreamMessage.h"
#import "VLParametricFilter.h"
#import "VLGeometryFilter.h"

@interface VLStream : NSObject

@property (copy) void (^onMessageBlock)(VLStreamMessage *message);
@property (copy) void (^onErrorBlock)(NSError *error);

- (id) initWithURL:(NSURL *)url deviceId:(NSString *)deviceId;
- (id) initWithURL:(NSURL *)url deviceId:(NSString *)deviceId parametricFilters:(NSArray *)pFilters geometryFilter:(VLGeometryFilter *)gFilter;

@end
