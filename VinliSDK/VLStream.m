//
//  VLStream.m
//  VinliSDK
//
//  Created by Tommy Brown on 4/12/16.
//  Copyright © 2016 Vinli. All rights reserved.
//

#import "VLStream.h"
#import "JFRWebSocket.h"
#import "VLService.h"

@interface VLStream(){
    JFRWebSocket *streamSocket;
}
@end

@implementation VLStream

- (id) initWithURL:(NSURL *)url deviceId:(NSString *)deviceId{
    self = [super init];
    if(self){
        [self setupSocketWithURL:url deviceId:deviceId];
    }
    return self;
}

- (void) setupSocketWithURL:(NSURL *) url deviceId:(NSString *) deviceId{
    streamSocket = [[JFRWebSocket alloc] initWithURL:url protocols:nil];
    
    __weak JFRWebSocket *weakSocket = streamSocket;
    
    streamSocket.onConnect = ^{
        NSLog(@"Websocket is connected");
        
        JFRWebSocket *socket = weakSocket;
        
        NSDictionary* subjectDic = @{@"type" : @"device",
                                     @"id" : deviceId};
        NSDictionary* subscription = @{@"type" : @"sub",
                                       @"subject" : subjectDic};
        
        NSError *error;
        NSData *jsonData = [NSJSONSerialization dataWithJSONObject:subscription options:0 error:&error];
        
        if(jsonData){
            NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
            [socket writeString:jsonString];
        }else{
            NSLog(@"Websocket got an error: %@", error.description);
        }
    };
    
    streamSocket.onDisconnect = ^(NSError *error){
        NSLog(@"Websocked is disconnected");
    };
    
    streamSocket.onText = ^(NSString * jsonStr){
        NSLog(@"Websocket gotText: %@", jsonStr);
    };
    
    streamSocket.onData = ^(NSData *data){
        NSLog(@"Websocket got some binary data: %@", data.description);
    };
    
    [streamSocket connect];
}

@end
