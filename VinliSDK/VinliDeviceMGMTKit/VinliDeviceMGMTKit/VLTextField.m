//
//  VLTextField.m
//  MyVinli
//
//  Created by Bryan on 10/18/16.
//  Copyright © 2016 Vinli, inc. All rights reserved.
//

#import "VLTextField.h"

@implementation VLTextField

@dynamic delegate;

- (void)deleteBackward
{
    [super deleteBackward];
    
    if ([self.delegate respondsToSelector:@selector(textFieldDidEmptyBackspace:)] && self.text.length == 0)
    {
        [self.delegate textFieldDidEmptyBackspace:self];
    }
}

@end
