//
//  LVKAppDelegate.m
//  VKMessenger
//
//  Created by Leonid Repin on 03.06.14.
//  Copyright (c) 2014 Levelab. All rights reserved.
//

#import "LVKAppDelegate.h"

@implementation LVKAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Override point for customization after application launch.
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
        UISplitViewController *splitViewController = (UISplitViewController *)self.window.rootViewController;
        UINavigationController *navigationController = [splitViewController.viewControllers lastObject];
        splitViewController.delegate = (id)navigationController.topViewController;
    }
    
    [VKSdk initializeWithDelegate:self andAppId:@"4395508"];
    if ([VKSdk wakeUpSession])
    {
        NSLog(@"Start working");
        
        [self setup];
    }
    else
    {
        NSLog(@"Show auth");
        
        NSArray *scope = [NSArray arrayWithObjects:@"friends", @"messages", @"notify", nil];
        
        [VKSdk authorize:scope];
    }
    
    return YES;
}

- (void)application:(UIApplication*)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData*)deviceToken
{
    VKRequest *registerDeviceRequest = [VKApi requestWithMethod:@"account.registerDevice" andParameters:[NSDictionary dictionaryWithObjectsAndKeys:deviceToken, @"token", @"msg", @"subscribe", nil] andHttpMethod:@"POST"];
    [registerDeviceRequest executeWithResultBlock:^(VKResponse *response) {
        NSLog(@"Successfully registered %@", deviceToken);
    } errorBlock:^(NSError *error) {
        NSLog(@"%@", error);
    }];
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

-(BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
{
    [VKSdk processOpenURL:url fromApplication:sourceApplication];
    return YES;
}

- (void)setup
{
    [self setupLongPolling];
}

- (void)pollServerWithOptions:(NSMutableDictionary *)options//:(NSString *)server withKey:(NSString *)key fromTs:(NSNumber *)ts
{
    NSError* error = nil;
    NSURLResponse* response = nil;
    NSURL* requestUrl = [NSURL URLWithString:[NSString stringWithFormat:
                                              @"http://%@?act=a_check&key=%@&ts=%@&wait=25&mode=2",
                                              [options objectForKey:@"server"],
                                              [options objectForKey:@"key"],
                                              [options objectForKey:@"ts"]
                                              ]];
    NSURLRequest* request = [NSURLRequest requestWithURL:requestUrl];
    
    NSData* responseData = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
    
    NSDictionary *jsonResponse = [NSJSONSerialization JSONObjectWithData:responseData options:nil error:nil];
    
    
    if([jsonResponse objectForKey:@"failed"] != nil)
    {
        [self performSelectorOnMainThread:@selector(setupLongPolling) withObject:nil waitUntilDone:NO];
        return;
    }
    
    if([jsonResponse objectForKey:@"updates"] != nil)
    {
        LVKLongPollUpdatesCollection *updates = [[LVKLongPollUpdatesCollection alloc] initWithArray:[jsonResponse objectForKey:@"updates"]];
    }
    
    [options setObject:[jsonResponse objectForKey:@"ts"] forKey:@"ts"];
    
    [self pollServerWithOptions:options];
}

- (void)setupLongPolling
{
    if([VKSdk isLoggedIn])
    {
        VKRequest *longPollServerRequest = [VKApi requestWithMethod:@"messages.getLongPollServer" andParameters:nil andHttpMethod:@"GET"];
        
        [longPollServerRequest executeWithResultBlock:^(VKResponse *response) {
            NSString *key = [response.json objectForKey:@"key"];
            NSString *server = [response.json objectForKey:@"server"];
            NSNumber *ts = [response.json objectForKey:@"ts"];
            
            NSMutableDictionary *options = [NSMutableDictionary dictionaryWithObjectsAndKeys:key, @"key", server, @"server", ts, @"ts", nil];
            
            [self performSelectorInBackground:@selector(pollServerWithOptions:) withObject:options];
        } errorBlock:^(NSError *error) {
            NSLog(@"%@", error);
        }];
    }
}

- (void)vkSdkNeedCaptchaEnter:(VKError *)captchaError
{
    
}

/**
 Notifies delegate about existing token has expired
 @param expiredToken old token that has expired
 */
- (void)vkSdkTokenHasExpired:(VKAccessToken *)expiredToken
{
    NSLog(@"Token has expired");
}

/**
 Notifies delegate about user authorization cancelation
 @param authorizationError error that describes authorization error
 */
- (void)vkSdkUserDeniedAccess:(VKError *)authorizationError
{
    NSLog(@"User denied access");
}

/**
 Pass view controller that should be presented to user. Usually, it's an authorization window
 @param controller view controller that must be shown to user
 */
- (void)vkSdkShouldPresentViewController:(UIViewController *)controller
{
    [[self window] addSubview:controller.view];
    [[self window] makeKeyAndVisible];
    [[[self window] rootViewController] presentViewController:controller animated:true completion:NULL];
    
}

/**
 Notifies delegate about receiving new access token
 @param newToken new token for API requests
 */
- (void)vkSdkReceivedNewToken:(VKAccessToken *)newToken
{
    NSLog(@"Recieved new token");
    
    [[UIApplication sharedApplication] registerForRemoteNotificationTypes: (UIRemoteNotificationTypeBadge|UIRemoteNotificationTypeSound|UIRemoteNotificationTypeAlert)];
    
    [self setup];
}

@end
