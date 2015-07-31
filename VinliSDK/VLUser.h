//
//  VLUser.h
//  VinliSDK
//
//  Created by Tommy Brown on 5/29/15.
//  Copyright (c) 2015 Vinli. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface VLUser : NSObject

@property (readonly) NSString *userId;
@property (readonly) NSString *firstName;
@property (readonly) NSString *lastName;
@property (readonly) NSString *email;
@property (readonly) NSString *phone;
@property (readonly) NSURL *imageURL;

- (id) initWithDictionary: (NSDictionary *) dictionary;

@end
