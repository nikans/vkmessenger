//
//  UIViewController+NetworkNotifications.m
//  VKMessenger
//
//  Created by Leonid Repin on 09.06.14.
//  Copyright (c) 2014 Levelab. All rights reserved.
//

#import "UIViewController+NetworkNotifications.h"

@implementation UIViewController (NetworkNotifications)

- (void)networkFailed
{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"networkFailed" object:self];
}

- (void)networkRestored
{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"networkRestored" object:self];
}

@end
