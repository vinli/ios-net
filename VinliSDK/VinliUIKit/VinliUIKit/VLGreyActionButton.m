//
//  VLGreyActionButton.m
//  MyVinli
//
//  Created by Bryan on 11/2/16.
//  Copyright © 2016 Vinli, inc. All rights reserved.
//

#import "VLGreyActionButton.h"

#import "UIColor+VLAdditions.h"

@implementation VLGreyActionButton

#pragma mark - Class Methods

- (void)transitionToCompleteFormState
{
    [UIView animateWithDuration:0.25f animations:^{
       
        [self setBackgroundColor:[UIColor vl_BlueColor]];
        self.isCompleteState = YES;
    }];
}

- (void)transitionToIncompleteFormState
{
    [UIView animateWithDuration:0.25f animations:^{
        
        [self setBackgroundColor:[UIColor colorFromRedVal:232.0f greenVal:235.0f blueVal:237.0f andAlpha:1.0f]];
        self.isCompleteState = NO;
    }];
}

#pragma mark - UIView

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    self.backgroundColor = [UIColor colorWithRed:232.0f/255.0f green:235.0f/255.0f blue:237.0f/255.0f alpha:1.0];
}

@end
