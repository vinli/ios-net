//
//  DummyService.m
//  Commute
//
//  Created by Jai Ghanekar on 4/28/16.
//  Copyright © 2016 Vinli. All rights reserved.
//

#import "DummyService.h"

#define NUMBER_DEFAULT_PORT        @80
#define NUMBER_HTTPS_PORT          @443
#define STRING_API_VERSION      @"/api/v1"
#define STRING_CONTENT_TYPE     @"application/json"

#define ERROR_VINLI_DOMAIN      @"VinliSDKErrorDomain"
#define ERROR_NO_SESSION        @"VinliSDKErrorNoSession"
#define STRING_HOST_DUMMY       @"dummies"
#define DEFAULT_HOST            @".vin.li"



static NSString *currentRouteId;


@implementation DummyService

+ (void)dummyOnSuccess:(void (^)(NSDictionary *dummy, NSHTTPURLResponse *response))onSuccessBlock
             onFailure:(void (^)(NSError *error, NSHTTPURLResponse *response, NSString *bodyString))onFailureBlock; {
   
    [self getAllDummyDevicesOnSuccess:^(NSDictionary *dummies, NSHTTPURLResponse *response) {
       
        NSDictionary *dummy = [dummies[@"dummies"] firstObject];
        if (dummy) {
            if (onSuccessBlock) {
                onSuccessBlock(dummy, response);
            }
        } else {
            if (onFailureBlock) {
                onFailureBlock(nil, nil, @"No dummies");
            }
            
        }
       
    } onFailure:onFailureBlock];

}
+ (NSString *)currentRouteId {
    return currentRouteId;
}
+ (NSString *)currentVin {
    return @"VVV12912912914566";
}



+ (void)createDummyWithName:(NSString *)name onSuccess:(void (^)(NSDictionary *dummy, NSHTTPURLResponse *response))onSuccessBlock
                  onFailure:(void (^)(NSError *error, NSHTTPURLResponse *response, NSString *bodyString))onFailureBlock {
    if (![VLSession currentSession]) {
        if (onFailureBlock) {
            onFailureBlock([self getNoSessionError], nil, nil);
        }
        return;
    }

    NSString *path = [NSString stringWithFormat:@"/dummies"];
    NSDictionary *nameDict = @{@"name":name};
    NSDictionary *dummyDict = @{@"dummy":nameDict};
    
    [[VLService sharedService] startWithHost:STRING_HOST_DUMMY path:path queries:nil HTTPMethod:@"POST" parameters:dummyDict token:[VLService sharedService].session.accessToken onSuccess:^(NSDictionary *result, NSHTTPURLResponse *response) {
        if (response.statusCode == 201) {
            if (onSuccessBlock) {
                onSuccessBlock(result, response);
            }
        } else {
            NSError *error = [NSError errorWithDomain:ERROR_VINLI_DOMAIN code:2002 userInfo:@{@"NSLocalizedDescriptionKey": @"Received unexpected response from API call"}];
            onFailureBlock(error, response, result.description);
        }
    } onFailure:^(NSError *error, NSHTTPURLResponse *response, NSString *bodyString) {
        if (onFailureBlock) {
            onFailureBlock(error, response, bodyString);
        }
    }];
}


+ (void)getAllDummyDevicesOnSuccess:(void (^)(NSDictionary *dummies, NSHTTPURLResponse *response))onSuccessBlock
                          onFailure:(void (^)(NSError *error, NSHTTPURLResponse *response, NSString *bodyString))onFailureBlock {
    
    if (![VLSession currentSession]) {
        if (onFailureBlock) {
            onFailureBlock([self getNoSessionError], nil, nil);
        }
        return;
    }
    
    NSString *path = [NSString stringWithFormat:@"/dummies"];
    
    [[VLService sharedService] startWithHost:STRING_HOST_DUMMY path:path queries:nil HTTPMethod:@"GET" parameters:nil token:[VLService sharedService].session.accessToken onSuccess:^(NSDictionary *result, NSHTTPURLResponse *response) {
        
        if (response.statusCode == 200) {
            if (onSuccessBlock) {
                onSuccessBlock(result, response);
            }
        } else {
            NSError *error = [NSError errorWithDomain:ERROR_VINLI_DOMAIN code:2002 userInfo:@{@"NSLocalizedDescriptionKey": @"Received unexpected response from API call"}];
            onFailureBlock(error, response, result.description);
        }
        
    } onFailure:^(NSError *error, NSHTTPURLResponse *response, NSString *bodyString) {
        if (onFailureBlock) {
            onFailureBlock(error, response, bodyString);
        }
    }];
}

