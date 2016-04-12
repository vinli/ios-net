//
//  VLStream.h
//  VinliSDK
//
//  Created by Tommy Brown on 4/12/16.
//  Copyright © 2016 Vinli. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "VLStreamMessage.h"

@interface VLStream : NSObject

@property (copy) void (^onMessageBlock)(VLStreamMessage *message);
@property (copy) void (^onErrorBlock)(NSError *error);

- (id) initWithURL:(NSURL*) url deviceId:(NSString *) deviceId;

@end
