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
#import "VLSocketManager.h"
#import "VLBearingCalculator.h"

@interface VLStream() <VLSocketManagerDelegate> {
    JFRWebSocket *streamSocket;
}

@property (strong, nonatomic) VLSocketManager* socketManager;
@property (strong, atomic) VLBearingCalculator * bearingCalculator;

@end

@implementation VLStream

- (id) initWithURL:(NSURL *)url deviceId:(NSString *)deviceId{
    return [self initWithURL:url deviceId:deviceId parametricFilters:nil geometryFilter:nil];
}

- (id) initWithURL:(NSURL *)url deviceId:(NSString *)deviceId parametricFilters:(NSArray *)pFilters geometryFilter:(VLGeometryFilter *)gFilter{
    self = [super init];
    
    if(self) {
        _bearingCalculator = [[VLBearingCalculator alloc] init];
        self.socketManager = [[VLSocketManager alloc] initWithDeviceId:deviceId];
        self.socketManager.delegate = self;
        [self setupSocketWithURL:url deviceId:deviceId parametricFilters:pFilters geometryFilter:gFilter];
    }
    
    return self;
}

- (void) setupSocketWithURL:(NSURL *)url deviceId:(NSString *)deviceId parametricFilters:(NSArray *)parametricFilters geometryFilter:(VLGeometryFilter *)geometryFilter{
    
    streamSocket = [[JFRWebSocket alloc] initWithURL:url protocols:nil];
    [streamSocket addHeader:@"application/json" forKey:@"Accept"];
    [streamSocket addHeader:@"application/json" forKey:@"Content-Type"];
    
    __weak JFRWebSocket *weakSocket = streamSocket;
    __weak VLStream* weakSelf = self;
    
    streamSocket.onConnect = ^{
        JFRWebSocket *socket = weakSocket;
        VLStream *strongSelf = weakSelf;
        
        NSDictionary* subjectDic = @{@"type" : @"device",
                                     @"id" : deviceId};
        NSDictionary* subscription = @{@"type" : @"sub",
                                       @"subject" : subjectDic};

        [strongSelf writeDictionary:subscription toSocket:socket];
        
        for(VLParametricFilter *pFilter in parametricFilters){
            NSDictionary *filterAsDictionary = [pFilter toDictionary];
            [strongSelf writeDictionary:filterAsDictionary toSocket:socket];
        }
        
        if(geometryFilter != nil){
            NSDictionary *filterAsDictionary = [geometryFilter toDictionary];
            [strongSelf writeDictionary:filterAsDictionary toSocket:socket];
        }
    };
    
    streamSocket.onDisconnect = ^(NSError *error){
        VLStream *strongSelf = weakSelf;
        if(strongSelf.onErrorBlock != nil){
            strongSelf.onErrorBlock(error);
        }
    };
    
    streamSocket.onText = ^(NSString * jsonStr){
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
            
            if(message.error != nil){
                if(strongSelf.onErrorBlock != nil){
                    strongSelf.onErrorBlock(message.error);
                }
            }else if([message.type isEqualToString:@"pub"]){
                // Only need to send publish messages to the user.
                
                if(message.coord != nil){
                    [strongSelf.bearingCalculator addCoordinate:message.coord atTimestamp:message.timestamp];
                    message.bearing = [NSNumber numberWithDouble:[strongSelf.bearingCalculator currentBearing]];
                }
                
                if(strongSelf.onRawMessageBlock != nil){
                    strongSelf.onRawMessageBlock(data);
                }
                
                if(strongSelf.onMessageBlock != nil){
                    strongSelf.onMessageBlock(message);
                }
            }
        }
    };
    
    streamSocket.onData = ^(NSData *data){
    };
    
    [streamSocket connect];
}

- (void) disconnect{
    if(streamSocket.isConnected){
        [streamSocket disconnect];
    }
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

- (void) dealloc {
    [self disconnect];
}

#pragma mark - VLSocketManagerDelegateMethods

- (void)socketManager:(VLSocketManager *)socketManager didReceiveData:(NSDictionary *)data {
    
    if (data && self.onMessageBlock) {
        VLStreamMessage* message = [[VLStreamMessage alloc] initWithDictionary:data];;
        self.onMessageBlock(message);
    }
}

@end
