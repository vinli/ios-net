//
//  DeviceFooterView.h
//  ios-net-demo
//
//  Created by Tommy Brown on 4/28/16.
//  Copyright © 2016 Vinli. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DeviceFooterView : UIView

@property (strong, nonatomic) UIButton *setOdometerButton;
@property (strong, nonatomic) UIButton *streamButton;
@property (nonatomic) int section;

- (id) initWithSection:(int)section frame:(CGRect)frame;

@end
