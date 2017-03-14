//
//  VLGreyActionButton.h
//  MyVinli
//
//  Created by Bryan on 11/2/16.
//  Copyright © 2016 Vinli, inc. All rights reserved.
//

#import "VLActionButton.h"

@interface VLGreyActionButton : VLActionButton

@property (assign, nonatomic) BOOL isCompleteState;

- (void)transitionToCompleteFormState;
- (void)transitionToIncompleteFormState;

@end
