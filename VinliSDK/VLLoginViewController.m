//
//  VLLoginViewController.m
//  VinliSDK
//
//  Created by Tommy Brown on 5/27/15.
//  Copyright (c) 2015 Vinli. All rights reserved.
//

#import "VLLoginViewController.h"

#define DEFAULT_HOST @".vin.li" 
static NSString * const kVinliSignUpRequest = @"/#/sign-up";

@interface VLLoginViewController ()
{
    UIWebView *webView;
}

@property (strong, nonatomic) NSString* vinliSignUpRequestURLStr;

@end

@implementation VLLoginViewController

#pragma mark - Initializers

- (instancetype)initWithClientId:(NSString *)clientId redirectUri:(NSString *)redirectUri
{
    if(self = [super init])
    {
        self.clientId = clientId;
        self.redirectUri = redirectUri;
        self.host = DEFAULT_HOST;
    }
    return self;
}

- (instancetype)initWithClientId:(NSString *)clientId redirectUri:(NSString *)redirectUri host:(NSString *)host
{
    if(self = [super init])
    {
        self.clientId = clientId;
        self.redirectUri = redirectUri;
        self.host = host;
    }
    return self;
}

#pragma mark - View Controller Lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    if(self.host == nil || self.host.length == 0)
    {
        self.host = DEFAULT_HOST;
    }
    
    self.vinliSignUpRequestURLStr = [NSString stringWithFormat:@"https://my%@%@", self.host, kVinliSignUpRequest];
    
    webView = [[UIWebView alloc] init];
    webView.translatesAutoresizingMaskIntoConstraints = NO;
    webView.delegate = self;
    [self.view addSubview:webView];
    
    NSDictionary *bindings = NSDictionaryOfVariableBindings(webView);
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[webView]-0-|" options:0 metrics:nil views:bindings]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[webView]-0-|" options:0 metrics:nil views:bindings]];
    
    NSString *responseType = @"token";
    
    NSString *oauthEndpoint = [NSString stringWithFormat:@"https://my%@/oauth/authorization/new", self.host];
    
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@?client_id=%@&redirect_uri=%@&response_type=%@&locale=%@", oauthEndpoint, self.clientId, self.redirectUri, responseType, [NSLocale preferredLanguages].firstObject ?: @"en"]];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [webView loadRequest:request];
}

#pragma  mark - Actions

- (void)onLoginViewControllerCancelButton:(id)sender
{
    if ([self.delegate respondsToSelector:@selector(vlLoginViewControllerDidCancelLogin:)])
    {
        [self.delegate vlLoginViewControllerDidCancelLogin:self];
    }
}

#pragma mark - UIWebViewDelegate methods

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType{
    
    NSString *requestString = request.URL.absoluteString;
   // NSLog(@"request = %@", requestString);
    
    if([requestString hasPrefix:self.redirectUri.lowercaseString]){
        
        NSArray *parts = [requestString componentsSeparatedByString:@"#"];
        
        if(parts.count == 2){
            
            NSString *query = parts[1];
            
            NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
            for (NSString *param in [query componentsSeparatedByString:@"&"]){
                NSArray *elements = [param componentsSeparatedByString:@"="];
                if([elements count] < 2) {
                    continue;
                }
                [params setObject:[elements objectAtIndex:1] forKey:[elements objectAtIndex:0]];
            }
            
            if(params[@"access_token"]){
                VLSession *session = [[VLSession alloc] initWithAccessToken:params[@"access_token"]];
                if (self.delegate && [self.delegate respondsToSelector:@selector(vlLoginViewController:didLoginWithSession:)])
                {
                    
                    [self.delegate vlLoginViewController:self didLoginWithSession:session];
                }
            }
            else
            {
                if (self.delegate && [self.delegate respondsToSelector:@selector(vlLoginViewController:didFailToLoginWithError:)])
                {
                    [self.delegate vlLoginViewController:self didFailToLoginWithError:nil];
                }
            }
        }
        else
        {
            if (self.delegate && [self.delegate respondsToSelector:@selector(vlLoginViewController:didFailToLoginWithError:)])
            {
                [self.delegate vlLoginViewController:self didFailToLoginWithError:nil];
            }
        }
        
        return NO;
    }
    
    if ([requestString isEqualToString:self.vinliSignUpRequestURLStr])
    {
        [[UIApplication sharedApplication] openURL:request.URL];
        return NO;
    }
    
    return YES;
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    [self.delegate vlLoginViewController:self didFailToLoginWithError:error];
}

@end
