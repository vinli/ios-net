//
//  VLWebSocket.h
//  streamservicetest
//
//  Created by Andrew Wells on 6/1/16.
//  Copyright © 2016 Vinli, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "VLParametricFilter.h"
#import "VLGeometryFilter.h"

@class VLWebSocket;
@protocol VLWebSocketDelegate <NSObject>

- (void)webSocket:(VLWebSocket *)webSocket didReceiveData:(NSDictionary *)data;
- (void)webSocket:(VLWebSocket *)webSocket didReceiveError:(NSError *)error;

@end

@interface VLWebSocket : NSObject

@property (weak, nonatomic) id<VLWebSocketDelegate> delegate;

- (instancetype)initWithDeviceId:(NSString*)deviceId url:(NSURL *)url parametricFilters:(NSArray *)pFilters geometryFilter:(VLGeometryFilter *)gFilter;

- (BOOL)isConnected;

- (void)connect;
- (void)disconnect;

@end
