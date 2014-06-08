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

@property (nonatomic) NSNumber *messageId;
@property (nonatomic) NSNumber *mask;
@property (nonatomic) BOOL isUnread;
@property (nonatomic) NSNumber *chatId;

@end
