//
//  VLWebSocket.m
//  streamservicetest
//
//  Created by Andrew Wells on 6/1/16.
//  Copyright © 2016 Vinli, Inc. All rights reserved.
//

#import "VLWebSocket.h"

#import "JFRWebSocket.h"

@interface VLWebSocket()
@property (strong, nonatomic) JFRWebSocket* socket;
@property (copy, nonatomic) NSString* deviceId;
@property (copy, nonatomic) NSString* token;
@end

@implementation VLWebSocket

- (instancetype)initWithDeviceId:(NSString*)deviceId token:(NSString *)token {
    if (self = [super init]) {
        self.deviceId = deviceId;
        self.token = token;
    }
    return self;
}

- (BOOL)isConnected {
    return self.socket.isConnected;
}

- (void)connect {
    //NSString* token = @"48wOSOqrddSMUrCmO35raGnXUENWNt_9AHAGAcWQBgwOi5E1YsqXw26yAPT11qVs";
    //f5999ee1-9b1f-4029-96a6-64550dd09ec1
    NSString* socketURLStr = [NSString stringWithFormat:@"wss://stream.vin.li/api/v1/messages?token=%@", self.token];
    NSURL* webSocketURL = [NSURL URLWithString:socketURLStr];
    self.socket = [[JFRWebSocket alloc] initWithURL:webSocketURL protocols:nil];
    
    [self setupSocketHandlers];
    
    [self.socket connect];
}

- (void)disconnect {
    [self.socket disconnect];
}

- (void)setupSocketHandlers {
    
    if (!self.deviceId) {
        NSLog(@"DeviceId required to start a stream!");
        return;
    }
    
    __weak JFRWebSocket* weakSocket = self.socket;
    self.socket.onConnect = ^{
        NSLog(@"websocket is connected");
        JFRWebSocket* socket = weakSocket;
        
        NSDictionary* subjectDic = @{@"type" : @"device",
                                     @"id" : self.deviceId};
        NSDictionary* subscription = @{@"type" : @"sub",
                                       @"subject" : subjectDic};
        
        
        NSError *error;
        NSData *jsonData = [NSJSONSerialization dataWithJSONObject:subscription
                                                           options:0//NSJSONWritingPrettyPrinted
                                                             error:&error];
        
        if (! jsonData) {
            NSLog(@"Got an error: %@", error);
        } else {
            NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
            [socket writeString:jsonString];
        }
        
    };
    
    //websocketDidDisconnect
    self.socket.onDisconnect = ^(NSError *error) {
        NSLog(@"websocket is disconnected: %@",[error localizedDescription]);
    };
    
    //websocketDidReceiveMessage
    __weak VLWebSocket* weakSelf = self;
    self.socket.onText = ^(NSString *jsonStr) {
        //NSLog(@"got some text: %@", jsonStr);
        
        NSData *data = [jsonStr dataUsingEncoding:NSUTF8StringEncoding];
        NSError* error;
        id json = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
        if (error) {
            NSLog(@"Failed to parse json with error: %@", error);
            return;
        }
        
        VLWebSocket* strongSelf = weakSelf;
        [strongSelf.delegate webSocket:self didReceiveData:json];
        
        return;
        
        if ([json isKindOfClass:[NSDictionary class]]) {
            NSDictionary* data = json[@"payload"][@"data"];
            if (data) {
                NSLog(@"%@", data);
            }
            else
            {
                NSLog(@"%@", json);
            }
        }
        
    };

}

@end
