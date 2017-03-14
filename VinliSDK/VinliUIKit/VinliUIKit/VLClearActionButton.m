//
//  VLClearActionButton.m
//  MyVinli
//
//  Created by Bryan on 2/19/16.
//  Copyright © 2016 Vinli, inc. All rights reserved.
//

#import "VLClearActionButton.h"
#import "UIFont+VLAdditions.h"
#import "UIColor+VLAdditions.h"

@implementation VLClearActionButton

- (instancetype)init
{
    self = [super init];
    
    if (self)
    {
        [self setInitialViewDefaults];
    }
    
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self)
    {
        [self setInitialViewDefaults];
    }
    
    return self;
}

- (void)setInitialViewDefaults
{
    self.backgroundColor = [UIColor clearColor];
    [self setTitleColor:[UIColor vl_BlueColor] forState:UIControlStateNormal];
    
    self.layer.cornerRadius = 2.0f;
    
    self.titleLabel.font = [UIFont vl_OpenSans_Semibold:14.0f];
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    [self setInitialViewDefaults];
}

- (void)hide {
    self.hidden = YES;
    for (NSLayoutConstraint *c in self.constraints) {
        if (c.firstAttribute == NSLayoutAttributeHeight) {
            c.constant = 0.0f;
            break;
        }
    }
}

@end
