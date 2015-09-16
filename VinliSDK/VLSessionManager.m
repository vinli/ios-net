//
//  VLSessionManager.m
//  test3
//
//  Created by Andrew Wells on 8/4/15.
//  Copyright (c) 2015 Andrew Wells. All rights reserved.
//

#import "VLSessionManager.h"
#import "VLUrlParser.h"
#import <UIKit/UIKit.h>

#import "VLUserCache.h"
#import <VinliNet/VinliSDK.h>

static NSString * VLSessionManagerClientIdDemo = @"3d0de990-6491-47cf-afda-e6855e7cd1c8";
static NSString * VLSessionManagerClientIdDev = @"f06e03c5-dcb8-4d69-b060-29e39dd98512";
static NSString * VLSessionManagerClientIdProd = @"fed505a9-021c-49b2-9cc9-576e9766b9de";

static NSString * VLSessionManagerHostDemo = @"-demo.vin.li";
static NSString * VLSessionManagerHostDev = @"-dev.vin.li";

static NSString * VLSessionManagerCachedSessionsKey = @"VLSessionManagerCachedSessionsKey";


@interface VLSessionManager ()
@property (strong, nonatomic) VLUrlParser *urlParser;
@property (copy, nonatomic) AuthenticationCompletion authenticationCompletionBlock;

@property (strong, nonatomic) VLService* service;
@property (strong, nonatomic) VLSession* currentSession;
@property (strong, nonatomic) NSDictionary* cachedSessions;
@end

@implementation VLSessionManager

#pragma mark - Accessors and Mutators

- (void)setClientId:(NSString *)clientId
{
    _clientId = clientId;
    self.urlParser.clientId = clientId;
}

- (void)setRedirectUri:(NSString *)redirectUri
{
    _redirectUri = redirectUri;
    self.urlParser.redirectUri = redirectUri;
}

- (VLService *)service
{
    if (!_service)
    {
        _service = [[VLService alloc] init];
#if VLSESSIONMANAGER_USE_DEV_HOST
        _service.host = VLSessionManagerHostDev;
#endif
    }
    return _service;
}

- (VLSession *)currentSession
{
    return _service.session;
}

#pragma mark - Initialization

+ (id)sharedManager {
    static VLSessionManager *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[self alloc] init];
    });
    return instance;
}

- (instancetype)init
{
    if (self = [super init])
    {
        self.urlParser = [[VLUrlParser alloc] init];
        self.cachedSessions = [[NSUserDefaults standardUserDefaults] objectForKey:VLSessionManagerCachedSessionsKey];
    }
    return self;
}

#pragma mark - Session Management

- (void)cacheSession:(VLSession *)session
{
    if (!session) {
        return;
    }
    
    @synchronized(self.cachedSessions)
    {
        NSMutableDictionary* mutableSessionsCache = [self.cachedSessions mutableCopy];
        if (!mutableSessionsCache)
        {
            mutableSessionsCache = [NSMutableDictionary new];
        }
        
        NSData *encodedSession = [NSKeyedArchiver archivedDataWithRootObject:session];
        [mutableSessionsCache setObject:encodedSession forKey:session.userId];
        self.cachedSessions = [mutableSessionsCache copy];
        
        [[NSUserDefaults standardUserDefaults] setObject:self.cachedSessions forKey:VLSessionManagerCachedSessionsKey];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
}

- (void)handleCustomURL:(NSURL *)url
{
    // TODO: Do we still need VLUserCache
    VLUserCache* userCache = [self.urlParser parseUrl:url];
    
    // PUMPKIN
    if (!userCache) {
        return;
    }
     [userCache save];
    
    [self.service useSession:[[VLSession alloc] initWithAccessToken:userCache.accessToken userId:userCache.userId]];
    [self cacheSession:self.currentSession];
    
    if (self.authenticationCompletionBlock)
    {
        self.authenticationCompletionBlock(self.currentSession, nil);
        self.authenticationCompletionBlock = nil;
    }
    
}

- (void)callMyVinliAppWithUserId:(NSString *)userId
{
    // TODO: Add delegate methods here to ask client if we should do this
    NSURL* url;
#if VLSESSIONMANAGER_USE_DEV_HOST
    url = [self.urlParser buildUrlWithUserId:userId host:VLSessionManagerHostDev];
#else
   url = [self.urlParser buildUrlWithUserId:userId];
#endif
    
    if (![[UIApplication sharedApplication] openURL:url])
    {
        UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"Error"
                                                                       message:@"You must download the MyVinli app to continue."
                                                                preferredStyle:UIAlertControllerStyleAlert];
        
        
        UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"Go to AppStore"
                                                                style:UIAlertActionStyleDefault
                                                              handler:^(UIAlertAction * action) {
                                                                  NSString *iTunesLink = @"itms://itunes.apple.com/us/app/apple-store/id375380948?mt=8";
                                                                  [[UIApplication sharedApplication] openURL:[NSURL URLWithString:iTunesLink]];
                                                              }];
        
        [alert addAction:defaultAction];
        
        UIAlertAction* cancelAction = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel
                                                             handler:^(UIAlertAction *action) {
                                                                 [alert removeFromParentViewController];
                                                             }];
        [alert addAction:cancelAction];
        
        [[[UIApplication sharedApplication].windows[0] rootViewController] presentViewController:alert animated:YES completion:nil];
        
    }

}

