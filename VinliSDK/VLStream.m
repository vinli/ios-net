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
    [streamSocket addHeader:@"application/json" forKey:@"Accept"];
    [streamSocket addHeader:@"application/json" forKey:@"Content-Type"];
    
    __weak JFRWebSocket *weakSocket = streamSocket;
    __weak VLStream* weakSelf = self;
    
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
        
        NSData *data = [jsonStr dataUsingEncoding:NSUTF8StringEncoding];
        NSError *error;
        id json = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
        
        VLStream* strongSelf = weakSelf;
        
        if(error){
            if(strongSelf.onErrorBlock != nil){
                strongSelf.onErrorBlock(error);
            }
        }
        
        if([json isKindOfClass:[NSDictionary class]]){
            VLStreamMessage *message = [[VLStreamMessage alloc] initWithDictionary:json];
            
            if(strongSelf.onMessageBlock != nil){
                strongSelf.onMessageBlock(message);
            }
        }
    };
    
    streamSocket.onData = ^(NSData *data){
        NSLog(@"Websocket got some binary data: %@", data.description);
    };
    
    [streamSocket connect];
}

@end
