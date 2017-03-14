//
//  VLActivityIndicatorView.m
//  VinliDeviceMGMTKit
//
//  Created by Bryan on 3/6/17.
//  Copyright © 2017 vinli. All rights reserved.
//

#import "VLActivityIndicatorView.h"

#import "UIColor+VLAdditions.h"

@implementation VLActivityIndicatorView

#pragma mark - Initializers

- (instancetype)init
{
    if (self = [super init])
    {
        self.activityIndicatorViewStyle = UIActivityIndicatorViewStyleWhiteLarge;
        self.color = [UIColor vl_BlueColor];
    }
    
    return self;
}

#pragma mark - Class Methods

- (void)addActivityIndicatorToView:(UIView *)superView
{
    if (!superView) {
        return;
    }
    
    self.translatesAutoresizingMaskIntoConstraints = NO;
    
    [superView addSubview:self];
    
    NSLayoutConstraint *top = [NSLayoutConstraint constraintWithItem:self
                                                           attribute:NSLayoutAttributeTop
                                                           relatedBy:NSLayoutRelationEqual
                                                              toItem:superView
                                                           attribute:NSLayoutAttributeTop
                                                          multiplier:1.0f
                                                            constant:0.0f];
    NSLayoutConstraint *bottom = [NSLayoutConstraint constraintWithItem:self
                                                           attribute:NSLayoutAttributeBottom
                                                           relatedBy:NSLayoutRelationEqual
                                                              toItem:superView
                                                           attribute:NSLayoutAttributeBottom
                                                          multiplier:1.0f
                                                            constant:0.0f];
    NSLayoutConstraint *leading = [NSLayoutConstraint constraintWithItem:self
                                                           attribute:NSLayoutAttributeLeading
                                                           relatedBy:NSLayoutRelationEqual
                                                              toItem:superView
                                                           attribute:NSLayoutAttributeLeading
                                                          multiplier:1.0f
                                                            constant:0.0f];
    NSLayoutConstraint *trailing = [NSLayoutConstraint constraintWithItem:self
                                                           attribute:NSLayoutAttributeTrailing
                                                           relatedBy:NSLayoutRelationEqual
                                                              toItem:superView
                                                           attribute:NSLayoutAttributeTrailing
                                                          multiplier:1.0f
                                                            constant:0.0f];
    
    [superView addConstraints:@[top, bottom, leading, trailing]];
    
    [self startAnimating];
}

- (void)removeActivityIndicatorFromSuperView;
{
    [self stopAnimating];
    [self removeFromSuperview];
}

- (BOOL)hidesWhenStopped
{
    return YES;
}

@end
