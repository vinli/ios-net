//
//  VLLoginButton.m
//  VinliSDK
//
//  Created by Tommy Brown on 6/10/15.
//  Copyright (c) 2015 Vinli. All rights reserved.
//

#import "VLLoginButton.h"
#import "VLLoginViewController.h"
#import "VLSessionManager.h"
@import CoreText;


@interface VLLoginButton ()
@property (strong, nonatomic) UINavigationController *navController;
@property (weak, nonatomic) VLSession *currentSession;
@end


@implementation VLLoginButton

- (id) init{
    self = [super init];
    if(self){
        [self initialize];

        
    }
    return self;
}

- (id) initWithCoder:(NSCoder *)aDecoder{
    self = [super initWithCoder:aDecoder];
    if(self){
        [self initialize];
    }
    return self;
}

- (id) initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if(self){
        [self initialize];
    }
    return self;
}



- (IBAction)logout:(id)sender {
    BOOL hasLoggedOut = [VLSession exitSession];
    if (hasLoggedOut) {
    if (_delegate && [_delegate respondsToSelector:@selector(didButtonLogout)]) {
            [_delegate didButtonLogout];
        }
    } else if (_delegate && [_delegate respondsToSelector:@selector(didButtonFailToLogout:)]) {
        [_delegate didButtonFailToLogout:nil];
    }


}



//font methods




- (UIFont *)fontWithSize:(NSString *)fontString size:(CGFloat)size
{
    NSString *fontName = fontString;
    UIFont *font = [UIFont fontWithName:fontName size:size];
    if (!font) {
        [self  dynamicallyLoadFontNamed:fontName];
        font = [UIFont fontWithName:fontName size:size];
        
        // safe fallback
        if (!font) {
            NSLog(@"Failed to load font. Falling back to system font!");
            font = [UIFont systemFontOfSize:size];
        }
    }
    
    return font;
}



- (void)dynamicallyLoadFontNamed:(NSString *)name
{
    NSString *resourceName = [NSString stringWithFormat:@"%@", name];
    
    NSString *bundlePath = [[NSBundle bundleForClass:[self class]]
                            pathForResource:@"VinliSDK" ofType:@"bundle"];
    
    
    NSBundle *bundle = [NSBundle bundleWithPath:bundlePath];
    [bundle load];
    
    if (!bundle) {
        bundle = [NSBundle mainBundle];
    }
    
    
    
    NSURL *url = [bundle URLForResource:resourceName withExtension:@"ttf"];
    NSData *fontData = [NSData dataWithContentsOfURL:url];
    if (fontData) {
        CFErrorRef error;
        CGDataProviderRef provider = CGDataProviderCreateWithCFData((CFDataRef)fontData);
        CGFontRef font = CGFontCreateWithDataProvider(provider);
        if (!CTFontManagerRegisterGraphicsFont(font, &error)) {
            CFStringRef errorDescription = CFErrorCopyDescription(error);
            NSLog(@"Failed to create font: %@", errorDescription);
            CFRelease(errorDescription);
        }
        CFRelease(font);
        CFRelease(provider);
    }
}








- (UIImage *)imageFromBundle:(NSString *)imageName bundleName:(NSString *)bundleName {
    NSBundle *podBundle = [NSBundle bundleForClass:[self classForCoder]];
    
    NSURL *bundleURL = [podBundle URLForResource:bundleName withExtension:@"bundle"];
    
    if (bundleURL) {
        NSBundle *bundle = [NSBundle bundleWithURL:bundleURL];
        if (bundle) {
            return [UIImage imageNamed:imageName inBundle:bundle compatibleWithTraitCollection:nil];
        }
    }
        return nil;

}



- (IBAction)login:(id)sender {
  
    //check reference
    if (_navController) {
        [[[UIApplication sharedApplication].windows[0] rootViewController] presentViewController:_navController animated:YES completion:nil];
    } else {
        _navController = [[UINavigationController alloc] initWithRootViewController:self.loginViewController];
        [[[UIApplication sharedApplication].windows[0] rootViewController] presentViewController:_navController animated:YES completion:nil];
    }
    

    
}


//abstract this color setting

