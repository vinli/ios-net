//
//  UIColor+VLAdditions.m
//  MyVinli
//
//  Created by Andrew Wells on 10/27/15.
//  Copyright © 2015 Vinli, inc. All rights reserved.
//

#import "UIColor+VLAdditions.h"

@implementation UIColor (VLAdditions)

// Assumes input like "#00FF00" (#RRGGBB).
+ (UIColor *)colorFromHexString:(NSString *)hexString {
    unsigned rgbValue = 0;
    NSScanner *scanner = [NSScanner scannerWithString:hexString];
    [scanner setScanLocation:1]; // bypass '#' character
    [scanner scanHexInt:&rgbValue];
    return [UIColor colorWithRed:((rgbValue & 0xFF0000) >> 16)/255.0 green:((rgbValue & 0xFF00) >> 8)/255.0 blue:(rgbValue & 0xFF)/255.0 alpha:1.0];
}

+ (UIColor *)colorFromRedVal:(CGFloat)redValue greenVal:(CGFloat)greenValue blueVal:(CGFloat)blueValue andAlpha:(CGFloat)alpha
{
    if (redValue > 255.0f || redValue < 0.0f || blueValue > 255.0f || blueValue < 0.0f || greenValue > 255.0f || greenValue < 0.0f || alpha > 1.0f || alpha < 0.0f)
    {
        NSLog(@"Color creation failes because one of the parameters does meet the requirements.");
        return nil;
    }
    
    return [UIColor colorWithRed:redValue/255.0f green:greenValue/255.0f blue:blueValue/255.0f alpha:alpha];
}

#pragma mark - White Label Colors

+ (UIColor *)vl_PrimaryUIElementsColor
{
    return [UIColor vl_VinliBlueColor];
}

+ (UIColor *)vl_PositiveElementsColor
{
    return [UIColor vl_VinliGreenColor];
}

+ (UIColor *)vl_NeutralColor
{
    return [UIColor vl_VinliYellowColor];
}

+ (UIColor *)vl_NegativeColor
{
    return [UIColor vl_VinliRedColor];
}

+ (UIColor *)vl_BackgroundColor
{
    return [UIColor colorFromRedVal:235.0f greenVal:239.0f blueVal:240.0f andAlpha:1.0f];
}

+ (UIColor *)vl_HeadlinesLargeNumbersTextColor
{
    return [UIColor vl_VinliBlack100PercentColor];
}

+ (UIColor *)vl_BodyCopyTextColor
{
    return [UIColor vl_VinliBlack70PercentColor];
}

+ (UIColor *)vl_InactiveTextColor
{
    return [UIColor vl_VinliBlack20PercentColor];
}

+ (UIColor *)vl_LinksTextColor
{
    return [UIColor vl_VinliBlueColor];
}

+ (UIColor *)vl_WarningDeleteTextColor
{
    return [UIColor vl_VinliRedColor];
}

+ (UIColor *)vl_VinliBlueColor
{
    return [UIColor colorFromRedVal:0.0f greenVal:163.0f blueVal:224.0f andAlpha:1.0f];
}

+ (UIColor *)vl_VinliGreenColor
{
    return [UIColor colorFromRedVal:76.0f greenVal:210.0f blueVal:154.0f andAlpha:1.0f];
}

+ (UIColor *)vl_VinliYellowColor
{
    return [UIColor colorFromRedVal:242.0f greenVal:206.0f blueVal:114.0f andAlpha:1.0f];
}

+ (UIColor *)vl_VinliRedColor
{
    return [UIColor colorFromRedVal:240.0f greenVal:106.0f blueVal:69.0f andAlpha:1.0f];
}

+ (UIColor *)vl_VinliBlack100PercentColor
{
    return [UIColor colorFromRedVal:26.0f greenVal:54.0f blueVal:71.0f andAlpha:1.0f];
}

