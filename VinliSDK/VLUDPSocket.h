//
//  VLUDPSocket.h
//  streamservicetest
//
//  Created by Andrew Wells on 6/2/16.
//  Copyright © 2016 Vinli, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

@class VLUDPSocket;
@protocol VLUDPSocketDelegate <NSObject>
- (void)udpSocket:(VLUDPSocket *)udpSocket receivedData:(NSDictionary *)data;
@end

@interface VLUDPSocket : NSObject

@property (weak, nonatomic) id<VLUDPSocketDelegate> delegate;

@end