+ (void)getAllDummyRoutesOnSuccess:(void (^)(NSDictionary *routes, NSHTTPURLResponse *response))onSuccessBlock
                         onFailure:(void (^)(NSError *error, NSHTTPURLResponse *response, NSString *bodyString))onFailureBlock {
    if (![VLSession currentSession]) {
        if (onFailureBlock) {
            onFailureBlock([self getNoSessionError], nil, nil);
        }
        return;
    }
    NSString *path = [NSString stringWithFormat:@"/routes"];
    [[VLService sharedService] startWithHost:STRING_HOST_DUMMY path:path queries:nil HTTPMethod:@"GET" parameters:nil token:[VLService sharedService].session.accessToken onSuccess:^(NSDictionary *result, NSHTTPURLResponse *response) {
        
        if (response.statusCode == 200) {
            if (onSuccessBlock) {
                onSuccessBlock(result, response);
            }
        } else {
            NSError *error = [NSError errorWithDomain:ERROR_VINLI_DOMAIN code:2002 userInfo:@{@"NSLocalizedDescriptionKey": @"Received unexpected response from API call"}];
            onFailureBlock(error, response, result.description);
        }
    } onFailure:^(NSError *error, NSHTTPURLResponse *response, NSString *bodyString) {
        if (onFailureBlock) {
            onFailureBlock(error, response, bodyString);
        }
    }];
    
}


+ (void)createRunForDummyWithId:(NSString *)dummyId vin:(NSString *)vinNumber routeId:(NSString *)routeId onSuccess:(void (^)(NSDictionary *run, NSHTTPURLResponse *response))onSuccessBlock
                      onFailure:(void (^)(NSError *error, NSHTTPURLResponse *response, NSString *bodyString))onFailureBlock {
    if (![VLSession currentSession]) {
        if (onFailureBlock) {
            onFailureBlock([self getNoSessionError], nil, nil);
        }
        return;
    }
    currentRouteId = routeId;
    NSString *path = [NSString stringWithFormat:@"/dummies/%@/runs", dummyId];
    NSDictionary *runBody = @{@"vin":vinNumber, @"routeId":routeId};
    NSDictionary *runDict = @{@"run":runBody};
    
    [[VLService sharedService] startWithHost:STRING_HOST_DUMMY path:path queries:nil HTTPMethod:@"POST" parameters:runDict token:[VLService sharedService].session.accessToken onSuccess:^(NSDictionary *result, NSHTTPURLResponse *response) {
        if (response.statusCode == 200) {
            if (onSuccessBlock) {
                onSuccessBlock(result, response);
            }
        } else {
            NSError *error = [NSError errorWithDomain:ERROR_VINLI_DOMAIN code:2002 userInfo:@{@"NSLocalizedDescriptionKey": @"Received unexpected response from API call"}];
            onFailureBlock(error, response, result.description);
        }
    } onFailure:^(NSError *error, NSHTTPURLResponse *response, NSString *bodyString) {
        if (onFailureBlock) {
            onFailureBlock(error, response, bodyString);
        }
    }];
    
}

