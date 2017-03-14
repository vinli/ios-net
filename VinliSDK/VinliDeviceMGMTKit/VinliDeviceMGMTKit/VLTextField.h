//
//  VLTextField.h
//  MyVinli
//
//  Created by Bryan on 10/18/16.
//  Copyright © 2016 Vinli, inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol VLTextFieldDelegate <UITextFieldDelegate>
@optional
- (void)textFieldDidEmptyBackspace:(UITextField *)textField;
@end

@interface VLTextField : UITextField

@property (weak, nonatomic) id <VLTextFieldDelegate> delegate;

@end
