//
//  VLActionButton.m
//  MyVinli
//
//  Created by Andrew Wells on 1/3/16.
//  Copyright © 2016 Vinli, inc. All rights reserved.
//

#import "VLActionButton.h"
#import "UIColor+VLAdditions.h"
#import "UIFont+VLAdditions.h"

@implementation VLActionButton

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
    self.backgroundColor = [UIColor vl_BlueColor];
    [self setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
    self.layer.cornerRadius = 2.0f;
    
    self.titleLabel.font = [UIFont vl_OpenSans_Semibold:14.0f];
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    [self setInitialViewDefaults];
    
}

@end
