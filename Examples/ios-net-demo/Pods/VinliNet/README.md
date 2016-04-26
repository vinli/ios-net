# Vinli Net SDK

A framework for accessing Vinli services.

##Documentation

http://cocoadocs.org/docsets/VinliNet

##OAuth Quick Start Guide

https://gist.github.com/JaiGhanekar/1ce8d396cedd18b819d3

##Installation

Install With CocoaPods

```objective-c
pod 'VinliNet'
```
Install manually, go to your project's General tab and add the VinliSDK.framework file as an Embedded Binary

##Usage
Create a VLLoginViewController object and assign it your Client ID and Redirect URI.
```objective-c
VLLoginViewController *viewController = [[VLLoginViewController alloc] init];
viewController.clientId = @"96e9f8e4-0cqq-4528-9040-956e9edz446a";
viewController.redirectUri = @"myApp://";
viewController.delegate = self;
```
Then present the view controller. The VLLoginViewController will dismiss itself and call the function below once the user has authenticated:
```objective-c
- (void) vlLoginViewController:(VLLoginViewController *)loginController didLoginWithSession:(VLSession *)session
```
Once the user has a valid VLSession, create a VLService:
```objective-c
VLService *vlService = [[VLService alloc] init];
[vlService useSession:session];
```
Use VLService to interact with the Vinli services:
```objective-c
[vlService getDevicesOnSuccess:^(VLDevicePager *devicePager, NSHTTPURLResponse *response) {

    } onFailure:^(NSError *error, NSHTTPURLResponse *response, NSString *bodyString) {
        
    }];
```
