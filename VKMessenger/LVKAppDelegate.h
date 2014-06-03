//
//  LVKAppDelegate.h
//  VKMessenger
//
//  Created by Leonid Repin on 03.06.14.
//  Copyright (c) 2014 Levelab. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <VKSdk.h>

@interface LVKAppDelegate : UIResponder <UIApplicationDelegate, VKSdkDelegate>

@property (strong, nonatomic) UIWindow *window;

@end
