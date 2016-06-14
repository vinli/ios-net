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

@interface VLStream() <VLSocketManagerDelegate>

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
        self.socketManager = [[VLSocketManager alloc] initWithDeviceId:deviceId webURL:url parametricFilters:pFilters geometryFilter:gFilter];
        self.socketManager.delegate = self;
    }
    
    return self;
}

- (void) disconnect{
    [_socketManager disconnect];
}

- (void) dealloc {
    [self disconnect];
}

#pragma mark - VLSocketManagerDelegateMethods

- (void)socketManager:(VLSocketManager *)socketManager didReceiveData:(NSDictionary *)data {
    
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

@end
