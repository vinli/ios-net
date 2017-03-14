//
//  VLActivityIndicatorView.h
//  VinliDeviceMGMTKit
//
//  Created by Bryan on 3/6/17.
//  Copyright © 2017 vinli. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface VLActivityIndicatorView : UIActivityIndicatorView

- (void)addActivityIndicatorToView:(UIView *)superView;
- (void)removeActivityIndicatorFromSuperView;

@end
