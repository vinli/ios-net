//
//  UIFont+VLAdditions.m
//  MyVinli
//
//  Created by Andrew Wells on 1/3/16.
//  Copyright © 2016 Vinli, inc. All rights reserved.
//

#import "UIFont+VLAdditions.h"

NSString * const kBebasNeueBold = @"BebasNeueBold";

NSString * const kOpenSansSemiBold = @"OpenSans-Semibold";
NSString * const kOpenSans = @"OpenSans";
NSString * const kOpenSansBold = @"OpenSans-Bold";

@implementation UIFont (VLAdditions)

+ (UIFont *)vl_OpenSans:(CGFloat)size
{
    return [UIFont fontWithName:kOpenSans size:size];
}

+ (UIFont *)vl_OpenSans_Semibold:(CGFloat)size
{
    return [UIFont fontWithName:kOpenSansSemiBold size:size];
}

+ (UIFont *)vl_OpenSans_Bold:(CGFloat)size
{
    return  [UIFont fontWithName:kOpenSansBold size:size];
}

+ (UIFont *)vl_BebasNeueBold:(CGFloat)size
{
     return [UIFont fontWithName:kBebasNeueBold size:size];
}

- (void)printAvailableFontsForFontFamily:(NSString *)fontFamily
{
    for (NSString* fontName in [UIFont fontNamesForFamilyName:fontFamily])
    {
         NSLog(@"Font - %@", fontName);
    }
}

@end