+ (UIColor *)vl_VinliBlack90PercentColor
{
    return [UIColor colorFromRedVal:49.0f greenVal:74.0f blueVal:90.0f andAlpha:1.0f];
}

+ (UIColor *)vl_VinliBlack80PercentColor
{
    return [UIColor colorFromRedVal:72.0f greenVal:95.0f blueVal:108.0f andAlpha:1.0f];
}

+ (UIColor *)vl_VinliBlack70PercentColor
{
    return [UIColor colorFromRedVal:95.0f greenVal:114.0f blueVal:126.0f andAlpha:1.0f];
}

+ (UIColor *)vl_VinliBlack60PercentColor
{
    return [UIColor colorFromRedVal:118.0f greenVal:135.0f blueVal:145.0f andAlpha:1.0f];
}

+ (UIColor *)vl_VinliBlack50PercentColor
{
    return [UIColor colorFromRedVal:141.0f greenVal:155.0f blueVal:163.0f andAlpha:1.0f];
}

+ (UIColor *)vl_VinliBlack40PercentColor
{
    return [UIColor colorFromRedVal:164.0f greenVal:175.0f blueVal:182.0f andAlpha:1.0f];
}

+ (UIColor *)vl_VinliBlack30PercentColor
{
    return [UIColor colorFromRedVal:186.0f greenVal:195.0f blueVal:200.0f andAlpha:1.0f];
}

+ (UIColor *)vl_VinliBlack20PercentColor
{
    return [UIColor colorFromRedVal:210.0f greenVal:215.0f blueVal:219.0f andAlpha:1.0f];
}

+ (UIColor *)vl_VinliBlack10PercentColor
{
    return [UIColor colorFromRedVal:232.0f greenVal:235.0f blueVal:237.0f andAlpha:1.0f];
}

+ (UIColor *)vl_VinliWhiteColor
{
    return [UIColor colorFromRedVal:255.0f greenVal:255.0f blueVal:255.0f andAlpha:1.0f];
}

#pragma mark - Old Colors

+ (UIColor *)vl_BlueColor
{
    return [UIColor colorWithRed:0.0f/255.0f green:163.0f/255.0f blue:224.0f/255.0f alpha:1];

}

+ (UIColor *)vl_LightGreyColor
{
    return [UIColor colorWithRed:157.0f/255.0f green:170.0f/255.0f blue:176.0f/255.0f alpha:1];
}

+ (UIColor *)vl_DarkGreyColor
{
    return [UIColor colorWithRed:91.0f/255.0f green:92.0f/255.0f blue:94.0f/255.0f alpha:1];
}

+ (UIColor *)vl_OffWhiteColor
{
    return [UIColor colorWithRed:247.0f/255.0f green:247.0f/255.0f blue:247.0f/255.0f alpha:1];
}

+ (UIColor *)vl_GreyImageBackground
{
     return [UIColor colorWithRed:229.0f/255.0f green:229.0f/255.0f blue:229.0f/255.0f alpha:1];
}

+ (UIColor *)vl_BlueCellSelectedColor
{
      return [UIColor colorWithRed:36.0f/255.0f green:167.0f/255.0f blue:223.0f/255.0f alpha:0.3f];
}

+ (UIColor *)vl_RedColor
{
    return [UIColor colorWithRed:242.0f/255.0f green:108.0f/255.0f blue:70.0f/255.0f alpha:1];
}

+ (UIColor *)vl_GreenColor
{
    return [UIColor colorWithRed:73.0f/255.0f green:204.0f/255.0f blue:156.0f/255.0f alpha:1];
}

+ (UIColor *)vl_FadedBlueColor
{
    return [UIColor colorWithRed:62.0f/255.0f green:178.0f/255.0f blue:223.0f/255.0f alpha:1];
}

+ (UIColor *)vl_GreySystemTableViewBackgroundColor
{
    return [UIColor colorWithRed:237.0f/255.0f green:241.0f/255.0f blue:242.0f/255.0f alpha:1];
}

#pragma mark - Binge On Colors

