//
//  VLUser.m
//  VinliSDK
//
//  Created by Tommy Brown on 5/29/15.
//  Copyright (c) 2015 Vinli. All rights reserved.
//

#import "VLUser.h"

@implementation VLUser

- (id) initWithDictionary:(NSDictionary *)dictionary{
    self = [super init];
    if(self){
        if(dictionary){
            if(dictionary[@"user"]){
                NSDictionary *userDictionary = [NSDictionary dictionaryWithDictionary:dictionary[@"user"]];
                
                _userId = userDictionary[@"id"];
                
                _firstName = (userDictionary[@"firstName"] == (id)[NSNull null]) ? nil : userDictionary[@"firstName"];
                
                _lastName = (userDictionary[@"lastName"] == (id)[NSNull null]) ? nil : userDictionary[@"lastName"];
                
                _email = userDictionary[@"email"];
                _phone = userDictionary[@"phone"];
                
                _imageURL = (userDictionary[@"image"] == (id)[NSNull null]) ? nil : [NSURL URLWithString:userDictionary[@"image"]];
            }
        }
    }
    return self;
}

@end
