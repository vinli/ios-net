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
@property (strong, nonatomic) NSURL *url;
@property (strong, nonatomic) NSArray *parametricFilters;
@property (strong, nonatomic) VLGeometryFilter *geometryFilter;
@end

@implementation VLWebSocket

- (instancetype)initWithDeviceId:(NSString*)deviceId url:(NSURL *)url parametricFilters:(NSArray *)pFilters geometryFilter:(VLGeometryFilter *)gFilter{
    if (self = [super init]) {
        self.deviceId = deviceId;
        self.url = url;
        self.parametricFilters = pFilters;
        self.geometryFilter = gFilter;
    }
    return self;
}

- (BOOL)isConnected {
    return self.socket.isConnected;
}

- (void)connect {
    self.socket = [[JFRWebSocket alloc] initWithURL:_url protocols:nil];
    
    [self setupSocketHandlers];
    
    [self.socket connect];
}

- (void)disconnect {
    if(self.socket.isConnected){
        [self.socket disconnect];
    }
}

- (void) dealloc {
    [self disconnect];
}

- (void)setupSocketHandlers {
    
    if (!self.deviceId) {
        NSLog(@"DeviceId required to start a stream!");
        return;
    }
    
    __weak JFRWebSocket* weakSocket = self.socket;
    __weak VLWebSocket* weakSelf = self;
    
    self.socket.onConnect = ^{
        NSLog(@"websocket is connected");
        JFRWebSocket* socket = weakSocket;
        VLWebSocket* strongSelf = weakSelf;
        
        NSDictionary* subjectDic = @{@"type" : @"device",
                                     @"id" : strongSelf.deviceId};
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
            
            for(VLParametricFilter *pFilter in strongSelf.parametricFilters){
                NSDictionary *filterAsDictionary = [pFilter toDictionary];
                [strongSelf writeDictionary:filterAsDictionary toSocket:socket];
            }
            
            if(strongSelf.geometryFilter != nil){
                NSDictionary *filterAsDictionary = [strongSelf.geometryFilter toDictionary];
                [strongSelf writeDictionary:filterAsDictionary toSocket:socket];
            }
        }
        
    };
    
    //websocketDidDisconnect
    self.socket.onDisconnect = ^(NSError *error) {
        NSLog(@"websocket is disconnected: %@",[error localizedDescription]);
    };
    
    //websocketDidReceiveMessage
    self.socket.onText = ^(NSString *jsonStr) {
        
        NSData *data = [jsonStr dataUsingEncoding:NSUTF8StringEncoding];
        NSError* error;
        id json = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
        if (error) {
            NSLog(@"Failed to parse json with error: %@", error);
            return;
        }
        
        VLWebSocket* strongSelf = weakSelf;
        [strongSelf.delegate webSocket:strongSelf didReceiveData:json];
        
        return;
    };

}

- (void) writeDictionary:(NSDictionary *)dictinary toSocket:(JFRWebSocket *)socket{
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dictinary options:0 error:&error];
    
    if(jsonData){
        NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
        [socket writeString:jsonString];
    }else{
        NSLog(@"Error parsing dictionary into JSON. Error: %@, Dictionary: %@", error, dictinary);
    }
}

@end
