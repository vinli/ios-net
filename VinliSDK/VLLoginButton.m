//
//  VLLoginButton.m
//  VinliSDK
//
//  Created by Tommy Brown on 6/10/15.
//  Copyright (c) 2015 Vinli. All rights reserved.
//

#import "VLLoginButton.h"

@implementation VLLoginButton

- (id) init{
    self = [super init];
    if(self){
        [self initialize];
    }
    return self;
}

- (id) initWithCoder:(NSCoder *)aDecoder{
    self = [super initWithCoder:aDecoder];
    if(self){
        [self initialize];
    }
    return self;
}

- (id) initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if(self){
        [self initialize];
    }
    return self;
}

- (void) initialize{
    [super setTitle:@"Login with Vinli" forState:UIControlStateNormal];
    [super setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [super setBackgroundColor:[UIColor colorWithRed:23.0f/255.0f green:172.0f/255.0f blue:139.0f/255.0f alpha:1]];
}

#pragma mark - Override super methods

- (void) setTitle:(NSString *)title forState:(UIControlState)state{}

- (void) setTitleColor:(UIColor *)color forState:(UIControlState)state{};

- (void) setBackgroundColor:(UIColor *)backgroundColor{}

- (void) setBackgroundImage:(UIImage *)image forState:(UIControlState)state{}

@end
