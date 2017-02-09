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

@interface VLLoginViewController (){
    UIWebView *webView;
}

@property (strong, nonatomic) NSString* vinliSignUpRequestURLStr;

@end

@implementation VLLoginViewController

- (id) initWithClientId:(NSString *)clientId redirectUri:(NSString *)redirectUri{
    self = [super init];
    if(self){
        _clientId = clientId;
        _redirectUri = redirectUri;
        _host = DEFAULT_HOST;
    }
    return self;
}

- (id) initWithClientId:(NSString *)clientId redirectUri:(NSString *)redirectUri host:(NSString *)host{
    self = [super init];
    if(self){
        _clientId = clientId;
        _redirectUri = redirectUri;
        _host = host;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
//    self.title = @"Login to Vinli";
//    
//    if (self.navigationController)
//    {
//        UIButton* cancelBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 60, self.navigationController.navigationBar.frame.size.height)];
//        [cancelBtn setTitle:@"Cancel" forState:UIControlStateNormal];
//        [cancelBtn.titleLabel setFont:[UIFont boldSystemFontOfSize:14]];
//        [cancelBtn setTitleColor:[UIColor colorWithRed:36.0f/255.0f green:167.0f/255.0f blue:223.0f/255.0f alpha:1] forState:UIControlStateNormal];
//        [cancelBtn addTarget:self action:@selector(onLoginViewControllerCancelButton:) forControlEvents:UIControlEventTouchUpInside];
//        [self.navigationController.navigationBar addSubview:cancelBtn];
//    }
    
    
    if(_host == nil || _host.length == 0){
        _host = DEFAULT_HOST;
    }
    
    self.vinliSignUpRequestURLStr = [NSString stringWithFormat:@"https://my%@%@", _host, kVinliSignUpRequest];
    
    
    webView = [[UIWebView alloc] init];
    webView.translatesAutoresizingMaskIntoConstraints = NO;
    webView.delegate = self;
    [self.view addSubview:webView];
    
    NSDictionary *bindings = NSDictionaryOfVariableBindings(webView);
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[webView]-0-|" options:0 metrics:nil views:bindings]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[webView]-0-|" options:0 metrics:nil views:bindings]];
    
    NSString *responseType = @"token";
    
    NSString *oauthEndpoint = [NSString stringWithFormat:@"https://my%@/oauth/authorization/new", _host];
    
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@?client_id=%@&redirect_uri=%@&response_type=%@&lang=%@", oauthEndpoint, _clientId, _redirectUri, responseType, [NSLocale preferredLanguages].firstObject ?: @"en"]];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [webView loadRequest:request];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)onLoginViewControllerCancelButton:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - UIWebViewDelegate methods

- (BOOL) webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType{
    
    NSString *requestString = request.URL.absoluteString;
   // NSLog(@"request = %@", requestString);
    
    if([requestString hasPrefix:_redirectUri.lowercaseString]){
        
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
                if(_delegate && [_delegate respondsToSelector:@selector(vlLoginViewController:didLoginWithSession:)]){
                    
                    [_delegate vlLoginViewController:self didLoginWithSession:session];
                }
            }
            else{
                if(_delegate && [_delegate respondsToSelector:@selector(vlLoginViewController:didFailToLoginWithError:)]){
                    [_delegate vlLoginViewController:self didFailToLoginWithError:nil];
                }
            }
        } else{
            if(_delegate && [_delegate respondsToSelector:@selector(vlLoginViewController:didFailToLoginWithError:)]){
                [_delegate vlLoginViewController:self didFailToLoginWithError:nil];
            }
        }
        
        [self dismissViewControllerAnimated:YES completion:nil];
        return NO;
    }
    else
    if ([requestString isEqualToString:self.vinliSignUpRequestURLStr])
    {
        [[UIApplication sharedApplication] openURL:request.URL];
        return NO;
    }
    
    return YES;
}

- (void) webViewDidStartLoad:(UIWebView *)webView{
    
}

- (void) webViewDidFinishLoad:(UIWebView *)webView{
    
}

- (void) webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error{
    
}

@end
