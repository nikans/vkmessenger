//
//  LVKAppDelegate.h
//  VKMessenger
//
//  Created by Leonid Repin on 03.06.14.
//  Copyright (c) 2014 Levelab. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <VKSdk.h>
#import "LVKLongPollUpdatesCollection.h"
#import "LVKUser.h"

@interface LVKAppDelegate : UIResponder <UIApplicationDelegate, VKSdkDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) LVKUser *currentUser;

- (void)authorize;

- (void)presentViewController:(UIViewController *)controller;

@end
