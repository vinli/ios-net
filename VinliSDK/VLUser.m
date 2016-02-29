//
//  VLUser.m
//  VinliSDK
//
//  Created by Tommy Brown on 5/29/15.
//  Copyright (c) 2015 Vinli. All rights reserved.
//

#import "VLUser.h"
#import "VLUnitLocalizer.h"

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
                
                NSDictionary* settings = userDictionary[@"settings"];
                if (settings){
                    _settings = [[VLUserSettings alloc] initWithDictionary:settings];
                    [VLUnitLocalizer setLocalizedUnitWithUnitString:_settings.unitStr]; 
                }

            }
        }
    }
    return self;
}

- (NSString *)description {
    return [NSString stringWithFormat:@"<%@: %p (userId: %@) (firstName: %@) (lastName: %@)>", NSStringFromClass([self class]), self, self.userId, self.firstName, self.lastName];;
}

- (void)encodeWithCoder:(NSCoder *)encoder {
    [encoder encodeObject:self.userId forKey:@"userId"];
    [encoder encodeObject:self.firstName forKey:@"firstName"];
    [encoder encodeObject:self.lastName forKey:@"lastName"];
    [encoder encodeObject:self.email forKey:@"email"];
    [encoder encodeObject:self.phone forKey:@"phone"];
    [encoder encodeObject:self.imageURL forKey:@"imageURL"];
}

- (id)initWithCoder:(NSCoder *)decoder {
    if((self = [super init])) {
        _userId = [decoder decodeObjectForKey:@"userId"];
        _firstName = [decoder decodeObjectForKey:@"firstName"];
        _lastName = [decoder decodeObjectForKey:@"lastName"];
        _email = [decoder decodeObjectForKey:@"email"];
        _phone = [decoder decodeObjectForKey:@"phone"];
        _imageURL = [decoder decodeObjectForKey:@"firstName"];
    }
    return self;
}


@end
