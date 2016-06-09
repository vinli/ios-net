//
//  VLSocketManager.m
//  streamservicetest
//
//  Created by Andrew Wells on 6/2/16.
//  Copyright © 2016 Vinli, Inc. All rights reserved.
//

#import "VLSocketManager.h"
#import "VLWebSocket.h"
#import "VLUDPSocket.h"

@interface VLSocketManager() <VLUDPSocketDelegate, VLWebSocketDelegate>

@property (strong, nonatomic) VLWebSocket* webSocket;
@property (strong, nonatomic) VLUDPSocket* udpSocket;

@property (strong, nonatomic) NSTimer* udpConnectionTimer;

@property (assign, nonatomic) BOOL receivedMessage;

@property (strong, nonatomic) NSString* deviceId;

@end

@implementation VLSocketManager

- (instancetype)initWithDeviceId:(NSString *)deviceId {
    if (self = [super init]) {
        self.deviceId = deviceId;
        [self setupSockets];
    }
    return self;
}

- (void)dealloc {
    [self killConnectionTimer];
}

- (void)setupSockets {
    
    self.udpSocket = [VLUDPSocket new];
    self.udpSocket.delegate = self;
    
    self.udpConnectionTimer = [NSTimer scheduledTimerWithTimeInterval:8 target:self selector:@selector(checkConnection) userInfo:nil repeats:YES];
    
    [self checkConnection];
}

- (void)checkConnection {
    
    if (!self.receivedMessage) {
        NSLog(@"UDP: Lost connection to device");
        [self launchWebSocket];
        return;
    }
    
    self.receivedMessage = NO;
}

- (void)killConnectionTimer {
    [self.udpConnectionTimer invalidate];
    self.udpConnectionTimer = nil;
}


- (void)handleReceivedUDPMessage {
    
    self.receivedMessage = YES;
    
    if (self.webSocket.isConnected) {
        NSLog(@"Websocket: Disconnecting");
        [self.webSocket disconnect];
    }
}

- (void)launchWebSocket {
    
    if (!self.webSocket) {
        self.webSocket = [[VLWebSocket alloc] initWithDeviceId:self.deviceId token:@"48wOSOqrddSMUrCmO35raGnXUENWNt_9AHAGAcWQBgwOi5E1YsqXw26yAPT11qVs"];
        self.webSocket.delegate = self;
    }
    
    if (self.webSocket.isConnected) {
        return;
    }
    
    NSLog(@"Websocket: Connecting");
    [self.webSocket connect];
}

#pragma mark - VLUDPSocketDelegate Method

- (void)webSocket:(VLWebSocket *)webSocket didReceiveData:(NSDictionary *)data
{
    [self.delegate socketManager:self didReceiveData:data];
}

- (void)udpSocket:(VLUDPSocket *)udpSocket receivedData:(NSDictionary *)data {
    
    [self handleReceivedUDPMessage];
    
    if (!data) {
        return;
    }
    
    NSMutableDictionary* messageData = [NSMutableDictionary new];
    [messageData setObject:data forKey:@"payload"];
    [messageData setObject:@"pub" forKey:@"type"];
    
    if (self.deviceId) {
         NSDictionary* subject = @{@"id": self.deviceId, @"type" : @"device"};
        [messageData setObject:subject forKey:@"subject"];
    }

    [self.delegate socketManager:self didReceiveData:messageData];
}

@end
