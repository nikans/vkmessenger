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

@property (strong, nonatomic) NSNumber *messageId;
@property (strong, nonatomic) NSNumber *flags;
@property (nonatomic) dialogType type;
@property (strong, nonatomic) NSNumber *chatId;
@property (strong, nonatomic) NSNumber *userId;
@property (strong, nonatomic) NSDate *date;
@property (strong, nonatomic) NSString *text;
@property (strong, nonatomic) NSString *subject;
@property (strong, nonatomic) LVKMessage *message;
@property (strong, nonatomic) LVKDialog *dialog;

@end
