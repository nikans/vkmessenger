//
//  LVKBubbleActionsDelegate.h
//  VKMessenger
//
//  Created by Eliah Nikans on 6/11/14.
//  Copyright (c) 2014 Levelab. All rights reserved.
//

#import <Foundation/Foundation.h>

@class LVKDefaultMessageTableViewCell;

@protocol LVKBubbleActionsDelegate <NSObject>

// TODO: protocol
- (void)pushToMessageVC:(UITapGestureRecognizer *)tapGesture;
- (void)resendMessage:(UITapGestureRecognizer *)tapGesture;

@end
