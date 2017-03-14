//
//  VLGreySeparatorView.m
//  MyVinli
//
//  Created by Bryan on 4/26/16.
//  Copyright © 2016 Vinli, inc. All rights reserved.
//

#import "VLGreySeparatorView.h"
#import "UIColor+VLAdditions.h"

@implementation VLGreySeparatorView

- (instancetype)init
{
    self = [super init];
    
    if (self)
    {
        [self setBackgroundColor:[UIColor vl_GreySeparatorColor]];
    }
    
    return self;
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    [self setBackgroundColor:[UIColor vl_GreySeparatorColor]];
}

- (void)drawRect:(CGRect)rect
{
    [super drawRect:rect];
    
    CGRect myFrame = self.bounds;
    [[UIColor vl_GreySeparatorColor] set];
    UIRectFrame(myFrame);
    
}

@end
