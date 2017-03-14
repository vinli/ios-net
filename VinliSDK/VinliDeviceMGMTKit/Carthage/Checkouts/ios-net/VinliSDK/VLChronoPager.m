//
//  VLChronoPager.m
//  VinliSDK
//
//  Created by Tommy Brown on 5/26/15.
//  Copyright (c) 2015 Vinli. All rights reserved.
//

#import "VLChronoPager.h"
#import "VLService.h"

#import "NSDictionary+NonNullable.h"

@interface VLChronoPager()
@property (strong, nonatomic) NSURL* priorURL;
@property (strong, nonatomic) NSURL* nextURL;
@property (nonatomic) NSInteger remaining;
@end

@implementation VLChronoPager

- (id) initWithDictionary:(NSDictionary *)dictionary {
    
    return [self initWithDictionary:dictionary service:nil];
}

- (id) initWithDictionary:(NSDictionary *)dictionary service:(VLService *)service
{
    if (self = [super initWithDictionary:dictionary service:service])
    {
        NSDictionary *pagination = dictionary[@"meta"][@"pagination"];
        if(pagination)
        {
            pagination = [pagination filterAllNSNullValues];
            
            _remaining = [pagination[@"remaining"] integerValue];//tbd this maybe should be remainingCount.
       
            _until = pagination[@"until"];
            _since = pagination[@"since"];
            
            if(dictionary[@"meta"][@"pagination"][@"links"])
            {
                _nextURL = [NSURL URLWithString:pagination[@"links"][@"next"]];
                _priorURL = [NSURL URLWithString:pagination[@"links"][@"prior"]];
            }
        }

    }
    return self;
}

- (void)getNext:(void (^)(NSArray *newValues, NSError *error))completion {
    NSURL* url = self.priorURL ?: self.nextURL;
    VLChronoPager* weakSelf = self;
    [self.service requestWithUri:url onSuccess:^(NSDictionary *result, NSHTTPURLResponse *response) {
        VLChronoPager* strongSelf = weakSelf;
        NSArray* retArr = [strongSelf parseJSON:result];
        if (completion) { completion( retArr, nil); }
    } onFailure:^(NSError *error, NSHTTPURLResponse *response, NSString *msg) {
        NSLog(@"Failure");
        if (completion) { completion( nil, error); }
    }];
}

- (NSArray *)parseJSON:(NSDictionary *)json {
    assert(@"This is an abstract method. Must be implemented by subclass");
    return nil;
}

@end
