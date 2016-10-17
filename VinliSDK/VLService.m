//
//  VLRequestConnection.m
//  VinliSDK
//
//  Created by Cheng Gu on 8/21/14.
//  Copyright (c) 2014 Cheng Gu. All rights reserved.
//

#import "VLService.h"
#import "JCDHTTPConnection.h"
#import "VLRequestHeader.h"

#import "VLDevice.h"
#import "VLBoundary.h"

#import "VLErrorConstants.h"
#import "NSHTTPURLResponse+VLAdditions.h"

#define NUMBER_DEFAULT_PORT        @80
#define NUMBER_HTTPS_PORT          @443
#define STRING_API_VERSION      @"/api/v1"
#define STRING_CONTENT_TYPE     @"application/json"

#define ERROR_VINLI_DOMAIN      @"VinliSDKErrorDomain"
#define ERROR_NO_SESSION        @"VinliSDKErrorNoSession"

#define STRING_HOST_EVENTS      @"events"
#define STRING_HOST_PLATFORM    @"platform"
#define STRING_HOST_TELEMETRY   @"telemetry"
#define STRING_HOST_DIAG        @"diag"
#define STRING_HOST_RULES       @"rules"
#define STRING_HOST_AUTH        @"auth"
#define STRING_HOST_TRIPS       @"trips"
#define STRING_HOST_STREAM      @"stream"
#define STRING_HOST_DISTANCE    @"distance"
#define STRING_HOST_DIAGNOSTIC  @"diagnostic"

#define DEFAULT_HOST            @".vin.li"





@interface VLService (){
}

@property (copy, nonatomic) void(^AccessTokenExpirationHandler)(VLService* service, NSError* error);


@end

@implementation VLService

#pragma mark - Initialization

- (id) initWithSession:(VLSession *)session{
    self = [super init];
    if(self){
        _session = session;
        _host = DEFAULT_HOST;
    }
    return self;
}

- (id) init{
    self = [super init];
    if(self){
        _host = DEFAULT_HOST;
    }
    return self;
}

- (void) setHost:(NSString *)host{
    _host = host;
}

- (void) useSession:(VLSession *)session{
    _session = session;
}

#pragma mark - Factory Methods

