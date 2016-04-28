//
//  DeviceFooterView.m
//  ios-net-demo
//
//  Created by Tommy Brown on 4/28/16.
//  Copyright © 2016 Vinli. All rights reserved.
//

#import "DeviceFooterView.h"

@implementation DeviceFooterView

- (id) initWithSection:(int)section frame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if(self){
        _section = section;
        [self setupButtons];
    }
    return self;
}

- (void) setupButtons{
    _setOdometerButton = [[UIButton alloc] init];
    [_setOdometerButton setTitle:@"Odometer" forState:UIControlStateNormal];
    _setOdometerButton.translatesAutoresizingMaskIntoConstraints = NO;
    _setOdometerButton.tag = _section;
    _setOdometerButton.clipsToBounds = false;
    _setOdometerButton.layer.cornerRadius = 4;
    [self addSubview:_setOdometerButton];
    
    _streamButton = [[UIButton alloc] init];
    [_streamButton setTitle:@"Stream" forState:UIControlStateNormal];
    _streamButton.translatesAutoresizingMaskIntoConstraints = NO;
    _streamButton.tag = _section;
    _streamButton.clipsToBounds = false;
    _streamButton.layer.cornerRadius = 4;
    [self addSubview:_streamButton];
    
    NSDictionary *bindings = NSDictionaryOfVariableBindings(_setOdometerButton, _streamButton);
    NSDictionary *metrics = @{@"horizontalMargin" : @8, @"verticalMargin" : @8};
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-verticalMargin-[_setOdometerButton]-verticalMargin-|" options:0 metrics:metrics views:bindings]];
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-verticalMargin-[_streamButton]-verticalMargin-|" options:0 metrics:metrics views:bindings]];
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-horizontalMargin-[_setOdometerButton]-horizontalMargin-[_streamButton]-horizontalMargin-|" options:0 metrics:metrics views:bindings]];
    
    NSLayoutConstraint *equalWidthsConstraint = [NSLayoutConstraint constraintWithItem:_setOdometerButton attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:_streamButton attribute:NSLayoutAttributeWidth multiplier:1.0 constant:0.0];
    [self addConstraint:equalWidthsConstraint];
}

@end
