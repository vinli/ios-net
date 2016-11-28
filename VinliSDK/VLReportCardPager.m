//
//  VLReportCardPager.m
//  VinliSDK
//
//  Created by Andrew Wells on 11/21/16.
//  Copyright © 2016 Vinli. All rights reserved.
//

#import "VLReportCardPager.h"
#import "VLReportCard.h"
#import "NSDictionary+NonNullable.h"

@implementation VLReportCardPager


- (instancetype) initWithDictionary:(NSDictionary *)dictionary {
    return [self initWithDictionary:dictionary service:nil];
}



- (instancetype)initWithDictionary:(NSDictionary *)dictionary service:(VLService *)service {
    if (self = [super initWithDictionary:dictionary service:service])
    {
        if (self) {
            _reportCards = [self parseJSON:dictionary];
        }
    }
    
    return self;
}

- (NSArray *)parseJSON:(NSDictionary *)json {
    NSArray* reportCards = [json vl_getArrayAttributeForKey:@"reportCards"];
    NSMutableArray* retArry = [[NSMutableArray alloc] initWithCapacity:reportCards.count];
    
    for (NSDictionary *dic in reportCards) {
        VLReportCard *reportCard = [[VLReportCard alloc] initWithDictionary:dic];
        if (reportCard) {
            [retArry addObject:reportCard];
        }
    }

    if (!_reportCards) {
        _reportCards = [retArry copy];
    }
    else {
        NSMutableArray *mutableReportCards = [_reportCards mutableCopy];
        [mutableReportCards addObjectsFromArray:retArry];
        _reportCards = [mutableReportCards copy];
    }
    
    return [retArry copy];
}

@end
