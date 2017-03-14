//
//  VLDFontManager.m
//  VinliDeviceMGMTKit
//
//  Created by Bryan on 3/6/17.
//  Copyright © 2017 vinli. All rights reserved.
//

#import "VLDFontManager.h"

#import <UIKit/UIKit.h>
#import <CoreText/CTFontManager.h>

NSString * const kBebasNeueBoldPathIdentifier = @"BebasNeue-Bold";

NSString * const kOpenSansSemiBoldPathIdentifier = @"OpenSans-Semibold";
NSString * const kOpenSansPathIdentifier = @"OpenSans-Regular";
NSString * const kOpenSansBoldPathIdentifier = @"OpenSans-Bold";

@implementation VLDFontManager

+ (instancetype)load
{
    static VLDFontManager *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[VLDFontManager alloc] init];
        
        // Dynamically load bundled custom fonts
        [instance loadFontWithName:kBebasNeueBoldPathIdentifier];
        [instance loadFontWithName:kOpenSansSemiBoldPathIdentifier];
        [instance loadFontWithName:kOpenSansPathIdentifier];
        [instance loadFontWithName:kOpenSansBoldPathIdentifier];
    });
    
    return instance;
}

- (void)loadFontWithName:(NSString *)fontName
{
    NSString *fontPath = [[NSBundle bundleForClass:[VLDFontManager class]] pathForResource:fontName ofType:@"otf"];
    if (!fontPath || fontPath.length == 0) {
        fontPath = [[NSBundle bundleForClass:[VLDFontManager class]] pathForResource:fontName ofType:@"ttf"];
    }
    NSData *fontData = [NSData dataWithContentsOfFile:fontPath];
    
    CGDataProviderRef provider = CGDataProviderCreateWithCFData((CFDataRef)fontData);
    
    if (provider)
    {
        CGFontRef font = CGFontCreateWithDataProvider(provider);
        
        if (font)
        {
            CFErrorRef error = NULL;
            if (CTFontManagerRegisterGraphicsFont(font, &error) == NO)
            {
                CFStringRef errorDescription = CFErrorCopyDescription(error);
                NSLog(@"Failed to load font: %@", errorDescription);
                CFRelease(errorDescription);
            }
            
            CFRelease(font);
        }
        
        CFRelease(provider);
    }
}

@end
