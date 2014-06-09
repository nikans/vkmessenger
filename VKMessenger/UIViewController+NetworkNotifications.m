//
//  UIViewController+NetworkNotifications.m
//  VKMessenger
//
//  Created by Leonid Repin on 09.06.14.
//  Copyright (c) 2014 Levelab. All rights reserved.
//

#import <objc/runtime.h>
#import "UIViewController+NetworkNotifications.h"
#import "LVKNetworkRetryAlertDelegate.h"

static void *AlertViewDelegatePropertyKey = &AlertViewDelegatePropertyKey;

@implementation UIViewController (NetworkNotifications)

- (void)networkFailedRequest:(id)request
{
    self.alertViewDelegate = [[LVKNetworkRetryAlertDelegate alloc] initWithRequest:request];
    UIAlertView *message = [[UIAlertView alloc] initWithTitle:@"Network unreachable"
                                                      message:@"Oops! We're unable to reach vk.com servers ATM. Would you like to retry?"
                                                     delegate:self.alertViewDelegate
                                            cancelButtonTitle:@"Cancel"
                                            otherButtonTitles:@"Retry", nil];
    
    [message show];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"networkFailed" object:request];
}

- (void)setAlertViewDelegate:(id<UIAlertViewDelegate>)alertViewDelegate
{
    objc_setAssociatedObject(self, AlertViewDelegatePropertyKey, alertViewDelegate, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (id<UIAlertViewDelegate>)alertViewDelegate
{
    return objc_getAssociatedObject(self, AlertViewDelegatePropertyKey);
}

- (void)networkRestored
{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"networkRestored" object:nil];
}

@end
