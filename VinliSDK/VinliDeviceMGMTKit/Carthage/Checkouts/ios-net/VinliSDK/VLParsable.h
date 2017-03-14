//
//  VLParsable.h
//  VinliSDK
//
//  Created by Andrew Wells on 11/29/16.
//  Copyright © 2016 Vinli. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol VLParsable <NSObject>

- (NSArray *)parseJSON:(NSDictionary *)json;

@end
