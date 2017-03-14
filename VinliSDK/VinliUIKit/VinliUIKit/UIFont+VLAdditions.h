//
//  UIFont+VLAdditions.h
//  MyVinli
//
//  Created by Andrew Wells on 1/3/16.
//  Copyright © 2016 Vinli, inc. All rights reserved.
//

#import <UIKit/UIKit.h>

extern NSString * const kOpenSansSemiBold;

@interface UIFont (VLAdditions)

+ (UIFont *)vl_OpenSans:(CGFloat)size;
+ (UIFont *)vl_OpenSans_Semibold:(CGFloat)size;
+ (UIFont *)vl_OpenSans_Bold:(CGFloat)size;
+ (UIFont *)vl_OpenSans_Light:(CGFloat)size;
+ (UIFont *)vl_BebasNeue:(CGFloat)size;
+ (UIFont *)vl_BebasNeueBold:(CGFloat)size;
+ (UIFont *)vl_OpenSans_ExtraBold:(CGFloat)size;

@end
