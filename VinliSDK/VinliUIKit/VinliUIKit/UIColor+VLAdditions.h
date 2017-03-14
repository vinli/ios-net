//
//  UIColor+VLAdditions.h
//  MyVinli
//
//  Created by Andrew Wells on 10/27/15.
//  Copyright © 2015 Vinli, inc. All rights reserved.
//

#import <UIKit/UIKit.h>



@interface UIColor (VLAdditions)

// Assumes input like "#00FF00" (#RRGGBB).
+ (UIColor *)colorFromHexString:(NSString *)hexString;

+ (UIColor *)colorFromRedVal:(CGFloat)redValue greenVal:(CGFloat)greenValue blueVal:(CGFloat)blueValue andAlpha:(CGFloat)alpha;

#pragma mark - White Label Colors

+ (UIColor *)vl_PrimaryUIElementsColor;
+ (UIColor *)vl_PositiveElementsColor;
+ (UIColor *)vl_NeutralColor;
+ (UIColor *)vl_NegativeColor;
+ (UIColor *)vl_BackgroundColor;

+ (UIColor *)vl_HeadlinesLargeNumbersTextColor;
+ (UIColor *)vl_BodyCopyTextColor;
+ (UIColor *)vl_InactiveTextColor;
+ (UIColor *)vl_LinksTextColor;
+ (UIColor *)vl_WarningDeleteTextColor;

+ (UIColor *)vl_VinliBlueColor;
+ (UIColor *)vl_VinliGreenColor;
+ (UIColor *)vl_VinliYellowColor;
+ (UIColor *)vl_VinliRedColor;
+ (UIColor *)vl_VinliBlack100PercentColor;
+ (UIColor *)vl_VinliBlack90PercentColor;
+ (UIColor *)vl_VinliBlack80PercentColor;
+ (UIColor *)vl_VinliBlack70PercentColor;
+ (UIColor *)vl_VinliBlack60PercentColor;
+ (UIColor *)vl_VinliBlack50PercentColor;
+ (UIColor *)vl_VinliBlack40PercentColor;
+ (UIColor *)vl_VinliBlack30PercentColor;
+ (UIColor *)vl_VinliBlack20PercentColor;
+ (UIColor *)vl_VinliBlack10PercentColor;
+ (UIColor *)vl_VinliWhiteColor;

#pragma mark - Old Colors

+ (UIColor *)vl_BlueColor;
+ (UIColor *)vl_LightGreyColor;
+ (UIColor *)vl_DarkGreyColor;

// Used for the tab bar
+ (UIColor *)vl_OffWhiteColor;

// Used for background of images views that haven't retrieved their images
// from the network yet.
+ (UIColor *)vl_GreyImageBackground;

+ (UIColor *)vl_BlueCellSelectedColor;

+ (UIColor *)vl_SegmentedControlBackgroundColor;

+ (UIColor *)vl_RedColor;
+ (UIColor *)vl_GreenColor;

+ (UIColor *)vl_FadedBlueColor;

+ (UIColor *)vl_GreySystemTableViewBackgroundColor;

#pragma mark - Binge On Colors

+ (UIColor *)vl_TMobileMagentaColor;
+ (UIColor *)vl_TableViewCellTitleGreyColor;
+ (UIColor *)vl_ButtonLightGreyColor;

#pragma mark - Separator Color

+ (UIColor *)vl_GreySeparatorColor;

#pragma mark - Services Colors

+ (UIColor *)vl_BlueMyServicesBannerColor;

+ (UIColor *)vl_OffWhiteMyServicesBannerTextColor;

+ (UIColor *)vl_RequestAssistanceButtonBackgroundColor;

+ (UIColor *)vl_NerbyTowingNumberLabelColor;

+ (UIColor *)vl_NerbyTowingAddressLabelColor;

+ (UIColor *)vl_AccountGreyTitleLabelColor;

+ (UIColor *)vl_GreenButtonColor;

+ (UIColor *)vl_RedECallBannerColor;

+ (UIColor *)vl_RedECallButtonColor;

+ (UIColor *)vl_ServicesDarkGreyColor;

+ (UIColor *)vl_ServicesGreyLabelColor;

+ (UIColor *)vl_ServicesLightGreyColor;

+ (UIColor *)vl_ServicesYellowColor;

@end
