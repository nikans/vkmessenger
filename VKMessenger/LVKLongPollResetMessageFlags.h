//
//  LVKLongPollResetMessageFlags.h
//  VKMessenger
//
//  Created by Leonid Repin on 06.06.14.
//  Copyright (c) 2014 Levelab. All rights reserved.
//

#import "LVKLongPollUpdate.h"
#import "LVKMessage.h"

@interface LVKLongPollResetMessageFlags : LVKLongPollUpdate

@property (strong, nonatomic) NSNumber *messageId;
@property (strong, nonatomic) NSNumber *mask;
@property (nonatomic) BOOL isUnread;
@property (strong, nonatomic) NSNumber *chatId;

@end