+ (void)getCurrentRunForDummy:(NSString *)dummyId onSuccess:(void (^)(NSDictionary *run, NSHTTPURLResponse *response))onSuccessBlock
                    onFailure:(void (^)(NSError *error, NSHTTPURLResponse *response, NSString *bodyString))onFailureBlock {
    
    if (![VLSession currentSession]) {
        if (onFailureBlock) {
            onFailureBlock([self getNoSessionError], nil, nil);
        }
        return;
    }
    NSString *path = [NSString stringWithFormat:@"/dummies/%@/runs/_current", dummyId];
    [[VLService sharedService] startWithHost:STRING_HOST_DUMMY path:path queries:nil HTTPMethod:@"GET" parameters:nil token:[VLService sharedService].session.accessToken onSuccess:^(NSDictionary *result, NSHTTPURLResponse *response) {
        if (response.statusCode == 200) {
            if (onSuccessBlock) {
                onSuccessBlock(result, response);
            }
        } else {
            NSError *error = [NSError errorWithDomain:ERROR_VINLI_DOMAIN code:2002 userInfo:@{@"NSLocalizedDescriptionKey": @"Received unexpected response from API call"}];
            onFailureBlock(error, response, result.description);
        }
    } onFailure:^(NSError *error, NSHTTPURLResponse *response, NSString *bodyString) {
        if (onFailureBlock) {
            onFailureBlock(error, response, bodyString);
        }
    }];
    
}


+ (void)deleteRunForDummyWithId:(NSString *)dummyId vin:(NSString *)vinNumber routeId:(NSString *)routeId onSuccess:(void (^)(NSHTTPURLResponse *response))onSuccessBlock
                      onFailure:(void (^)(NSError *, NSHTTPURLResponse *, NSString *))onFailureBlock {
    
    if (![VLSession currentSession]) {
        if (onFailureBlock) {
            onFailureBlock([self getNoSessionError], nil, nil);
        }
        return;
    }
    NSString *path = [NSString stringWithFormat:@"/dummies/%@/runs/_current", dummyId];
    NSDictionary *runBody = @{@"vin":vinNumber, @"routeId":routeId};
    NSDictionary *runDict = @{@"run":runBody};
    
    [[VLService sharedService] startWithHost:STRING_HOST_DUMMY path:path queries:nil HTTPMethod:@"DELETE" parameters:runDict token:[VLService sharedService].session.accessToken onSuccess:^(NSDictionary *result, NSHTTPURLResponse *response) {
        if (response.statusCode == 204) {
            if (onSuccessBlock) {
                onSuccessBlock(response);
            }
        } else {
            NSError *error = [NSError errorWithDomain:ERROR_VINLI_DOMAIN code:2002 userInfo:@{@"NSLocalizedDescriptionKey": @"Received unexpected response from API call"}];
            onFailureBlock(error, response, result.description);
        }
    } onFailure:^(NSError *error, NSHTTPURLResponse *response, NSString *bodyString) {
        if (onFailureBlock) {
            onFailureBlock(error, response, bodyString);
        }
    }];
    
}

+ (void)deleteDummyWithId:(NSString *)dummyId onSuccess:(void (^)(NSHTTPURLResponse *response))onSuccessBlock
                onFailure:(void (^)(NSError *error, NSHTTPURLResponse *response, NSString *bodyString))onFailureBlock {
    
    if (![VLSession currentSession]) {
        if (onFailureBlock) {
            onFailureBlock([self getNoSessionError], nil, nil);
        }
        return;
    }
    NSString *path = [NSString stringWithFormat:@"/dummies/%@", dummyId];
    [[VLService sharedService] startWithHost:STRING_HOST_DUMMY path:path queries:nil HTTPMethod:@"DELETE" parameters:nil token:[VLService sharedService].session.accessToken onSuccess:^(NSDictionary *result, NSHTTPURLResponse *response) {
        if (response.statusCode == 204) {
            if (onSuccessBlock) {
                onSuccessBlock(response);
            }
        } else {
            NSError *error = [NSError errorWithDomain:ERROR_VINLI_DOMAIN code:2002 userInfo:@{@"NSLocalizedDescriptionKey": @"Received unexpected response from API call"}];
            onFailureBlock(error, response, result.description);
        }
    } onFailure:^(NSError *error, NSHTTPURLResponse *response, NSString *bodyString) {
        if (onFailureBlock) {
            onFailureBlock(error, response, bodyString);
        }
    }];

    
    
}




+ (NSError *) getNoSessionError{
    return [NSError errorWithDomain:ERROR_NO_SESSION code:2003 userInfo:@{@"NSLocalizedDescriptionKey" : @"Valid VLSession required to use this VLService method."}];
}

@end
