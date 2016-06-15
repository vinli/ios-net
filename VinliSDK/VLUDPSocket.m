//
//  VLUDPSocket.m
//  streamservicetest
//
//  Created by Andrew Wells on 6/2/16.
//  Copyright © 2016 Vinli, Inc. All rights reserved.
//

#import "VLUDPSocket.h"
#import "VLOBDDataParser.h"
#import "GCDAsyncUdpSocket.h"

static NSString * const UDP_HOST_ADDRESS = @"192.168.1.1";
static const NSInteger UDP_HOST_PORT = 54321;

@interface VLUDPSocket() <GCDAsyncUdpSocketDelegate>
@property (strong, nonatomic) NSTimer* udpStayAliveTimer;
@property (strong, nonatomic) GCDAsyncUdpSocket* socket;
@property (strong, nonatomic) VLOBDDataParser* obdParser;
@property (strong, nonatomic) NSData* connectMessage;
@property (atomic) unsigned int retryCount;
@end

@implementation VLUDPSocket

- (VLOBDDataParser *)obdParser {
    if (!_obdParser) {
        _obdParser = [[VLOBDDataParser alloc] init];
    }
    return _obdParser;
}

- (NSData *)connectMessage {
    if (!_connectMessage) {
        
        NSString* deviceIdentifier = [NSString stringWithFormat:@"vvv%@", [[NSUUID UUID] UUIDString]];
        _connectMessage = [deviceIdentifier dataUsingEncoding:NSUTF8StringEncoding];

    }
    return _connectMessage;
}

- (void)dealloc {
    [self killStayAliveTimer];
    [self disconnect];
}

- (instancetype)init {
    if (self = [super init]) {
        [self setupSocket];
    }
    return self;
}


- (void)setupSocket {
    
    self.socket = [[GCDAsyncUdpSocket alloc] initWithDelegate:self delegateQueue:dispatch_get_main_queue()];
    
    NSError* error = nil;
    
    if(![self.socket bindToPort:UDP_HOST_PORT error:&error]) {
        NSLog(@"Failed to bind to socket port with error: %@", error);
        return;
    }
    
    if (![self.socket beginReceiving:&error]) {
        NSLog(@"Failed to begin receiving messages for socket with error: %@", error);
        return;
    }
    
    [self sendConnectMessage];
}

- (void)sendConnectMessage {
    
    NSLog(@"UDP: Stay alive");
    [self.socket sendData:self.connectMessage toHost:UDP_HOST_ADDRESS port:UDP_HOST_PORT withTimeout:0 tag:100];
    
    [self.udpStayAliveTimer invalidate];
    self.udpStayAliveTimer = nil;
    
    _retryCount++;
    int timerInterval = 8 + pow(MIN(_retryCount, 4), 3); // 8s base retry. Additional timeout duration increases exponentially capping at a 64s increase.
    
    self.udpStayAliveTimer = [NSTimer scheduledTimerWithTimeInterval:timerInterval target:self selector:@selector(sendConnectMessage) userInfo:nil repeats:NO];
}

- (void)killStayAliveTimer {
    [self.udpStayAliveTimer invalidate];
    self.udpStayAliveTimer = nil;
}

- (void) disconnect{
    if(self.udpStayAliveTimer != nil){
        [self killStayAliveTimer];
    }
    
    if(!_socket.isClosed){
        [_socket close];
    }
}


#pragma mark - AsyncUDPSocketDelegate Methods

- (void)udpSocket:(GCDAsyncUdpSocket *)sock didNotSendDataWithTag:(long)tag dueToError:(NSError *)error {
    NSLog(@"Failed to send data with error: %@", error);
}

- (void)udpSocket:(GCDAsyncUdpSocket *)sock didReceiveData:(NSData *)data
      fromAddress:(NSData *)address
withFilterContext:(id)filterContext {
    
    _retryCount = 0;
    
    NSDictionary* parsedData = [self.obdParser parseData:data];
    if (!parsedData) {
        return;
    }
    
    if([parsedData allKeys].count > 0){
        [self.delegate udpSocket:self receivedData:@{@"data" : parsedData}];
    }
}

- (void)udpSocketDidClose:(GCDAsyncUdpSocket *)sock withError:(NSError *)error {
    NSLog(@"Socket did disconnect");
    //[self killStayAliveTimer];
}


@end
