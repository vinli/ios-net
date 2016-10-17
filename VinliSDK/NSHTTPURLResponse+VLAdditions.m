//
//  NSHTTPURLResponse+VLAdditions.m
//  VinliSDK
//
//  Created by Bryan on 10/17/16.
//  Copyright © 2016 Vinli. All rights reserved.
//

#import "NSHTTPURLResponse+VLAdditions.h"

@implementation NSHTTPURLResponse (VLAdditions)

- (BOOL)isSuccessfulResponse
{
    BOOL retVal = NO;
    
    if (self.statusCode >= 200 && self.statusCode <= 299)
    {
        retVal = YES;
    }
    
    return retVal;
}

@end