- (void)getSessionForUserWithId:(NSString *)userId completion:(AuthenticationCompletion)onCompletion
{
    // Check if current session user matches userid
    if ([self.currentSession.userId isEqualToString:userId])
    {
        // TODO: validate token
        if (onCompletion) { onCompletion (self.currentSession, nil); }
        return;
    }
    
    // Check user session in the cache
    if (self.cachedSessions.count > 0)
    {
        VLSession* cachedSession = (VLSession *)[NSKeyedUnarchiver unarchiveObjectWithData:[self.cachedSessions objectForKey:userId]];
        if (cachedSession)
        {
            // validate token
            [self.service useSession:cachedSession];
            if (onCompletion) { onCompletion(self.currentSession, nil) ; }
            return;
        }

    }
    
    // Call MyVinli to authenticate
    self.authenticationCompletionBlock = onCompletion;
    [self callMyVinliAppWithUserId:userId];
    
}

- (void)loginWithCompletion:(AuthenticationCompletion)onCompletion
{
    UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"Choose User"
                                                                   message:@""
                                                            preferredStyle:UIAlertControllerStyleAlert];
    
    
    UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"New User"
                                                            style:UIAlertActionStyleCancel
                                                          handler:^(UIAlertAction * action) {
                                                              [self loginWithUserId:nil withCompletion:onCompletion];
                                                          }];
    
    [alert addAction:defaultAction];

    
    [[VLUserCache getUsersCache].allValues enumerateObjectsUsingBlock:^(VLUserCache* userCache, NSUInteger idx, BOOL *stop) {
        
        if (!userCache.user.firstName) {
            return;
        }
        
        UIAlertAction* action = [UIAlertAction actionWithTitle:userCache.user.firstName style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
            [self loginWithUserId:userCache.user.userId withCompletion:onCompletion];
        }];
        [alert addAction:action];
    }];
    
    
    
    [[[UIApplication sharedApplication].windows[0] rootViewController] presentViewController:alert animated:YES completion:nil];
}

- (void)loginWithUserId:(NSString *)userId withCompletion:(AuthenticationCompletion)onCompletion
{
    [self getSessionForUserWithId:userId completion:^(VLSession *session, NSError *error) {
        
        if (onCompletion)
        {
            onCompletion(session, error);
        }
        
        if (!error)
        {
            if ([VLUserCache getUserWithId:userId].user) {
                ;
            }
            
            [self.service getUserOnSuccess:^(VLUser *user, NSHTTPURLResponse *response) {
                
                VLUserCache* userCache = [[VLUserCache alloc] initWithUser:user];
                userCache.userId = user.userId;
                userCache.accessToken = session.accessToken;
                [userCache save];
                
            } onFailure:^(NSError *error, NSHTTPURLResponse *response, NSString *bodyString) {
                NSLog(@"Failure retrieving user data after login");
            }];
        }
    }];
    
}




@end
