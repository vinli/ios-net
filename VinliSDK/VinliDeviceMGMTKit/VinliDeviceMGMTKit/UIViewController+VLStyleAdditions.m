//
//  UIViewController+VLStyleAdditions.m
//  VinliDeviceMGMTKit
//
//  Created by Bryan on 2/27/17.
//  Copyright © 2017 vinli. All rights reserved.
//

#import "UIViewController+VLStyleAdditions.h"

#import "UIFont+VLAdditions.h"

@implementation UIViewController (VLStyleAdditions)

- (void)setTitleText:(NSString *)title
{
    self.navigationItem.titleView = [self titleLabelWithTitle:title];;
}

- (UILabel *)titleLabelWithTitle:(NSString *)title
{
    if (!title) {
        return nil;
    }
    
    NSDictionary* attributes = @{ NSForegroundColorAttributeName: [UIColor whiteColor],
                                  NSFontAttributeName: [UIFont vl_BebasNeueBold:22.0f],
                                  NSKernAttributeName: @(1.65)};
    
    UILabel *titleLabel = [UILabel new];
    titleLabel.adjustsFontSizeToFitWidth = YES;
    titleLabel.minimumScaleFactor = 0.3f;
    titleLabel.attributedText = [[NSAttributedString alloc] initWithString:title attributes:attributes];
    [titleLabel sizeToFit];
    
    return titleLabel;

}

@end