- (void)setHighlighted:(BOOL)highlighted {
   
    [super setHighlighted:highlighted];
    
    if (highlighted) {
        super.titleLabel.alpha = 1.0; //prevents highlight of textlabel
        [[super imageView] setAlpha:1.0];
        [super setBackgroundColor:[[UIColor alloc]initWithRed:32/255.0f green:149/255.0f blue:200/255.0f alpha:1]];
        

    } else {
        [super setBackgroundColor:[[UIColor alloc]initWithRed:0/255.0f green:163.0f/255.0f blue:224.0f/255.0f alpha:1]];
       
    }
}


- (void)setSelected:(BOOL)selected {
    
    [super setSelected:selected];

    if (selected) {
        super.titleLabel.alpha = 1.0; //prevents highlight of textlabel
        NSLog(@"Selected!");
        [[self imageView] setAlpha:1.0];
        [super setBackgroundColor:[[UIColor alloc]initWithRed:32/255.0f green:149/255.0f blue:200/255.0f alpha:1]];
        

    } else {
        [super setBackgroundColor:[[UIColor alloc]initWithRed:0/255.0f green:163.0f/255.0f blue:224.0f/255.0f alpha:1]];
        
    }
    
}


//keep properties when pressed down
- (IBAction)pressedDown:(id)sender {
    self.titleLabel.alpha = 1.0;
    [self setHighlighted:YES]; //set highlighted when touched down
    
}




- (void) initialize {
    
    self.currentSession = [VLSession currentSession];
    self.adjustsImageWhenHighlighted = NO; //prevents highlight change
    [[self titleLabel] setFont:[self fontWithSize:@"OpenSans" size:20.0f]];
    [super layer].cornerRadius = 5;
    [self addTarget:self action:@selector(pressedDown:) forControlEvents:UIControlEventTouchDown];
    [super setBackgroundColor:[[UIColor alloc]initWithRed:0/255.0f green:163.0f/255.0f blue:224.0f/255.0f alpha:1]];
    [super setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal & UIControlStateSelected & UIControlStateHighlighted];
    self.loginViewController.delegate = self;
    
    if (self.currentSession) {
        [super setTitle:@"Sign Out Of Vinli" forState:UIControlStateNormal & UIControlStateSelected & UIControlStateHighlighted];
        [self addTarget:self action:@selector(logout:) forControlEvents:UIControlEventTouchUpInside];
        
       
        
        
    } else {
        self.currentSession = nil; //set this to nil
        [super setTitle:@"Sign In With Vinli" forState:UIControlStateNormal & UIControlStateHighlighted & UIControlStateSelected];
        
       //customize the button
        UIImage *btnImage = [self imageFromBundle:@"vinli_icon.png" bundleName:@"VinliSDK"];
        btnImage = [btnImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        [self setImage:btnImage forState:UIControlStateNormal & UIControlStateHighlighted & UIControlStateSelected];
        //[[self imageView] setFrame:CGRectMake(self.imageView.frame.origin.x, self.imageView.frame.origin.y - 30, self.imageView.frame.size.width, self.imageView.frame.size.width)];
        [super setImageEdgeInsets:UIEdgeInsetsMake(0, (btnImage.size.width / 2) - 45, 0, 0)];
        [super setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        
        
        [self addTarget:self action:@selector(login:) forControlEvents:UIControlEventTouchUpInside];
        self.clipsToBounds = YES;
        self.loginViewController = [[VLLoginViewController alloc] initWithClientId:[VLSessionManager sharedManager].clientId redirectUri:[VLSessionManager sharedManager].redirectUri]; //instantiate login view controller and
        
    }
    
    
}


//pass the delegates through 
- (void) vlLoginViewController:(VLLoginViewController *)loginController didLoginWithSession:(VLSession *) session {
    if (_delegate && [_delegate respondsToSelector:@selector(didButtonLogin:session:)]) {
        [_delegate didButtonLogin:self.loginViewController session:session];
    }
    
}



- (void) vlLoginViewController:(VLLoginViewController *)loginController didFailToLoginWithError:(NSError *) error {
    if (_delegate && [_delegate respondsToSelector:@selector(didButtonFailLogin:error:)]) {
        [_delegate didButtonFailLogin:self.loginViewController error:error];
    }
}






#pragma mark - Override super methods





- (void) setTitle:(NSString *)title forState:(UIControlState)state {}

- (void) setTitleColor:(UIColor *)color forState:(UIControlState)state {};

- (void) setBackgroundColor:(UIColor *)backgroundColor{}

- (void) setBackgroundImage:(UIImage *)image forState:(UIControlState)state{}

@end