- (void)startWithHost:(NSString *)host
                 path:(NSString *)path
              queries:(NSDictionary *)queries
           HTTPMethod:(NSString *)method
           parameters:(NSDictionary *)dictParams
                token:(NSString *) token
            onSuccess:(void (^)(NSDictionary *, NSHTTPURLResponse *))onSuccessfulBlock
            onFailure:(void (^)(NSError *, NSHTTPURLResponse *, NSString *))onFailureBlock
{
    NSString *strUri = @"";
    host = [host stringByAppendingString:_host];
    
    strUri = [NSString stringWithFormat:@"%@%@", STRING_API_VERSION, path];
    
    if(queries != nil) {
        NSString *queryString = @"";
        
        for(NSString *key in queries.allKeys){
            NSString *value = [queries objectForKey:key];
            
            if(queryString.length == 0){
                queryString = [queryString stringByAppendingString:[NSString stringWithFormat:@"?%@=%@", key, value]];
            }else{
                queryString = [queryString stringByAppendingString:[NSString stringWithFormat:@"&%@=%@", key, value]];
            }
        }
        
        if(queryString.length > 0) {
            queryString = [queryString stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
            strUri = [strUri stringByAppendingString:queryString];
        }
        
        //NSLog(@"%@ Queries = %@", host, queryString);
    }
    
    
    if (dictParams) {
        if (![NSJSONSerialization isValidJSONObject:dictParams]) {
            if (onFailureBlock) {
                NSError *error = [NSError errorWithDomain:ERROR_VINLI_DOMAIN code:2001 userInfo:@{@"NSLocalizedDescriptionKey": @"Payload is not a valid JSON object"}];
                onFailureBlock(error, nil, nil);
            }
            return;
        }
    }
    
    NSURLRequest *request = [VLRequestHeader requestWithToken:token
                                                       method:method
                                                  contentType:STRING_CONTENT_TYPE
                                                     protocol:VLProtocolTypeHTTPS
                                                         host:host
                                                 requestUri:strUri
                                                         port:nil
                                                      payload:dictParams];
    //NSLog(@"REQUEST = %@", request);
    
    
    
    
    [self startConnectionWithRequest:request method:method onSuccess:onSuccessfulBlock onFailure:onFailureBlock];
    

}



- (void)startConnectionWithRequest:(NSURLRequest *)request method:(NSString *)method onSuccess:(void (^)(NSDictionary *, NSHTTPURLResponse *))onSuccessfulBlock onFailure:(void (^)(NSError *, NSHTTPURLResponse *, NSString *))onFailureBlock {
    JCDHTTPConnection *connection = [[JCDHTTPConnection alloc] initWithRequest:request];
    
    [connection executeRequestOnSuccess:
     ^(NSHTTPURLResponse *response, NSString *bodyString, NSData *responseData) {
         
         NSError *error;
         
         if((responseData == nil || responseData.length == 0) && [method isEqualToString:@"DELETE"]){
             if(onSuccessfulBlock){
                 onSuccessfulBlock(nil, response);
             }
             return;
         }
         
         NSDictionary *dictJSON = [NSJSONSerialization JSONObjectWithData:responseData options:NSUTF8StringEncoding error:&error];
         if (error) {
             if (onFailureBlock) {
                 onFailureBlock(error, response, bodyString);
             }
             return;
         }
         
         if (onSuccessfulBlock) {
             onSuccessfulBlock(dictJSON, response);
         }
         
     } failure:^(NSHTTPURLResponse *response, NSString *bodyString, NSError *error) {
         
         if (response.statusCode == 401) {
             NSLog(@"Access token has expired");
             // Genereate custom nserror
             
             // Give option to execute block
             if (self.AccessTokenExpirationHandler) {
                 self.AccessTokenExpirationHandler(self, error);
             }
             
         }
         
         if (onFailureBlock) {
             onFailureBlock(error, response, bodyString);
         }
     } didSendData:nil];
    

}

- (void)startWithHost:(NSString *)token requestUri:(NSString *)requestUri onSuccess:(void (^)(NSDictionary *, NSHTTPURLResponse *))onSuccessBlock onFailure:(void (^)(NSError *, NSHTTPURLResponse *, NSString *))onFailureBlock
{
    NSURLRequest *request = [VLRequestHeader requestWithToken:token contentType:STRING_CONTENT_TYPE requestUri:requestUri];
    [self startConnectionWithRequest:request method:@"GET" onSuccess:onSuccessBlock onFailure:onFailureBlock];
}






- (NSDictionary *) getDictionaryWithLimit: (nullable NSNumber *) limit
                                   offset:(nullable NSNumber *) offset{
    
    NSMutableDictionary *dictionary = [[NSMutableDictionary alloc] init];
    
    if(limit != nil){
        [dictionary setObject:limit forKey:@"limit"];
    }
    
    if(offset != nil){
        [dictionary setObject:offset forKey:@"offset"];
    }
    
    if(dictionary.count == 0){
        return nil;
    }else{
        return dictionary;
    }
}

- (NSDictionary *) getDictionaryWithLimit:(nullable NSNumber *) limit
                                    until:(nullable NSDate *) until
                                    since:(nullable NSDate *) since
                            sortDirection:(nullable NSString *) sortDirection{
    
    NSMutableDictionary *dictionary = [[NSMutableDictionary alloc] init];
    
    if(limit != nil){
        [dictionary setObject:limit forKey:@"limit"];
    }
    
    if(until != nil){
        [dictionary setObject:until forKey:@"until"];
    }
    
    if(since != nil){
        [dictionary setObject:since forKey:@"since"];
    }
    
    if(sortDirection != nil && sortDirection.length > 0){
        [dictionary setObject:sortDirection forKey:@"sortDir"];
    }
    
    if(dictionary.count == 0){
        return nil;
    } else{
        return dictionary;
    }
}

#pragma mark - Platform Services

- (void) getDevicesOnSuccess:(void (^)(VLDevicePager *devicePager, NSHTTPURLResponse *response))onSuccessBlock
                   onFailure:(void (^)(NSError *error, NSHTTPURLResponse *response, NSString *bodyString))onFailureBlock{
    
    [self getDevicesWithLimit:nil offset:nil onSuccess:onSuccessBlock onFailure:onFailureBlock];
}

- (void) getDevicesWithLimit: (nullable NSNumber *) limit
                      offset: (nullable NSNumber *) offset
                   onSuccess:(void (^)(VLDevicePager *devicePager, NSHTTPURLResponse *response))onSuccessBlock
                   onFailure:(void (^)(NSError *error, NSHTTPURLResponse *response, NSString *bodyString))onFailureBlock{
    
    if(_session == nil){
        if(onFailureBlock){
            onFailureBlock([self getNoSessionError], nil, nil);
        }
        return;
    }
    
    NSString *path = [NSString stringWithFormat:@"/devices"];
    
    [self startWithHost:STRING_HOST_PLATFORM path:path queries:[self getDictionaryWithLimit:limit offset:offset] HTTPMethod:@"GET" parameters:nil token:_session.accessToken onSuccess:^(NSDictionary *result, NSHTTPURLResponse *response) {
        
        if ([response isSuccessfulResponse]) {
            if (onSuccessBlock) {
                VLDevicePager *devicePager = [[VLDevicePager alloc] initWithDictionary:result service:self];
                onSuccessBlock(devicePager, response);
            }
        }
        else {
            if (onFailureBlock) {
                NSError *error = [NSError errorWithDomain:ERROR_VINLI_DOMAIN code:2002 userInfo:@{@"NSLocalizedDescriptionKey": @"Received unexpected response from API call"}];
                onFailureBlock(error, response, result.description);
            }
        }
    } onFailure:^(NSError *error, NSHTTPURLResponse *response, NSString *bodyString) {
        if (onFailureBlock) {
            onFailureBlock(error, response, bodyString);
        }
    }];
}

- (void) getDeviceWithId:(NSString *) deviceId
                       onSuccess:(void (^)(VLDevice *device, NSHTTPURLResponse *response))onSuccessBlock
                       onFailure:(void (^)(NSError *error, NSHTTPURLResponse *response, NSString *bodyString))onFailureBlock{
    
    if(_session == nil){
        if(onFailureBlock){
            onFailureBlock([self getNoSessionError], nil, nil);
        }
        return;
    }
    
    NSString *path = [NSString stringWithFormat:@"/devices/%@", deviceId];
    
    [self startWithHost:STRING_HOST_PLATFORM path:path queries:nil HTTPMethod:@"GET" parameters:nil token:_session.accessToken onSuccess:^(NSDictionary *result, NSHTTPURLResponse *response) {
        
        if ([response isSuccessfulResponse]) {
            if (onSuccessBlock) {
                VLDevice *device = [[VLDevice alloc] initWithDictionary:result];
                onSuccessBlock(device, response);
            }
        }
        else {
            if (onFailureBlock) {
                NSError *error = [NSError errorWithDomain:ERROR_VINLI_DOMAIN code:2002 userInfo:@{@"NSLocalizedDescriptionKey": @"Received unexpected response from API call"}];
                onFailureBlock(error, response, result.description);
            }
        }
    } onFailure:^(NSError *error, NSHTTPURLResponse *response, NSString *bodyString) {
        if (onFailureBlock) {
            onFailureBlock(error, response, bodyString);
        }
    }];
}

- (void)getDeviceCapabilitiesWithId:(NSString *)deviceId
                        onSuccess:(void (^)(NSDictionary *capabilites, NSHTTPURLResponse *response))onSuccessBlock
                        onFailure:(void (^)(NSError *, NSHTTPURLResponse *, NSString *))onFailureBlock
{
    if(_session == nil){
        if(onFailureBlock){
            onFailureBlock([self getNoSessionError], nil, nil);
        }
        return;
    }
    
    NSString *path = [NSString stringWithFormat:@"/devices/%@/capabilities", deviceId];
    
    [self startWithHost:STRING_HOST_PLATFORM path:path queries:nil HTTPMethod:@"GET" parameters:nil token:_session.accessToken onSuccess:^(NSDictionary *result, NSHTTPURLResponse *response) {
        
        if ([response isSuccessfulResponse]) {
            if (onSuccessBlock) {
                NSDictionary* capabilites = result[@"capabilities"];
                onSuccessBlock(capabilites, response);
            }
        }
        else {
            if (onFailureBlock) {
                NSError *error = [NSError errorWithDomain:ERROR_VINLI_DOMAIN code:2002 userInfo:@{@"NSLocalizedDescriptionKey": @"Received unexpected response from API call"}];
                onFailureBlock(error, response, result.description);
            }
        }
    } onFailure:^(NSError *error, NSHTTPURLResponse *response, NSString *bodyString) {
        if (onFailureBlock) {
            onFailureBlock(error, response, bodyString);
        }
    }];

}

- (void) getLatestVehicleForDeviceWithId:(NSString *) deviceId
                               onSuccess:(void (^)(VLVehicle *vehicle, NSHTTPURLResponse *response))onSuccessBlock
                               onFailure:(void (^)(NSError *error, NSHTTPURLResponse *response, NSString *bodyString))onFailureBlock{
    
    if(_session == nil){
        if(onFailureBlock){
            onFailureBlock([self getNoSessionError], nil, nil);
        }
        return;
    }
    
    NSString *path = [NSString stringWithFormat:@"/devices/%@/vehicles/_latest", deviceId];
    
    [self startWithHost:STRING_HOST_PLATFORM path:path queries:nil HTTPMethod:@"GET" parameters:nil token:_session.accessToken onSuccess:^(NSDictionary *result, NSHTTPURLResponse *response) {
        
        if ([response isSuccessfulResponse]) {
            if (onSuccessBlock) {
                VLVehicle *vehicle = [[VLVehicle alloc] initWithDictionary:result];
                onSuccessBlock(vehicle, response);
            }
        }
        else {
            if (onFailureBlock) {
                NSError *error = [NSError errorWithDomain:ERROR_VINLI_DOMAIN code:2002 userInfo:@{@"NSLocalizedDescriptionKey": @"Received unexpected response from API call"}];
                onFailureBlock(error, response, result.description);
            }
        }
    } onFailure:^(NSError *error, NSHTTPURLResponse *response, NSString *bodyString) {
        if (onFailureBlock) {
            onFailureBlock(error, response, bodyString);
        }
    }];
    
}

- (void) getVehiclesForDeviceWithId:(NSString *) deviceId
                             onSuccess:(void (^)(VLVehiclePager *vehiclePager, NSHTTPURLResponse *response))onSuccessBlock
                             onFailure:(void (^)(NSError *error, NSHTTPURLResponse *response, NSString *bodyString))onFailureBlock{
    
    [self getVehiclesForDeviceWithId:deviceId limit:nil offset:nil onSuccess:onSuccessBlock onFailure:onFailureBlock];
}

- (void) getVehiclesForDeviceWithId:(NSString *) deviceId
                          limit:(nullable NSNumber *) limit
                         offset:(nullable NSNumber *) offset
                          onSuccess:(void (^)(VLVehiclePager *vehiclePager, NSHTTPURLResponse *response))onSuccessBlock
                          onFailure:(void (^)(NSError *error, NSHTTPURLResponse *response, NSString *bodyString))onFailureBlock{
    if(_session == nil){
        if(onFailureBlock){
            onFailureBlock([self getNoSessionError], nil, nil);
        }
        return;
    }
    
    NSString *path = [NSString stringWithFormat:@"/devices/%@/vehicles", deviceId];
    
    [self startWithHost:STRING_HOST_PLATFORM path:path queries:[self getDictionaryWithLimit:limit offset:offset] HTTPMethod:@"GET" parameters:nil token:_session.accessToken onSuccess:^(NSDictionary *result, NSHTTPURLResponse *response) {
        
        if ([response isSuccessfulResponse]) {
            if (onSuccessBlock) {
                VLVehiclePager *vehiclePager = [[VLVehiclePager alloc] initWithDictionary:result service:self];
                onSuccessBlock(vehiclePager, response);
            }
        }
        else {
            if (onFailureBlock) {
                NSError *error = [NSError errorWithDomain:ERROR_VINLI_DOMAIN code:2002 userInfo:@{@"NSLocalizedDescriptionKey": @"Received unexpected response from API call"}];
                onFailureBlock(error, response, result.description.description);
            }
        }
    } onFailure:^(NSError *error, NSHTTPURLResponse *response, NSString *bodyString) {
        if (onFailureBlock) {
            onFailureBlock(error, response, bodyString);
        }
    }];
}

#pragma mark - Rule Service

- (void) getRulesForDeviceWithId:(NSString *) deviceId
                          onSuccess:(void (^)(VLRulePager *rulePager, NSHTTPURLResponse *response))onSuccessBlock
                          onFailure:(void (^)(NSError *error, NSHTTPURLResponse *response, NSString *bodyString))onFailureBlock{
    
    [self getRulesForDeviceWithId:deviceId limit:nil offset:nil onSuccess:onSuccessBlock onFailure:onFailureBlock];
}

- (void) getRulesForDeviceWithId:(NSString *) deviceId
                           limit:(nullable NSNumber *) limit
                          offset:(nullable NSNumber *) offset
                       onSuccess:(void (^)(VLRulePager *rulePager, NSHTTPURLResponse *response))onSuccessBlock
                       onFailure:(void (^)(NSError *error, NSHTTPURLResponse *response, NSString *bodyString))onFailureBlock{
    
    if(_session == nil){
        if(onFailureBlock){
            onFailureBlock([self getNoSessionError], nil, nil);
        }
        return;
    }
    
    NSString *path = [NSString stringWithFormat:@"/devices/%@/rules", deviceId];
    
    [self startWithHost:STRING_HOST_RULES path:path queries:[self getDictionaryWithLimit:limit offset:offset] HTTPMethod:@"GET" parameters:nil token:_session.accessToken onSuccess:^(NSDictionary *result, NSHTTPURLResponse *response) {
        
        if ([response isSuccessfulResponse]) {
            if (onSuccessBlock) {
                VLRulePager *rulePager = [[VLRulePager alloc] initWithDictionary:result service:self];
                onSuccessBlock(rulePager, response);
            }
        }
        else {
            if (onFailureBlock) {
                NSError *error = [NSError errorWithDomain:ERROR_VINLI_DOMAIN code:2002 userInfo:@{@"NSLocalizedDescriptionKey": @"Received unexpected response from API call"}];
                onFailureBlock(error, response, result.description.description);
            }
        }
    } onFailure:^(NSError *error, NSHTTPURLResponse *response, NSString *bodyString) {
        if (onFailureBlock) {
            onFailureBlock(error, response, bodyString);
        }
    }];
}

- (void) createRule:(VLRule *) rule
          forDevice: (NSString *) deviceId
          onSuccess:(void (^)(VLRule *rule, NSHTTPURLResponse *response))onSuccessBlock
          onFailure:(void (^)(NSError *error, NSHTTPURLResponse *response, NSString *bodyString))onFailureBlock{
    
    if(_session == nil){
        if(onFailureBlock){
            onFailureBlock([self getNoSessionError], nil, nil);
        }
        return;
    }
    
    NSString *path = [NSString stringWithFormat:@"/devices/%@/rules", deviceId];
    NSDictionary *parameters = [rule toDictionary];
    
    [self startWithHost:STRING_HOST_RULES path:path queries:nil HTTPMethod:@"POST" parameters:parameters token:_session.accessToken onSuccess:^(NSDictionary *result, NSHTTPURLResponse *response) {
        
        if ([response isSuccessfulResponse]) {
            if (onSuccessBlock) {
                VLRule *rule = [[VLRule alloc] initWithDictionary:result];
                onSuccessBlock(rule, response);
            }
        }
        else {
            if (onFailureBlock) {
                NSError *error = [NSError errorWithDomain:ERROR_VINLI_DOMAIN code:2002 userInfo:@{@"NSLocalizedDescriptionKey": @"Received unexpected response from API call"}];
                onFailureBlock(error, response, result.description);
            }
        }
    } onFailure:^(NSError *error, NSHTTPURLResponse *response, NSString *bodyString) {
        if (onFailureBlock) {
            onFailureBlock(error, response, bodyString);
        }
    }];
}

- (void) getRuleWithId:(NSString *) ruleId
                     onSuccess:(void (^)(VLRule *rule, NSHTTPURLResponse *response))onSuccessBlock
                     onFailure:(void (^)(NSError *error, NSHTTPURLResponse *response, NSString *bodyString))onFailureBlock{
    
    if(_session == nil){
        if(onFailureBlock){
            onFailureBlock([self getNoSessionError], nil, nil);
        }
        return;
    }
    
    NSString *path = [NSString stringWithFormat:@"/rules/%@", ruleId];
    
    [self startWithHost:STRING_HOST_RULES path:path queries:nil HTTPMethod:@"GET" parameters:nil token:_session.accessToken onSuccess:^(NSDictionary *result, NSHTTPURLResponse *response) {

        if ([response isSuccessfulResponse]) {
            if (onSuccessBlock) {
                VLRule *rule = [[VLRule alloc] initWithDictionary:result];
                onSuccessBlock(rule, response);
            }
        }
        else {
            if (onFailureBlock) {
                NSError *error = [NSError errorWithDomain:ERROR_VINLI_DOMAIN code:2002 userInfo:@{@"NSLocalizedDescriptionKey": @"Received unexpected response from API call"}];
                onFailureBlock(error, response, result.description);
            }
        }
    } onFailure:^(NSError *error, NSHTTPURLResponse *response, NSString *bodyString) {
        if (onFailureBlock) {
            onFailureBlock(error, response, bodyString);
        }
    }];
}

- (void) deleteRuleWithId:(NSString *) ruleId
                        onSuccess:(void (^)(NSHTTPURLResponse *response))onSuccessBlock
                        onFailure:(void (^)(NSError *error, NSHTTPURLResponse *response, NSString *bodyString))onFailureBlock{
    
    if(_session == nil) {
        if(onFailureBlock){
            onFailureBlock([self getNoSessionError], nil, nil);
        }
        return;
    }
    
    NSString *path = [NSString stringWithFormat:@"/rules/%@", ruleId];
    
    [self startWithHost:STRING_HOST_RULES path:path queries:nil HTTPMethod:@"DELETE" parameters:nil token:_session.accessToken onSuccess:^(NSDictionary *result, NSHTTPURLResponse *response) {
        
        if ([response isSuccessfulResponse]) {
            if (onSuccessBlock) {
                onSuccessBlock(response);
            }
        }
        else {
            if (onFailureBlock) {
                NSError *error = [NSError errorWithDomain:ERROR_VINLI_DOMAIN code:2002 userInfo:@{@"NSLocalizedDescriptionKey": @"Received unexpected response from API call"}];
                onFailureBlock(error, response, result.description);
            }
        }
    } onFailure:^(NSError *error, NSHTTPURLResponse *response, NSString *bodyString) {
        if (onFailureBlock) {
            onFailureBlock(error, response, bodyString);
        }
    }];
}

#pragma mark - Telemetry Services

- (void) getSnapshotsForDeviceWithId:(NSString *) deviceId
                              fields:(nonnull NSString *)fields
                           onSuccess:(void (^)(VLSnapshotPager *snapshotPager, NSHTTPURLResponse *response))onSuccessBlock
                           onFailure:(void (^)(NSError *error, NSHTTPURLResponse *response, NSString *bodyString))onFailureBlock{
    
    [self getSnapshotsForDeviceWithId:deviceId fields:fields limit:nil until:nil since:nil sortDirection:nil onSuccess:onSuccessBlock onFailure:onFailureBlock];
}

- (void) getSnapshotsForDeviceWithId:(NSString *) deviceId
                              fields:(nonnull NSString *)fields
                               limit:(nullable NSNumber *)limit
                               until:(nullable NSDate *)until
                               since:(nullable NSDate *)since
                       sortDirection:(nullable NSString *)sortDirection
                           onSuccess:(void (^)(VLSnapshotPager *snapshotPager, NSHTTPURLResponse *response))onSuccessBlock
                           onFailure:(void (^)(NSError *error, NSHTTPURLResponse *response, NSString *bodyString))onFailureBlock{

    
    VLTimeSeries *timeSeries = [VLTimeSeries timeSeriesFromDate:since until:until];
    timeSeries.sortOrder = ([sortDirection isEqualToString:@"asc"]) ? VLTimerSeriesSortDirectionAscending : VLTimerSeriesSortDirectionDescending;
    timeSeries.limit = limit;
    
    [self getSnapshotsForDeviceWithId:deviceId fields:fields timeSeries:timeSeries onSuccess:onSuccessBlock onFailure:onFailureBlock];
    
    
}

- (void)getSnapshotsForDeviceWithId:(NSString *)deviceId fields:(NSString *)fields timeSeries:(VLTimeSeries *)timeSeries onSuccess:(void (^)(VLSnapshotPager *, NSHTTPURLResponse *))onSuccessBlock onFailure:(void (^)(NSError *, NSHTTPURLResponse *, NSString *))onFailureBlock
{
    if(_session == nil){
        if(onFailureBlock){
            onFailureBlock([self getNoSessionError], nil, nil);
        }
        return;
    }
    
    NSString *path = [NSString stringWithFormat:@"/devices/%@/snapshots", deviceId];
    
    NSMutableDictionary *queries = [[timeSeries toDictionary] mutableCopy];
    if (!queries)
    {
        queries = [NSMutableDictionary new];
    }
    [queries setObject:fields forKey:@"fields"];
    
    [self startWithHost:STRING_HOST_TELEMETRY path:path queries:queries HTTPMethod:@"GET" parameters:nil token:_session.accessToken onSuccess:^(NSDictionary *result, NSHTTPURLResponse *response) {
        
        if ([response isSuccessfulResponse]) {
            if (onSuccessBlock) {
                //NSLog(@"result: %@", result);
                VLSnapshotPager *snapshotPager = [[VLSnapshotPager alloc] initWithDictionary:result service:self fields:fields];
                onSuccessBlock(snapshotPager, response);
            }
        }
        else {
            if (onFailureBlock) {
                NSError *error = [NSError errorWithDomain:ERROR_VINLI_DOMAIN code:2002 userInfo:@{@"NSLocalizedDescriptionKey": @"Received unexpected response from API call"}];
                onFailureBlock(error, response, result.description);
            }
        }
    } onFailure:^(NSError *error, NSHTTPURLResponse *response, NSString *bodyString) {
        if (onFailureBlock) {
            onFailureBlock(error, response, bodyString);
        }
    }];
}



- (void) getTelemetryMessageWithId:(NSString *) messageId
                         onSuccess:(void (^)(VLTelemetryMessage *telemetryMessage, NSHTTPURLResponse *response))onSuccessBlock
                         onFailure:(void (^)(NSError *error, NSHTTPURLResponse *response, NSString *bodyString))onFailureBlock{
    
    if(_session == nil){
        if(onFailureBlock){
            onFailureBlock([self getNoSessionError], nil, nil);
        }
        return;
    }
    
    NSString *path = [NSString stringWithFormat:@"/messages/%@", messageId];
    
    [self startWithHost:STRING_HOST_TELEMETRY path:path queries:nil HTTPMethod:@"GET" parameters:nil token:_session.accessToken onSuccess:^(NSDictionary *result, NSHTTPURLResponse *response) {
        
        if ([response isSuccessfulResponse]) {
            if (onSuccessBlock) {
                VLTelemetryMessage *telemetryMessage = [[VLTelemetryMessage alloc] initWithDictionary:result];
                onSuccessBlock(telemetryMessage, response);
            }
        }
        else {
            if (onFailureBlock) {
                NSError *error = [NSError errorWithDomain:ERROR_VINLI_DOMAIN code:2002 userInfo:@{@"NSLocalizedDescriptionKey": @"Received unexpected response from API call"}];
                onFailureBlock(error, response, result.description);
            }
        }
    } onFailure:^(NSError *error, NSHTTPURLResponse *response, NSString *bodyString) {
        if (onFailureBlock) {
            onFailureBlock(error, response, bodyString);
        }
    }];
}

- (void) getTelemetryMessagesForDeviceWithId:(NSString *) deviceId
                         onSuccess:(void (^)(VLTelemetryMessagePager *telemetryPager, NSHTTPURLResponse *response))onSuccessBlock
                         onFailure:(void (^)(NSError *error, NSHTTPURLResponse *response, NSString *bodyString))onFailureBlock{
    
    [self getTelemetryMessagesForDeviceWithId:deviceId limit:nil until:nil since:nil sortDirection:nil onSuccess:onSuccessBlock onFailure:onFailureBlock];
}


- (void)getTelemetryMessagesForDeviceWithId:(NSString *)deviceId timeSeries:(VLTimeSeries *)timeSeries onSuccess:(void (^)(VLTelemetryMessagePager *, NSHTTPURLResponse *))onSuccessBlock onFailure:(void (^)(NSError *, NSHTTPURLResponse *, NSString *))onFailureBlock
{
    if(_session == nil){
        if(onFailureBlock){
            onFailureBlock([self getNoSessionError], nil, nil);
        }
        return;
    }
    
    NSString *path = [NSString stringWithFormat:@"/devices/%@/messages", deviceId];
    
    [self startWithHost:STRING_HOST_TELEMETRY path:path queries:[timeSeries toDictionary] HTTPMethod:@"GET" parameters:nil token:_session.accessToken onSuccess:^(NSDictionary *result, NSHTTPURLResponse *response) {
        
        if ([response isSuccessfulResponse]) {
            if (onSuccessBlock) {
                VLTelemetryMessagePager *telemetryPager = [[VLTelemetryMessagePager alloc] initWithDictionary:result service:self];
                onSuccessBlock(telemetryPager, response);
            }
        }
        else {
            if (onFailureBlock) {
                NSError *error = [NSError errorWithDomain:ERROR_VINLI_DOMAIN code:2002 userInfo:@{@"NSLocalizedDescriptionKey": @"Received unexpected response from API call"}];
                onFailureBlock(error, response, result.description);
            }
        }
    } onFailure:^(NSError *error, NSHTTPURLResponse *response, NSString *bodyString) {
        if (onFailureBlock) {
            onFailureBlock(error, response, bodyString);
        }
    }];
    
}



- (void) getTelemetryMessagesForDeviceWithId:(NSString *) deviceId
                                       limit:(nullable NSNumber *)limit
                                       until:(nullable NSDate *)until
                                       since:(nullable NSDate *)since
                               sortDirection:(nullable NSString *)sortDirection
                                   onSuccess:(void (^)(VLTelemetryMessagePager *telemetryPager, NSHTTPURLResponse *response))onSuccessBlock
                                   onFailure:(void (^)(NSError *error, NSHTTPURLResponse *response, NSString *bodyString))onFailureBlock{
    
    
    VLTimeSeries *timeSeries = [VLTimeSeries timeSeriesFromDate:since until:until];
    timeSeries.sortOrder = ([sortDirection isEqualToString:@"asc"]) ? VLTimerSeriesSortDirectionAscending : VLTimerSeriesSortDirectionDescending;
    timeSeries.limit = limit;
    
    [self getTelemetryMessagesForDeviceWithId:deviceId timeSeries:timeSeries onSuccess:onSuccessBlock onFailure:onFailureBlock];
    

}

- (void) getLocationsForDeviceWithId:(NSString *) deviceId
                           onSuccess:(void (^)(VLLocationPager *locationPager, NSHTTPURLResponse *response))onSuccessBlock
                           onFailure:(void (^)(NSError *error, NSHTTPURLResponse *response, NSString *bodyString))onFailureBlock{
    
    [self getLocationsForDeviceWithId:deviceId limit:nil until:nil since:nil sortDirection:nil onSuccess:onSuccessBlock onFailure:onFailureBlock];
}




- (void)getLocationsForDeviceWithId:(NSString *)deviceId timeSeries:(VLTimeSeries *)timeSeries onSuccess:(void (^)(VLLocationPager *, NSHTTPURLResponse *))onSuccessBlock onFailure:(void (^)(NSError *, NSHTTPURLResponse *, NSString *))onFailureBlock
{
    if(_session == nil){
        if(onFailureBlock){
            onFailureBlock([self getNoSessionError], nil, nil);
        }
        return;
    }
    
    NSString *path = [NSString stringWithFormat:@"/devices/%@/locations", deviceId];
    
    [self startWithHost:STRING_HOST_TELEMETRY path:path queries:[timeSeries toDictionary] HTTPMethod:@"GET" parameters:nil token:_session.accessToken onSuccess:^(NSDictionary *result, NSHTTPURLResponse *response) {
        
        if ([response isSuccessfulResponse]) {
            if (onSuccessBlock) {
                VLLocationPager *locationPager = [[VLLocationPager alloc] initWithDictionary:result service:self];
                onSuccessBlock(locationPager, response);
            }
        }
        else {
            if (onFailureBlock) {
                NSError *error = [NSError errorWithDomain:ERROR_VINLI_DOMAIN code:2002 userInfo:@{@"NSLocalizedDescriptionKey": @"Received unexpected response from API call"}];
                onFailureBlock(error, response, result.description);
            }
        }
    } onFailure:^(NSError *error, NSHTTPURLResponse *response, NSString *bodyString) {
        if (onFailureBlock) {
            onFailureBlock(error, response, bodyString);
        }
    }];
}







- (void) getLocationsForDeviceWithId:(NSString *) deviceId
                               limit:(nullable NSNumber *)limit
                               until:(nullable NSDate *)until
                               since:(nullable NSDate *)since
                       sortDirection:(nullable NSString *)sortDirection
                           onSuccess:(void (^)(VLLocationPager *locationPager, NSHTTPURLResponse *response))onSuccessBlock
                           onFailure:(void (^)(NSError *error, NSHTTPURLResponse *response, NSString *bodyString))onFailureBlock{
    
    
    VLTimeSeries *timeSeries = [VLTimeSeries timeSeriesFromDate:since until:until];
    timeSeries.sortOrder = ([sortDirection isEqualToString:@"asc"]) ? VLTimerSeriesSortDirectionAscending : VLTimerSeriesSortDirectionDescending;
    timeSeries.limit = limit;
    
    [self getLocationsForDeviceWithId:deviceId timeSeries:timeSeries onSuccess:onSuccessBlock onFailure:onFailureBlock];
    
    

}

#pragma mark - Trip Services

- (void) getTripsForDeviceWithId:(NSString *) deviceId
                             onSuccess:(void (^)(VLTripPager *tripPager, NSHTTPURLResponse *response))onSuccessBlock
                             onFailure:(void (^)(NSError *error, NSHTTPURLResponse *response, NSString *bodyString))onFailureBlock{
    
    [self getTripsForDeviceWithId:deviceId timeSeries:nil onSuccess:onSuccessBlock onFailure:onFailureBlock];
}

- (void) getTripsForDeviceWithId:(NSString *) deviceId
                      timeSeries:(VLTimeSeries *)timeSeries
                       onSuccess:(void (^)(VLTripPager *tripPager, NSHTTPURLResponse *response))onSuccessBlock
                       onFailure:(void (^)(NSError *error, NSHTTPURLResponse *response, NSString *bodyString))onFailureBlock{
    
    if(_session == nil){
        if(onFailureBlock){
            onFailureBlock([self getNoSessionError], nil, nil);
        }
        return;
    }
    
    NSString *path = [NSString stringWithFormat:@"/devices/%@/trips", deviceId];
    
    
    [self startWithHost:STRING_HOST_TRIPS path:path queries:[timeSeries toDictionary] HTTPMethod:@"GET" parameters:nil token:_session.accessToken onSuccess:^(NSDictionary *result, NSHTTPURLResponse *response) {
        

        
        if ([response isSuccessfulResponse]) {
            if (onSuccessBlock) {
                VLTripPager *tripPager = [[VLTripPager alloc] initWithDictionary:result service:self];
                onSuccessBlock(tripPager, response);
            }
        }
        else {
            if (onFailureBlock) {
                NSError *error = [NSError errorWithDomain:ERROR_VINLI_DOMAIN code:2002 userInfo:@{@"NSLocalizedDescriptionKey": @"Received unexpected response from API call"}];
                onFailureBlock(error, response, result.description);
            }
        }
    } onFailure:^(NSError *error, NSHTTPURLResponse *response, NSString *bodyString) {
        if (onFailureBlock) {
            onFailureBlock(error, response, bodyString);
        }
    }];
}

- (void) getTripsForVehicleWithId:(NSString *) vehicleId
                             onSuccess:(void (^)(VLTripPager *tripPager, NSHTTPURLResponse *response))onSuccessBlock
                             onFailure:(void (^)(NSError *error, NSHTTPURLResponse *response, NSString *bodyString))onFailureBlock{
    
    [self getTripsForVehicleWithId:vehicleId timeSeries:nil onSuccess:onSuccessBlock onFailure:onFailureBlock];
}

- (void) getTripsForVehicleWithId:(NSString *) vehicleId
                       timeSeries:(VLTimeSeries *)timeSeries
                        onSuccess:(void (^)(VLTripPager *tripPager, NSHTTPURLResponse *response))onSuccessBlock
                        onFailure:(void (^)(NSError *error, NSHTTPURLResponse *response, NSString *bodyString))onFailureBlock{
    
    if(_session == nil) {
        if(onFailureBlock){
            onFailureBlock([self getNoSessionError], nil, nil);
        }
        return;
    }
    
    NSString *path = [NSString stringWithFormat:@"/vehicles/%@/trips", vehicleId];
    
    [self startWithHost:STRING_HOST_TRIPS path:path queries:[timeSeries toDictionary] HTTPMethod:@"GET" parameters:nil token:_session.accessToken onSuccess:^(NSDictionary *result, NSHTTPURLResponse *response) {
        
        if ([response isSuccessfulResponse]) {
            if (onSuccessBlock) {
                VLTripPager *tripPager = [[VLTripPager alloc] initWithDictionary:result service:self];
                onSuccessBlock(tripPager, response);
            }
        }
        else {
            if (onFailureBlock) {
                NSError *error = [NSError errorWithDomain:ERROR_VINLI_DOMAIN code:2002 userInfo:@{@"NSLocalizedDescriptionKey": @"Received unexpected response from API call"}];
                onFailureBlock(error, response, result.description);
            }
        }
    } onFailure:^(NSError *error, NSHTTPURLResponse *response, NSString *bodyString) {
        if (onFailureBlock) {
            onFailureBlock(error, response, bodyString);
        }
    }];
}

- (void) getTripWithId:(NSString *) vehicleId
                        onSuccess:(void (^)(VLTrip *trip, NSHTTPURLResponse *response))onSuccessBlock
                        onFailure:(void (^)(NSError *error, NSHTTPURLResponse *response, NSString *bodyString))onFailureBlock{
    
    if(_session == nil){
        if(onFailureBlock){
            onFailureBlock([self getNoSessionError], nil, nil);
        }
        return;
    }
    
    NSString *path = [NSString stringWithFormat:@"/trips/%@", vehicleId];
    
    [self startWithHost:STRING_HOST_TRIPS path:path queries:nil HTTPMethod:@"GET" parameters:nil token:_session.accessToken onSuccess:^(NSDictionary *result, NSHTTPURLResponse *response) {
        
        if ([response isSuccessfulResponse]) {
            if (onSuccessBlock) {
                VLTrip *trip = [[VLTrip alloc] initWithDictionary:result];
                onSuccessBlock(trip, response);
            }
        }
        else {
            if (onFailureBlock) {
                NSError *error = [NSError errorWithDomain:ERROR_VINLI_DOMAIN code:2002 userInfo:@{@"NSLocalizedDescriptionKey": @"Received unexpected response from API call"}];
                onFailureBlock(error, response, result.description);
            }
        }
    } onFailure:^(NSError *error, NSHTTPURLResponse *response, NSString *bodyString) {
        if (onFailureBlock) {
            onFailureBlock(error, response, bodyString);
        }
    }];
}

#pragma mark - Event Services

- (void) createSubscription:(VLSubscription *) subscription
          forDevice: (NSString *) deviceId
          onSuccess:(void (^)(VLSubscription *subscription, NSHTTPURLResponse *response))onSuccessBlock
          onFailure:(void (^)(NSError *error, NSHTTPURLResponse *response, NSString *bodyString))onFailureBlock{
    
    if(_session == nil){
        if(onFailureBlock){
            onFailureBlock([self getNoSessionError], nil, nil);
        }
        return;
    }
    NSString *path = [NSString stringWithFormat:@"/devices/%@/subscriptions", deviceId];
    NSDictionary *parameters = [subscription toDictionary];
    
    [self startWithHost:STRING_HOST_EVENTS path:path queries:nil HTTPMethod:@"POST" parameters:parameters token:_session.accessToken onSuccess:^(NSDictionary *result, NSHTTPURLResponse *response) {
        
        if ([response isSuccessfulResponse]) {
            if (onSuccessBlock) {
                VLSubscription *subscription = [[VLSubscription alloc] initWithDictionary:result];
                onSuccessBlock(subscription, response);
            }
        }
        else {
            if (onFailureBlock) {
                NSError *error = [NSError errorWithDomain:ERROR_VINLI_DOMAIN code:2002 userInfo:@{@"NSLocalizedDescriptionKey": @"Received unexpected response from API call"}];
                onFailureBlock(error, response, result.description);
            }
        }
    } onFailure:^(NSError *error, NSHTTPURLResponse *response, NSString *bodyString) {
        if (onFailureBlock) {
            onFailureBlock(error, response, bodyString);
        }
    }];
}

- (void) editSubscription:(nonnull VLSubscription *) subscription
                onSuccess:(void (^)(VLSubscription *subscription, NSHTTPURLResponse *response))onSuccessBlock
                onFailure:(void (^)(NSError *error, NSHTTPURLResponse *response, NSString *bodyString))onFailureBlock{
    
    if(_session == nil){
        if(onFailureBlock){
            onFailureBlock([self getNoSessionError], nil, nil);
        }
    }
    
    if(subscription.subscriptionId == nil || subscription.deviceId == nil){
        if(onFailureBlock){
            onFailureBlock(nil, nil, nil); // TODO Fix this
        }
    }
    
    NSString* path = [NSString stringWithFormat:@"/subscriptions/%@", subscription.subscriptionId];
    NSDictionary *parameters = [subscription toSubscriptionEditDictionary];
    
    [self startWithHost:STRING_HOST_EVENTS path:path queries:nil HTTPMethod:@"PUT" parameters:parameters token:_session.accessToken onSuccess:^(NSDictionary * result, NSHTTPURLResponse *response) {
        if([response isSuccessfulResponse]){
            if(onSuccessBlock){
                VLSubscription *subscription = [[VLSubscription alloc] initWithDictionary:result];
                onSuccessBlock(subscription, response);
            }
        }else{
            NSError *error = [NSError errorWithDomain:ERROR_VINLI_DOMAIN code:2002 userInfo:@{@"NSLocalizedDescriptionKey": @"Received unexpected response from API call"}];
            onFailureBlock(error, response, result.description);
        }
    } onFailure:^(NSError *error, NSHTTPURLResponse *response, NSString *bodyString) {
        if(onFailureBlock){
            onFailureBlock(error, response, bodyString);
        }
    }];
}

- (void) getSubscriptionWithId:(NSString *) subscriptionId
                    onSuccess:(void (^)(VLSubscription *subscription, NSHTTPURLResponse *response))onSuccessBlock
                    onFailure:(void (^)(NSError *error, NSHTTPURLResponse *response, NSString *bodyString))onFailureBlock{
    
    if(_session == nil){
        if(onFailureBlock){
            onFailureBlock([self getNoSessionError], nil, nil);
        }
        return;
    }
    
    NSString *path = [NSString stringWithFormat:@"/subscriptions/%@", subscriptionId];
    
    [self startWithHost:STRING_HOST_EVENTS path:path queries:nil HTTPMethod:@"GET" parameters:nil token:_session.accessToken onSuccess:^(NSDictionary *result, NSHTTPURLResponse *response) {
        
        if ([response isSuccessfulResponse]) {
            if (onSuccessBlock) {
                VLSubscription *subcription = [[VLSubscription alloc] initWithDictionary:result];
                onSuccessBlock(subcription, response);
            }
        }
        else {
            if (onFailureBlock) {
                NSError *error = [NSError errorWithDomain:ERROR_VINLI_DOMAIN code:2002 userInfo:@{@"NSLocalizedDescriptionKey": @"Received unexpected response from API call"}];
                onFailureBlock(error, response, result.description);
            }
        }
    } onFailure:^(NSError *error, NSHTTPURLResponse *response, NSString *bodyString) {
        if (onFailureBlock) {
            onFailureBlock(error, response, bodyString);
        }
    }];
    
    
}

- (void) getSubscriptionsForDeviceWithId:(NSString *) deviceId
                             onSuccess:(void (^)(VLSubscriptionPager *subscriptionPager, NSHTTPURLResponse *response))onSuccessBlock
                             onFailure:(void (^)(NSError *error, NSHTTPURLResponse *response, NSString *bodyString))onFailureBlock{
    
    [self getSubscriptionsForDeviceWithId:deviceId limit:nil offset:nil onSuccess:onSuccessBlock onFailure:onFailureBlock];
}

- (void) getSubscriptionsForDeviceWithId:(NSString *) deviceId
                                   limit:(nullable NSNumber *)limit
                                  offset:(nullable NSNumber *)offset
                               onSuccess:(void (^)(VLSubscriptionPager *subscriptionPager, NSHTTPURLResponse *response))onSuccessBlock
                               onFailure:(void (^)(NSError *error, NSHTTPURLResponse *response, NSString *bodyString))onFailureBlock{
    
    if(_session == nil){
        if(onFailureBlock){
            onFailureBlock([self getNoSessionError], nil, nil);
        }
        return;
    }
    
    NSString *path = [NSString stringWithFormat:@"/devices/%@/subscriptions", deviceId];
    
    [self startWithHost:STRING_HOST_EVENTS path:path queries:[self getDictionaryWithLimit:limit offset:offset] HTTPMethod:@"GET" parameters:nil token:_session.accessToken onSuccess:^(NSDictionary *result, NSHTTPURLResponse *response) {
        
        if ([response isSuccessfulResponse]) {
            if (onSuccessBlock) {
                VLSubscriptionPager *subscriptionPager = [[VLSubscriptionPager alloc] initWithDictionary:result service:self];
                onSuccessBlock(subscriptionPager, response);
            }
        }
        else {
            if (onFailureBlock) {
                NSError *error = [NSError errorWithDomain:ERROR_VINLI_DOMAIN code:2002 userInfo:@{@"NSLocalizedDescriptionKey": @"Received unexpected response from API call"}];
                onFailureBlock(error, response, result.description);
            }
        }
    } onFailure:^(NSError *error, NSHTTPURLResponse *response, NSString *bodyString) {
        if (onFailureBlock) {
            onFailureBlock(error, response, bodyString);
        }
    }];
}

- (void) deleteSubscriptionWithId:(NSString *) subscriptionId
                        onSuccess:(void (^)(NSHTTPURLResponse *response))onSuccessBlock
                        onFailure:(void (^)(NSError *error, NSHTTPURLResponse *response, NSString *bodyString))onFailureBlock{
    
    if(_session == nil){
        if(onFailureBlock){
            onFailureBlock([self getNoSessionError], nil, nil);
        }
        return;
    }
    
    NSString *path = [NSString stringWithFormat:@"/subscriptions/%@", subscriptionId];
    
    [self startWithHost:STRING_HOST_EVENTS path:path queries:nil HTTPMethod:@"DELETE" parameters:nil token:_session.accessToken onSuccess:^(NSDictionary *result, NSHTTPURLResponse *response) {
        
        if ([response isSuccessfulResponse]) {
            if (onSuccessBlock) {
                onSuccessBlock(response);
            }
        }
        else {
            if (onFailureBlock) {
                NSError *error = [NSError errorWithDomain:ERROR_VINLI_DOMAIN code:2002 userInfo:@{@"NSLocalizedDescriptionKey": @"Received unexpected response from API call"}];
                onFailureBlock(error, response, result.description);
            }
        }
    } onFailure:^(NSError *error, NSHTTPURLResponse *response, NSString *bodyString) {
        if (onFailureBlock) {
            onFailureBlock(error, response, bodyString);
        }
    }];
}

- (void) getEventWithId:(NSString *) eventId
                      onSuccess:(void (^)(VLEvent *event, NSHTTPURLResponse *response))onSuccessBlock
                      onFailure:(void (^)(NSError *error, NSHTTPURLResponse *response, NSString *bodyString))onFailureBlock{
    
    if(_session == nil){
        if(onFailureBlock){
            onFailureBlock([self getNoSessionError], nil, nil);
        }
        return;
    }
    
    NSString *path = [NSString stringWithFormat:@"/events/%@", eventId];
    
    [self startWithHost:STRING_HOST_EVENTS path:path queries:nil HTTPMethod:@"GET" parameters:nil token:_session.accessToken onSuccess:^(NSDictionary *result, NSHTTPURLResponse *response) {
        
        if ([response isSuccessfulResponse]) {
            if (onSuccessBlock) {
                VLEvent *event = [[VLEvent alloc] initWithDictionary:result];
                onSuccessBlock(event, response);
            }
        }
        else {
            if (onFailureBlock) {
                NSError *error = [NSError errorWithDomain:ERROR_VINLI_DOMAIN code:2002 userInfo:@{@"NSLocalizedDescriptionKey": @"Received unexpected response from API call"}];
                onFailureBlock(error, response, result.description);
            }
        }
    } onFailure:^(NSError *error, NSHTTPURLResponse *response, NSString *bodyString) {
        if (onFailureBlock) {
            onFailureBlock(error, response, bodyString);
        }
    }];
}

- (void) getEventsForDeviceWithId:(NSString *) deviceId
                           onSuccess:(void (^)(VLEventPager *eventPager, NSHTTPURLResponse *response))onSuccessBlock
                           onFailure:(void (^)(NSError *error, NSHTTPURLResponse *response, NSString *bodyString))onFailureBlock{
    
    [self getEventsForDeviceWithId:deviceId limit:nil until:nil since:nil sortDirection:nil onSuccess:onSuccessBlock onFailure:onFailureBlock];
}

- (void) getEventsForDeviceWithId:(NSString *) deviceId
                            limit:(nullable NSNumber *)limit
                            until:(nullable NSDate *)until
                            since:(nullable NSDate *)since
                    sortDirection:(nullable NSString *)sortDirection
                        onSuccess:(void (^)(VLEventPager *eventPager, NSHTTPURLResponse *response))onSuccessBlock
                        onFailure:(void (^)(NSError *error, NSHTTPURLResponse *response, NSString *bodyString))onFailureBlock{
    
    if(_session == nil){
        if(onFailureBlock){
            onFailureBlock([self getNoSessionError], nil, nil);
        }
        return;
    }
    
    NSString *path = [NSString stringWithFormat:@"/devices/%@/events", deviceId];
    
    [self startWithHost:STRING_HOST_EVENTS path:path queries:[self getDictionaryWithLimit:limit until:until since:since sortDirection:sortDirection] HTTPMethod:@"GET" parameters:nil token:_session.accessToken onSuccess:^(NSDictionary *result, NSHTTPURLResponse *response) {
        
        if ([response isSuccessfulResponse]) {
            if (onSuccessBlock) {
                VLEventPager *eventPager = [[VLEventPager alloc] initWithDictionary:result service:self];
                onSuccessBlock(eventPager, response);
            }
        }
        else {
            if (onFailureBlock) {
                NSError *error = [NSError errorWithDomain:ERROR_VINLI_DOMAIN code:2002 userInfo:@{@"NSLocalizedDescriptionKey": @"Received unexpected response from API call"}];
                onFailureBlock(error, response, result.description);
            }
        }
    } onFailure:^(NSError *error, NSHTTPURLResponse *response, NSString *bodyString) {
        if (onFailureBlock) {
            onFailureBlock(error, response, bodyString);
        }
    }];
}

- (void) getNotificationsForEventWithId:(NSString *) eventId
                                 onSuccess:(void (^)(VLNotificationPager *notificationPager, NSHTTPURLResponse *response))onSuccessBlock
                                 onFailure:(void (^)(NSError *error, NSHTTPURLResponse *response, NSString *bodyString))onFailureBlock{
    
    [self getNotificationsForEventWithId:eventId timeSeries:nil onSuccess:onSuccessBlock onFailure:onFailureBlock];
}

- (void) getNotificationsForEventWithId:(NSString *) eventId
                             timeSeries:(VLTimeSeries *)timeSeries
                              onSuccess:(void (^)(VLNotificationPager *notificationPager, NSHTTPURLResponse *response))onSuccessBlock
                              onFailure:(void (^)(NSError *error, NSHTTPURLResponse *response, NSString *bodyString))onFailureBlock{
 
    if(_session == nil){
        if(onFailureBlock){
            onFailureBlock([self getNoSessionError], nil, nil);
        }
        return;
    }
    
    NSString *path = [NSString stringWithFormat:@"/events/%@/notifications", eventId];
    
    [self startWithHost:STRING_HOST_EVENTS path:path queries:[timeSeries toDictionary] HTTPMethod:@"GET" parameters:nil token:_session.accessToken onSuccess:^(NSDictionary *result, NSHTTPURLResponse *response) {
        
        if ([response isSuccessfulResponse]) {
            if (onSuccessBlock) {
                VLNotificationPager *notificationPager = [[VLNotificationPager alloc] initWithDictionary:result service:self];
                onSuccessBlock(notificationPager, response);
            }
        }
        else {
            if (onFailureBlock) {
                NSError *error = [NSError errorWithDomain:ERROR_VINLI_DOMAIN code:2002 userInfo:@{@"NSLocalizedDescriptionKey": @"Received unexpected response from API call"}];
                onFailureBlock(error, response, result.description);
            }
        }
    } onFailure:^(NSError *error, NSHTTPURLResponse *response, NSString *bodyString) {
        if (onFailureBlock) {
            onFailureBlock(error, response, bodyString);
        }
    }];
}

- (void) getNotificationsForSubscriptionWithId:(NSString *) subscriptionId
                                        onSuccess:(void (^)(VLNotificationPager *notificationPager, NSHTTPURLResponse *response))onSuccessBlock
                                        onFailure:(void (^)(NSError *error, NSHTTPURLResponse *response, NSString *bodyString))onFailureBlock{
    
    [self getNotificationsForSubscriptionWithId:subscriptionId timeSeries:nil onSuccess:onSuccessBlock onFailure:onFailureBlock];
}

- (void) getNotificationsForSubscriptionWithId:(NSString *) subscriptionId
                                    timeSeries:(VLTimeSeries *)timeSeries
                                     onSuccess:(void (^)(VLNotificationPager *notificationPager, NSHTTPURLResponse *response))onSuccessBlock
                                     onFailure:(void (^)(NSError *error, NSHTTPURLResponse *response, NSString *bodyString))onFailureBlock{
    
    if(_session == nil){
        if(onFailureBlock){
            onFailureBlock([self getNoSessionError], nil, nil);
        }
        return;
    }
    
    NSString *path = [NSString stringWithFormat:@"/subscriptions/%@/notifications", subscriptionId];
    
    [self startWithHost:STRING_HOST_EVENTS path:path queries:[timeSeries toDictionary] HTTPMethod:@"GET" parameters:nil token:_session.accessToken onSuccess:^(NSDictionary *result, NSHTTPURLResponse *response) {
        
        if ([response isSuccessfulResponse]) {
            if (onSuccessBlock) {
                VLNotificationPager *notificationPager = [[VLNotificationPager alloc] initWithDictionary:result service:self];
                onSuccessBlock(notificationPager, response);
            }
        }
        else {
            if (onFailureBlock) {
                NSError *error = [NSError errorWithDomain:ERROR_VINLI_DOMAIN code:2002 userInfo:@{@"NSLocalizedDescriptionKey": @"Received unexpected response from API call"}];
                onFailureBlock(error, response, result.description);
            }
        }
    } onFailure:^(NSError *error, NSHTTPURLResponse *response, NSString *bodyString) {
        if (onFailureBlock) {
            onFailureBlock(error, response, bodyString);
        }
    }];
}

- (void) getNotificationWithId:(NSString *) notificationId
                             onSuccess:(void (^)(VLNotification *notification, NSHTTPURLResponse *response))onSuccessBlock
                             onFailure:(void (^)(NSError *error, NSHTTPURLResponse *response, NSString *bodyString))onFailureBlock{
    
    if(_session == nil){
        if(onFailureBlock){
            onFailureBlock([self getNoSessionError], nil, nil);
        }
        return;
    }
    
    NSString *path = [NSString stringWithFormat:@"/notifications/%@", notificationId];
    
    [self startWithHost:STRING_HOST_EVENTS path:path queries:nil HTTPMethod:@"GET" parameters:nil token:_session.accessToken onSuccess:^(NSDictionary *result, NSHTTPURLResponse *response) {
        
        if ([response isSuccessfulResponse]) {
            if (onSuccessBlock) {
                VLNotification *notification = [[VLNotification alloc] initWithDictionary:result];
                onSuccessBlock(notification, response);
            }
        }
        else {
            if (onFailureBlock) {
                NSError *error = [NSError errorWithDomain:ERROR_VINLI_DOMAIN code:2002 userInfo:@{@"NSLocalizedDescriptionKey": @"Received unexpected response from API call"}];
                onFailureBlock(error, response, result.description);
            }
        }
    } onFailure:^(NSError *error, NSHTTPURLResponse *response, NSString *bodyString) {
        if (onFailureBlock) {
            onFailureBlock(error, response, bodyString);
        }
    }];
}

#pragma mark - Stream Services

- (VLStream *) getStreamForDeviceId:(NSString *)deviceId{
    return [self getStreamForDeviceId:deviceId parametricFilters:nil geometryFilter:nil onMessageBlock:nil onErrorBlock:nil];
}

- (VLStream *) getStreamForDeviceId:(NSString *)deviceId onMessageBlock:(void (^)(VLStreamMessage *)) onMessageBlock onErrorBlock:(void (^)(NSError *)) onErrorBlock{
    return [self getStreamForDeviceId:deviceId parametricFilters:nil geometryFilter:nil onMessageBlock:onMessageBlock onErrorBlock:onErrorBlock];
}

- (VLStream *) getStreamForDeviceId:(NSString *)deviceId parametricFilters:(NSArray *)parametricFilters geometryFilter:(VLGeometryFilter *)geometryFilter onMessageBlock:(void (^)(VLStreamMessage *))onMessageBlock onErrorBlock:(void (^)(NSError *))onErrorBlock{
    NSString *urlString = [NSString stringWithFormat:@"wss://%@%@/api/v1/messages?token=%@", STRING_HOST_STREAM, _host, _session.accessToken];
    
    VLStream *stream = [[VLStream alloc] initWithURL:[NSURL URLWithString:urlString] deviceId:deviceId parametricFilters:parametricFilters geometryFilter:geometryFilter];
    stream.onMessageBlock = onMessageBlock;
    stream.onErrorBlock = onErrorBlock;
    
    return stream;
}

#pragma mark - Auth Services

- (void) getUserOnSuccess:(void (^)(VLUser *user, NSHTTPURLResponse *response))onSuccessBlock
       onFailure:(void (^)(NSError *error, NSHTTPURLResponse *response, NSString *bodyString))onFailureBlock{
    
    if(_session == nil){
        if(onFailureBlock){
            onFailureBlock([self getNoSessionError], nil, nil);
        }
        return;
    }
    
    NSString *path = [NSString stringWithFormat:@"/users/_current"];
    
    [self startWithHost:STRING_HOST_AUTH path:path queries:nil HTTPMethod:@"GET" parameters:nil token:_session.accessToken onSuccess:^(NSDictionary *result, NSHTTPURLResponse *response) {
        
        if ([response isSuccessfulResponse]) {
            if (onSuccessBlock) {
                VLUser *user = [[VLUser alloc] initWithDictionary:result];
                onSuccessBlock(user, response);
            }
        }
        else {
            if (onFailureBlock) {
                NSError *error = [NSError errorWithDomain:ERROR_VINLI_DOMAIN code:2002 userInfo:@{@"NSLocalizedDescriptionKey": @"Received unexpected response from API call"}];
                onFailureBlock(error, response, result.description);
            }
        }
    } onFailure:^(NSError *error, NSHTTPURLResponse *response, NSString *bodyString) {
        if (onFailureBlock) {
            onFailureBlock(error, response, bodyString);
        }
    }];
    
}




#pragma mark - Distance Services 



- (void)getDistancesForVehicleWithId:(NSString *)vehicleId onSuccess:(void (^)(VLDistancePager *distancePager, NSHTTPURLResponse *response))onSuccessBlock
                           onFailure:(void (^)(NSError *error, NSHTTPURLResponse *response, NSString *bodyString))onFailureBlock {
    
    
    [self getDistancesForVehicleWithId:vehicleId timeSeries:nil onSuccess:onSuccessBlock onFailure:onFailureBlock];
    
}


- (void)getDistancesForVehicleWithId:(NSString *)vehicleId timeSeries:(VLTimeSeries *)timeSeries onSuccess:(void (^)(VLDistancePager *distancePager, NSHTTPURLResponse *response))onSuccessBlock
                           onFailure:(void (^)(NSError *error, NSHTTPURLResponse *response, NSString *bodyString))onFailureBlock {
    if (_session == nil) {
        if (onFailureBlock) {
            onFailureBlock([self getNoSessionError], nil, nil);
        }
        return;
    }
    
    NSString *path = [NSString stringWithFormat:@"/vehicles/%@/distances", vehicleId];
    
    
    [self startWithHost:STRING_HOST_DISTANCE path:path queries:[timeSeries toDictionary] HTTPMethod:@"GET" parameters:nil token:_session.accessToken onSuccess:^(NSDictionary *result, NSHTTPURLResponse *response) {
        
        if ([response isSuccessfulResponse]) {
            if (onSuccessBlock) {
                VLDistancePager *distancePager = [[VLDistancePager alloc]initWithDictionary:result];
                onSuccessBlock(distancePager, response);
            }
        }
        else {
            if (onFailureBlock) {
                NSError *error = [NSError errorWithDomain:ERROR_VINLI_DOMAIN code:2002 userInfo:@{@"NSLocalizedDescriptionKey": @"Received unexpected response from API call"}];
                onFailureBlock(error, response, result.description);
            }
        }
        
        
    } onFailure:^(NSError *error, NSHTTPURLResponse *response, NSString *bodyString) {
        if (onFailureBlock) {
            onFailureBlock(error, response, bodyString);
        }
    }];
    
    
}




//Odometers

- (void)createOdometer:(VLOdometer *)odometer vehicleId:(NSString *)vehicleId OnSuccess:(void (^)(VLOdometer *odometer, NSHTTPURLResponse *response))onSuccessBlock onFailure:(void (^)(NSError *error, NSHTTPURLResponse *response, NSString *bodyString))onFailureBlock {
    
    if(_session == nil){
        if(onFailureBlock){
            onFailureBlock([self getNoSessionError], nil, nil);
        }
        return;
    }
    
    NSString *path = [NSString stringWithFormat:@"/vehicles/%@/odometers", vehicleId];
    
    [self startWithHost:STRING_HOST_DISTANCE path:path queries:nil HTTPMethod:@"POST" parameters:[odometer toDictionary] token:_session.accessToken onSuccess:^(NSDictionary *result, NSHTTPURLResponse *response) {
        
        if ([response isSuccessfulResponse]) {
            if (onSuccessBlock) {
                VLOdometer *odometer = [[VLOdometer alloc] initWithDictionary:result];
                onSuccessBlock(odometer, response);
            }
        }
        else if (response.statusCode == 409)
        {
            if (onFailureBlock)
            {
                NSError *error;
                NSString *messageFromResult = result[@"message"];
                if ([messageFromResult containsString:VLErrorMessageExistingOdometerWithSameValues])
                {
                    error = [NSError errorWithDomain:VLErrorDomainExistingOdometerWithSameValues code:VLErrorCodeExistingOdometerWithSameValues userInfo:@{NSLocalizedDescriptionKey: messageFromResult}];
                }
                else if ([messageFromResult isEqualToString:VLErrorMessageExistingOdometerWithOlderDateThanPrevious])
                {
                    error = [NSError errorWithDomain:VLErrorDomainExistingOdometerWithOlderDateThanPrevious code:VLErrorCodeExistingOdometerWithOlderDateThanPrevious userInfo:@{NSLocalizedDescriptionKey: VLErrorMessageExistingOdometerWithOlderDateThanPrevious}];
                }
                else if ([messageFromResult isEqualToString:VLErrorMessageExistingOdometerWithSmallerReadingThanPrevious])
                {
                    error = [NSError errorWithDomain:VLErrorDomainExistingOdometerWithSmallerReadingThanPrevious code:VLErrorCodeExistingOdometerWithSmallerReadingThanPrevious userInfo:@{NSLocalizedDescriptionKey: VLErrorMessageExistingOdometerWithSmallerReadingThanPrevious}];
                }
                else
                {
                    error = [NSError errorWithDomain:ERROR_VINLI_DOMAIN code:4009 userInfo:@{NSLocalizedDescriptionKey: [NSString stringWithFormat:@"%@: %@", result[@"error"], result[@"message"]]}];
                }
                onFailureBlock(error, response, result.description);
            }
        }
        else {
            if (onFailureBlock) {
                NSError *error = [NSError errorWithDomain:ERROR_VINLI_DOMAIN code:2002 userInfo:@{@"NSLocalizedDescriptionKey": @"Received unexpected response from API call"}];
                onFailureBlock(error, response, result.description);
            }
        }
    } onFailure:^(NSError *error, NSHTTPURLResponse *response, NSString *bodyString) {
        if (onFailureBlock) {
            onFailureBlock(error, response, bodyString);
        }
    }];
}





- (void)getOdometersForVehicleWithId:(NSString *)vehicleId onSuccess:(void (^)(VLOdometerPager *odometerPager, NSHTTPURLResponse *response))onSuccessBlock onFailure:(void (^)(NSError *error, NSHTTPURLResponse *response, NSString *bodyString))onFailureBlock {
    [self getOdometersForVehicleWithId:vehicleId timeSeries:nil onSucess:onSuccessBlock onFailure:onFailureBlock];
}


- (void) getOdometersForVehicleWithId:(NSString *)vehicleId timeSeries:(VLTimeSeries *)timeSeries onSucess:(void (^)(VLOdometerPager *odometerPager, NSHTTPURLResponse *OdometerPager))onSuccessBlock onFailure:(void (^)(NSError *error, NSHTTPURLResponse *response, NSString *bodyString))onFailureBlock {
    if(_session == nil){
        if(onFailureBlock){
            onFailureBlock([self getNoSessionError], nil, nil);
        }
        return;
    }
    
    NSString *path = [NSString stringWithFormat:@"/vehicles/%@/odometers", vehicleId];
    
    
    [self startWithHost:STRING_HOST_DISTANCE path:path queries:[timeSeries toDictionary] HTTPMethod:@"GET" parameters:nil token:_session.accessToken onSuccess:^(NSDictionary *result, NSHTTPURLResponse *response) {
        
        if ([response isSuccessfulResponse]) {
            if (onSuccessBlock) {
                VLOdometerPager *odometerPager = [[VLOdometerPager alloc] initWithDictionary:result];
                onSuccessBlock(odometerPager, response);
            }
        }
        else {
            if (onFailureBlock) {
                NSError *error = [NSError errorWithDomain:ERROR_VINLI_DOMAIN code:2002 userInfo:@{@"NSLocalizedDescriptionKey": @"Received unexpected response from API call"}];
                onFailureBlock(error, response, result.description);
            }
        }
    } onFailure:^(NSError *error, NSHTTPURLResponse *response, NSString *bodyString) {
        if (onFailureBlock) {
            onFailureBlock(error, response, bodyString);
        }
    }];
}







- (void)getOdometerWithId:(NSString *)odometerId onSuccess:(void (^)(VLOdometer *odometer, NSHTTPURLResponse *response))onSuccessBlock onFailure:(void (^)(NSError *error, NSHTTPURLResponse *reponse, NSString *bodyString))onFailureBlock {
    if(_session == nil){
        if(onFailureBlock){
            onFailureBlock([self getNoSessionError], nil, nil);
        }
        return;
    }
    
    NSString *path = [NSString stringWithFormat:@"/odometers/%@", odometerId];
    
    [self startWithHost:STRING_HOST_DISTANCE path:path queries:nil HTTPMethod:@"GET" parameters:nil token:_session.accessToken onSuccess:^(NSDictionary *result, NSHTTPURLResponse *response) {
        
        if ([response isSuccessfulResponse]) {
            if (onSuccessBlock) {
                VLOdometer *odometer = [[VLOdometer alloc] initWithDictionary:result];
                onSuccessBlock(odometer, response);
            }
        }
        else {
            if (onFailureBlock) {
                NSError *error = [NSError errorWithDomain:ERROR_VINLI_DOMAIN code:2002 userInfo:@{@"NSLocalizedDescriptionKey": @"Received unexpected response from API call"}];
                onFailureBlock(error, response, result.description);
            }
        }
    } onFailure:^(NSError *error, NSHTTPURLResponse *response, NSString *bodyString) {
        if (onFailureBlock) {
            onFailureBlock(error, response, bodyString);
        }
    }];
    
}





- (void)deleteOdometerWithId:(NSString *)odometerId onSuccess:(void (^)(NSHTTPURLResponse *response))onSuccessBlock onFailure:(void (^)(NSError *error, NSHTTPURLResponse *response, NSString *bodyString))onFailureBlock {
    if(_session == nil){
        if(onFailureBlock){
            onFailureBlock([self getNoSessionError], nil, nil);
        }
        return;
    }
    
    NSString *path = [NSString stringWithFormat:@"/odometers/%@", odometerId];
    
    [self startWithHost:STRING_HOST_DISTANCE path:path queries:nil HTTPMethod:@"DELETE" parameters:nil token:_session.accessToken onSuccess:^(NSDictionary *result, NSHTTPURLResponse *response) {
        
        if ([response isSuccessfulResponse]) {
            if (onSuccessBlock) {
                onSuccessBlock(response);
            }
        }
        else {
            if (onFailureBlock) {
                NSError *error = [NSError errorWithDomain:ERROR_VINLI_DOMAIN code:2002 userInfo:@{@"NSLocalizedDescriptionKey": @"Received unexpected response from API call"}];
                onFailureBlock(error, response, result.description);
            }
        }
    } onFailure:^(NSError *error, NSHTTPURLResponse *response, NSString *bodyString) {
        if (onFailureBlock) {
            onFailureBlock(error, response, bodyString);
        }
    }];
    
}







//Odometer Trigger Methods

- (void)createOdometerTrigger:(VLOdometerTrigger *)odometerTrigger vehicleId:(NSString *)vehicleId OnSuccess:(void (^)(VLOdometerTrigger *odometerTrigger, NSHTTPURLResponse *response))onSuccessBlock onFailure:(void (^)(NSError *error, NSHTTPURLResponse *response, NSString *bodyString))onFailureBlock {
    
    if(_session == nil){
        if(onFailureBlock){
            onFailureBlock([self getNoSessionError], nil, nil);
        }
        return;
    }
    
    NSString *path = [NSString stringWithFormat:@"/vehicles/%@/odometer_triggers", vehicleId];
    
    [self startWithHost:STRING_HOST_DISTANCE path:path queries:nil HTTPMethod:@"POST" parameters:[odometerTrigger toDictionary] token:_session.accessToken onSuccess:^(NSDictionary *result, NSHTTPURLResponse *response) {
        
        if ([response isSuccessfulResponse]) {
            if (onSuccessBlock) {
                VLOdometerTrigger *odometerTrigger = [[VLOdometerTrigger alloc] initWithDictionary:result];
                onSuccessBlock(odometerTrigger, response);
            }
        }
        else {
            if (onFailureBlock) {
                NSError *error = [NSError errorWithDomain:ERROR_VINLI_DOMAIN code:2002 userInfo:@{@"NSLocalizedDescriptionKey": @"Received unexpected response from API call"}];
                onFailureBlock(error, response, result.description);
            }
        }
    } onFailure:^(NSError *error, NSHTTPURLResponse *response, NSString *bodyString) {
        if (onFailureBlock) {
            onFailureBlock(error, response, bodyString);
        }
    }];
}

- (void)getOdometerTriggersForVehicleWithId:(NSString *)vehicleId onSucess:(void (^)(VLOdometerTriggerPager *odometerTriggerPager, NSHTTPURLResponse *response))onSuccessBlock onFailure:(void (^)(NSError *error, NSHTTPURLResponse *response, NSString *bodyString))onFailureBlock {
    [self getOdometerTriggersForVehicleWithId:vehicleId timeSeries:nil onSucess:onSuccessBlock onFailure:onFailureBlock];
}


- (void)getOdometerTriggersForVehicleWithId:(NSString *)vehicleId timeSeries:(VLTimeSeries *)timeSeries onSucess:(void (^)(VLOdometerTriggerPager *odometerTriggerPager, NSHTTPURLResponse *response))onSuccessBlock onFailure:(void (^)(NSError *error, NSHTTPURLResponse *response, NSString *bodyString))onFailureBlock {
    if(_session == nil){
        if(onFailureBlock){
            onFailureBlock([self getNoSessionError], nil, nil);
        }
        return;
    }
    
    NSString *path = [NSString stringWithFormat:@"/vehicles/%@/odometer_triggers", vehicleId];
    
    
    [self startWithHost:STRING_HOST_DISTANCE path:path queries:[timeSeries toDictionary] HTTPMethod:@"GET" parameters:nil token:_session.accessToken onSuccess:^(NSDictionary *result, NSHTTPURLResponse *response) {
        
        if ([response isSuccessfulResponse]) {
            if (onSuccessBlock) {
                VLOdometerTriggerPager *odometerTriggerPager = [[VLOdometerTriggerPager alloc] initWithDictionary:result];
                onSuccessBlock(odometerTriggerPager, response);
            }
        }
        else {
            if (onFailureBlock) {
                NSError *error = [NSError errorWithDomain:ERROR_VINLI_DOMAIN code:2002 userInfo:@{@"NSLocalizedDescriptionKey": @"Received unexpected response from API call"}];
                onFailureBlock(error, response, result.description);
            }
        }
    } onFailure:^(NSError *error, NSHTTPURLResponse *response, NSString *bodyString) {
        if (onFailureBlock) {
            onFailureBlock(error, response, bodyString);
        }
    }];

}

- (void)getOdometerTriggerWithId:(NSString *)odometerTriggerId onSuccess:(void (^)(VLOdometerTrigger *, NSHTTPURLResponse *))onSuccessBlock onFailure:(void (^)(NSError *, NSHTTPURLResponse *, NSString *))onFailureBlock {
    if(_session == nil){
        if(onFailureBlock){
            onFailureBlock([self getNoSessionError], nil, nil);
        }
        return;
    }
    
    NSString *path = [NSString stringWithFormat:@"/odometer_triggers/%@", odometerTriggerId];
    
    [self startWithHost:STRING_HOST_DISTANCE path:path queries:nil HTTPMethod:@"GET" parameters:nil token:_session.accessToken onSuccess:^(NSDictionary *result, NSHTTPURLResponse *response) {
        
        if ([response isSuccessfulResponse]) {
            if (onSuccessBlock) {
                VLOdometerTrigger *odometerTrigger = [[VLOdometerTrigger alloc] initWithDictionary:result];
                onSuccessBlock(odometerTrigger, response);
            }
        }
        else {
            if (onFailureBlock) {
                NSError *error = [NSError errorWithDomain:ERROR_VINLI_DOMAIN code:2002 userInfo:@{@"NSLocalizedDescriptionKey": @"Received unexpected response from API call"}];
                onFailureBlock(error, response, result.description);
            }
        }
    } onFailure:^(NSError *error, NSHTTPURLResponse *response, NSString *bodyString) {
        if (onFailureBlock) {
            onFailureBlock(error, response, bodyString);
        }
    }];
    
}




- (void)deleteOdometerTriggerWithId:(NSString *)odometerTriggerId onSuccess:(void (^)(NSHTTPURLResponse *reponse))onSuccessBlock onFailure:(void (^)(NSError *error, NSHTTPURLResponse *response, NSString *bodyString))onFailureBlock {
    if(_session == nil){
        if(onFailureBlock){
            onFailureBlock([self getNoSessionError], nil, nil);
        }
        return;
    }
    
    NSString *path = [NSString stringWithFormat:@"/odometer_triggers/%@", odometerTriggerId];
    
    [self startWithHost:STRING_HOST_DISTANCE path:path queries:nil HTTPMethod:@"DELETE" parameters:nil token:_session.accessToken onSuccess:^(NSDictionary *result, NSHTTPURLResponse *response) {
        
        if ([response isSuccessfulResponse]) {
            if (onSuccessBlock) {
                onSuccessBlock(response);
            }
        }
        else {
            if (onFailureBlock) {
                NSError *error = [NSError errorWithDomain:ERROR_VINLI_DOMAIN code:2002 userInfo:@{@"NSLocalizedDescriptionKey": @"Received unexpected response from API call"}];
                onFailureBlock(error, response, result.description);
            }
        }
    } onFailure:^(NSError *error, NSHTTPURLResponse *response, NSString *bodyString) {
        if (onFailureBlock) {
            onFailureBlock(error, response, bodyString);
        }
    }];

    
}

#pragma mark - Diagnostic Service

- (void) getCurrentBatteryStatusWithVehicleId:(NSString *)vehicleId
                                    onSuccess:(void (^)(VLBatteryStatus *batteryStatus, NSHTTPURLResponse *response))onSuccessBlock
                                    onFailure:(void (^)(NSError *error, NSHTTPURLResponse *response, NSString *bodyString))onFailureBlock{
    if(_session == nil){
        if(onFailureBlock){
            onFailureBlock([self getNoSessionError], nil, nil);
        }
        return;
    }
    
    NSString *path = [NSString stringWithFormat:@"/vehicles/%@/battery_statuses/_current", vehicleId];
    
    [self startWithHost:STRING_HOST_DIAGNOSTIC path:path queries:nil HTTPMethod:@"GET" parameters:nil token:_session.accessToken onSuccess:^(NSDictionary *result, NSHTTPURLResponse *response) {
        
        if ([response isSuccessfulResponse]) {
            if (onSuccessBlock) {
                VLBatteryStatus *batteryStatus = [[VLBatteryStatus alloc] initWithDictionary:result];
                onSuccessBlock(batteryStatus, response);
            }
        }
        else {
            if (onFailureBlock) {
                NSError *error = [NSError errorWithDomain:ERROR_VINLI_DOMAIN code:2002 userInfo:@{@"NSLocalizedDescriptionKey": @"Received unexpected response from API call"}];
                onFailureBlock(error, response, result.description);
            }
        }
    } onFailure:^(NSError *error, NSHTTPURLResponse *response, NSString *bodyString) {
        if (onFailureBlock) {
            onFailureBlock(error, response, bodyString);
        }
    }];
}

#pragma mark - NSError

- (NSError *) getNoSessionError{
    return [NSError errorWithDomain:ERROR_NO_SESSION code:2003 userInfo:@{@"NSLocalizedDescriptionKey" : @"Valid VLSession required to use this VLService method."}];
}

#pragma mark - Handlers

- (void)setAccessTokenExpirationHandler:(void (^)(VLService* service, NSError* error))handler
{
    if (handler) {
        _AccessTokenExpirationHandler = handler;
    }
}



@end
