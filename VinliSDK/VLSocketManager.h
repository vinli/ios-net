//
//  VLSocketManager.h
//  streamservicetest
//
//  Created by Andrew Wells on 6/2/16.
//  Copyright © 2016 Vinli, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "VLParametricFilter.h"
#import "VLGeometryFilter.h"

@class VLSocketManager;
@protocol VLSocketManagerDelegate <NSObject>
- (void)socketManager:(VLSocketManager *)socketManager didReceiveData:(NSDictionary *)data;
- (void)socketManager:(VLSocketManager *)socketManager didReceiveError:(NSError *)error;
@end

@interface VLSocketManager : NSObject

@property (weak, nonatomic) id<VLSocketManagerDelegate> delegate;

- (instancetype)initWithDeviceId:(NSString *)deviceId webURL:(NSURL *)webURL parametricFilters:(NSArray *)pFilters geometryFilter:(VLGeometryFilter *)gFilter;

- (void) disconnect;

@end
