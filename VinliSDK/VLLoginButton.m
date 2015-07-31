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
    [super setBackgroundColor:[UIColor colorWithRed:23/255.0 green:172/255.0 blue:139/255.0 alpha:1.0]];
}

#pragma mark - Override super methods

- (void) setTitle:(NSString *)title forState:(UIControlState)state{}

- (void) setTitleColor:(UIColor *)color forState:(UIControlState)state{};

- (void) setBackgroundColor:(UIColor *)backgroundColor{}

- (void) setBackgroundImage:(UIImage *)image forState:(UIControlState)state{}

@end
