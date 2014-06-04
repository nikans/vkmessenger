//
//  LVKLongPollNewMessage.h
//  VKMessenger
//
//  Created by Leonid Repin on 04.06.14.
//  Copyright (c) 2014 Levelab. All rights reserved.
//

#import "LVKLongPollUpdate.h"
#import "LVKDialog.h"

@interface LVKLongPollNewMessage : LVKLongPollUpdate

@property (nonatomic) NSNumber *messageId;
@property (nonatomic) NSNumber *flags;
@property (nonatomic) dialogType type;
@property (nonatomic) NSNumber *chatId;
@property (nonatomic) NSNumber *userId;
@property (nonatomic) NSDate *date;
@property (nonatomic) NSString *text;
@property (nonatomic) NSString *subject;
@property (nonatomic) LVKMessage *message;
@property (nonatomic) LVKDialog *dialog;

@end