+ (UIColor *)vl_TMobileMagentaColor
{
    return [UIColor colorWithRed:237.0f/255.0f green:0.0f/255.0f blue:140.0f/255.0f alpha:1];
}

+ (UIColor *)vl_TableViewCellTitleGreyColor
{
    return [UIColor colorWithRed:201.0f/255.0f green:201.0f/255.0f blue:201.0f/255.0f alpha:1];
}

+ (UIColor *)vl_ButtonLightGreyColor
{
    return [UIColor colorWithRed:208.0f/255.0f green:209.0f/255.0f blue:210.0f/255.0f alpha:1];
}

#pragma mark - Separator Color

+ (UIColor *)vl_GreySeparatorColor
{
    return [UIColor colorWithRed:234.0f/255.0f green:234.0f/255.0f blue:234.0f/255.0f alpha:1.0f];
}

#pragma mark - Services Colors

+ (UIColor *)vl_BlueMyServicesBannerColor
{
    return [UIColor colorWithRed:51.0f/255.0f green:63.0f/255.0f blue:72.0f/255.0f alpha:1.0f];
}

+ (UIColor *)vl_OffWhiteMyServicesBannerTextColor
{
    return [UIColor colorWithRed:245.0f/255.0f green:246.0f/255.0f blue:247.0f/255.0f alpha:1.0f];
}

+ (UIColor *)vl_SegmentedControlBackgroundColor
{
    return [UIColor colorWithRed:239.0f/255.0f green:239.0f/255.0f blue:244.0f/255.0f alpha:0.3f];
}

+ (UIColor *)vl_RequestAssistanceButtonBackgroundColor
{
    return [UIColor colorWithRed:247.0f/255.0f green:126.0f/255.0f blue:89.0f/255.0f alpha:1.0f];
}

+ (UIColor *)vl_NerbyTowingNumberLabelColor
{
    return [UIColor colorWithRed:214.0f/255.0f green:214.0f/255.0f blue:214.0f/255.0f alpha:1.0f];
}

+ (UIColor *)vl_NerbyTowingAddressLabelColor
{
    return [UIColor colorWithRed:173.0f/255.0f green:173.0f/255.0f blue:173.0f/255.0f alpha:1.0f];
}

+ (UIColor *)vl_AccountGreyTitleLabelColor
{
    return [UIColor colorWithRed:192.0f/255.0f green:192.0f/255.0f blue:192.0f/255.0f alpha:1.0f];
}

+ (UIColor *)vl_GreenButtonColor
{
    return [UIColor colorWithRed:89.0f/255.0f green:208.0f/255.0f blue:156.0f/255.0f alpha:1.0f];
}

+ (UIColor *)vl_RedECallBannerColor
{
    return [UIColor colorWithRed:189.0f/255.0f green:48.0f/255.0f blue:57.0f/255.0f alpha:1.0f];
}

+ (UIColor *)vl_RedECallButtonColor
{
    return [UIColor colorWithRed:229.0f/255.0f green:77.0f/255.0f blue:66.0f/255.0f alpha:1.0f];
}

+ (UIColor *)vl_ServicesDarkGreyColor
{
    return [UIColor colorWithRed:70.0f/255.0f green:81.0f/255.0f blue:89.0f/255.0f alpha:1.0f];
}

+ (UIColor *)vl_ServicesGreyLabelColor
{
    return [UIColor colorWithRed:102.0f/255.0f green:103.0f/255.0f blue:105.0f/255.0f alpha:1.0f];
}

+ (UIColor *)vl_ServicesLightGreyColor
{
    return [UIColor colorWithRed:242.0f/255.0f green:242.0f/255.0f blue:242.0f/255.0f alpha:1.0f];
}

+ (UIColor *)vl_ServicesYellowColor;
{
    return [UIColor colorWithRed:255.0f/255.0f green:220.0f/255.0f blue:115.0f/255.0f alpha:1.0f];
}

@end
