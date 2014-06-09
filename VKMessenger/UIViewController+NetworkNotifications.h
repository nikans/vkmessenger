//
//  UIViewController+NetworkNotifications.h
//  VKMessenger
//
//  Created by Leonid Repin on 09.06.14.
//  Copyright (c) 2014 Levelab. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIViewController (NetworkNotifications)

- (void)networkFailed;
- (void)networkRestored;

@end
