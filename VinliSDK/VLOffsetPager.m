//
//  VLOffsetPager.m
//  VinliSDK
//
//  Created by Tommy Brown on 5/26/15.
//  Copyright (c) 2015 Vinli. All rights reserved.
//

#import "VLOffsetPager.h"
#import "VLService.h"

@implementation VLOffsetPager

- (id) initWithDictionary:(NSDictionary *)dictionary{

    return [self initWithDictionary:dictionary service:nil];
    
}

- (id)initWithDictionary:(NSDictionary *)dictionary service:(VLService *)service
{
    if (self = [super initWithDictionary:dictionary service:service])
    {
            if(dictionary && dictionary[@"meta"] && dictionary[@"meta"][@"pagination"]) {
                _total = [dictionary[@"meta"][@"pagination"][@"total"] unsignedLongValue];
                _offset = [dictionary[@"meta"][@"pagination"][@"offset"] unsignedLongValue];
                if(dictionary[@"meta"][@"pagination"][@"links"]){
                    _firstURL = [NSURL URLWithString:dictionary[@"meta"][@"pagination"][@"links"][@"first"]];
                    _nextURL = [NSURL URLWithString:dictionary[@"meta"][@"pagination"][@"links"][@"next"]];
                    _lastURL = [NSURL URLWithString:dictionary[@"meta"][@"pagination"][@"links"][@"last"]];
            }
        }
    }
    return self;
}

- (void)getNext:(void (^)(NSArray *newValues, NSError *error))completion {
    NSURL* url = self.nextURL;
    if (!url) {
        if (completion) { return completion(nil, nil); }
        return;
    }
    
    VLOffsetPager* weakSelf = self;
    [self.service requestWithUri:url onSuccess:^(NSDictionary *result, NSHTTPURLResponse *response) {
        VLOffsetPager* strongSelf = weakSelf;
        NSArray* retArr;
        if ([strongSelf conformsToProtocol:@protocol(VLParsable)]) {
            retArr = [strongSelf performSelector:@selector(parseJSON:) withObject:result];
        }
        
        if (completion) { completion( retArr, nil); }
    } onFailure:^(NSError *error, NSHTTPURLResponse *response, NSString *msg) {
        NSLog(@"Failure");
        if (completion) { completion( nil, error); }
    }];
}

- (void)getLast:(void (^)(id value, NSError *error))completion {
    NSURL* url = self.lastURL;
    if (!url) {
        if (completion) { return completion(nil, nil); }
        return;
    }
    
    VLOffsetPager* weakSelf = self;
    [self.service requestWithUri:url onSuccess:^(NSDictionary *result, NSHTTPURLResponse *response) {
        VLOffsetPager* strongSelf = weakSelf;
        NSArray* retArr;
        if ([strongSelf conformsToProtocol:@protocol(VLParsable)]) {
            retArr = [strongSelf performSelector:@selector(parseJSON:) withObject:result];
        }
        
        if (completion) { completion( retArr.firstObject, nil); }
    } onFailure:^(NSError *error, NSHTTPURLResponse *response, NSString *msg) {
        NSLog(@"Failure");
        if (completion) { completion( nil, error); }
    }];
}

- (void)getFirst:(void (^)(id value, NSError *))completion {
    NSURL* url = self.firstURL;
    if (!url) {
        if (completion) { return completion(nil, nil); }
        return;
    }
    
    VLOffsetPager* weakSelf = self;
    [self.service requestWithUri:url onSuccess:^(NSDictionary *result, NSHTTPURLResponse *response) {
        VLOffsetPager* strongSelf = weakSelf;
        NSArray* retArr;
        if ([strongSelf conformsToProtocol:@protocol(VLParsable)]) {
            retArr = [strongSelf performSelector:@selector(parseJSON:) withObject:result];
        }
        
        if (completion) { completion( retArr.firstObject, nil); }
    } onFailure:^(NSError *error, NSHTTPURLResponse *response, NSString *msg) {
        NSLog(@"Failure");
        if (completion) { completion( nil, error); }
    }];
}

@end
