//
//  VLStream.m
//  VinliSDK
//
//  Created by Tommy Brown on 4/12/16.
//  Copyright © 2016 Vinli. All rights reserved.
//

#import "VLStream.h"
#import "VLService.h"
#import "VLBearingCalculator.h"
#import "VLWebSocket.h"
#import "VLUDPSocket.h"

@interface VLStream() <VLUDPSocketDelegate, VLWebSocketDelegate>

@property (strong, atomic) VLBearingCalculator * bearingCalculator;

@property (strong, nonatomic) VLWebSocket* webSocket;
@property (strong, nonatomic) VLUDPSocket* udpSocket;

@property (strong, nonatomic) NSTimer* udpConnectionTimer;
@property (assign, nonatomic) BOOL receivedMessage;

@property (strong, nonatomic) NSString* deviceId;
@property (strong, nonatomic) NSURL *webURL;
@property (strong, nonatomic) NSArray *parametricFilters;
@property (strong, nonatomic) VLGeometryFilter *geometryFilter;
@property (strong, nonatomic) NSDateFormatter *dateFormatter;

@end

@implementation VLStream

- (id) initWithURL:(NSURL *)url deviceId:(NSString *)deviceId{
    return [self initWithURL:url deviceId:deviceId parametricFilters:nil geometryFilter:nil];
}

- (id) initWithURL:(NSURL *)url deviceId:(NSString *)deviceId parametricFilters:(NSArray *)pFilters geometryFilter:(VLGeometryFilter *)gFilter{
    self = [super init];
    
    if(self) {
        _bearingCalculator = [[VLBearingCalculator alloc] init];
        
        self.deviceId = deviceId;
        self.webURL = url;
        self.parametricFilters = pFilters;
        self.geometryFilter = gFilter;
        
        self.dateFormatter = [[NSDateFormatter alloc] init];
        self.dateFormatter.dateFormat = @"yyyy-MM-dd'T'HH:mm:ss.SSS'Z'";
        
        [self setupSockets];
    }
    
    return self;
}

- (void)setupSockets {
    
    self.udpSocket = [VLUDPSocket new];
    self.udpSocket.delegate = self;
    
    self.udpConnectionTimer = [NSTimer scheduledTimerWithTimeInterval:8 target:self selector:@selector(checkConnection) userInfo:nil repeats:YES];
    
    [self checkConnection];
}

- (void)launchWebSocket {
    
    if (!self.webSocket) {
        self.webSocket = [[VLWebSocket alloc] initWithDeviceId:self.deviceId url:_webURL parametricFilters:_parametricFilters geometryFilter:_geometryFilter];
        self.webSocket.delegate = self;
    }
    
    if (self.webSocket.isConnected) {
        return;
    }
    
    NSLog(@"Websocket: Connecting");
    [self.webSocket connect];
}

- (void)checkConnection {
    
    if (!self.receivedMessage) {
        NSLog(@"UDP: Lost connection to device");
        [self launchWebSocket];
        return;
    }
    
    self.receivedMessage = NO;
}

- (void)handleReceivedUDPMessage {
    
    self.receivedMessage = YES;
    
    if (self.webSocket.isConnected) {
        NSLog(@"Websocket: Disconnecting");
        [self.webSocket disconnect];
    }
}

- (void)didReceiveData:(NSDictionary *)data {
    
    if (data && (self.onMessageBlock || self.onRawMessageBlock)) {
        VLStreamMessage* message = [[VLStreamMessage alloc] initWithDictionary:data];
        
        if([message.type isEqualToString:@"pub"]){
            if(message.coord != nil){
                [self.bearingCalculator addCoordinate:message.coord atTimestamp:message.timestamp];
                message.bearing = [NSNumber numberWithDouble:[self.bearingCalculator currentBearing]];
            }
            
            if(self.onMessageBlock){
                self.onMessageBlock(message);
            }
            
            if(self.onRawMessageBlock){
                NSError *error;
                NSData *rawData = [NSJSONSerialization dataWithJSONObject:data options:0 error:&error];
                if(!error){
                    self.onRawMessageBlock(rawData);
                }
            }
            
        }
    }
}

- (void)killConnectionTimer {
    [self.udpConnectionTimer invalidate];
    self.udpConnectionTimer = nil;
}

- (void) disconnect{
    [self killConnectionTimer];
    [_webSocket disconnect];
    [_udpSocket disconnect];
}

- (void)dealloc {
    [self killConnectionTimer];
}

#pragma mark - VLWebSocketDelegate

- (void)webSocket:(VLWebSocket *)webSocket didReceiveData:(NSDictionary *)data
{
    [self didReceiveData:data];
}

#pragma mark - VLUDPSocketDelegate

- (void)udpSocket:(VLUDPSocket *)udpSocket receivedData:(NSDictionary *)data {
    
    [self handleReceivedUDPMessage];
    
    if (!data) {
        return;
    }
    
    data = [data mutableCopy];
    NSMutableDictionary* messageData = [NSMutableDictionary new];
    [messageData setObject:data forKey:@"payload"];
    [messageData setObject:@"pub" forKey:@"type"];
    
    [[messageData objectForKey:@"payload"] setObject:[[NSUUID UUID] UUIDString] forKey:@"id"];
    [[messageData objectForKey:@"payload"] setObject:[self.dateFormatter stringFromDate:[NSDate date]] forKey:@"timestamp"];
    
    if (self.deviceId) {
        NSDictionary* subject = @{@"id": self.deviceId, @"type" : @"device"};
        [messageData setObject:subject forKey:@"subject"];
    }
    
    [self didReceiveData:messageData];
}

@end
