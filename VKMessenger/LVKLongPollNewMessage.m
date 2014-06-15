//
//  LVKLongPollNewMessage.m
//  VKMessenger
//
//  Created by Leonid Repin on 04.06.14.
//  Copyright (c) 2014 Levelab. All rights reserved.
//

#import <VKSdk.h>
#import "LVKLongPollNewMessage.h"

@implementation LVKLongPollNewMessage

@synthesize message, dialog, messageId, flags, type, chatId, userId, date, text, subject;

-(NSArray *)prepareNotifications
{
    return [NSArray arrayWithObject:[NSNotification notificationWithName:@"newMessage" object:self]];
}

-(void)mapArrayToProperties:(NSArray *)array
{
    messageId = [array objectAtIndex:0];
    flags = [array objectAtIndex:1];
    
    BOOL isOutbox = [flags intValue] & MESSAGE_OUTBOX;
    BOOL isUnread = [flags intValue] & MESSAGE_UNREAD;
    
    userId = [NSNumber numberWithInt:[[(NSDictionary *)[array objectAtIndex:6] objectForKey:@"from"] intValue]];
        
    if([userId intValue] == 0)
    {
        userId = isOutbox ? [NSNumber numberWithInt:[[[VKSdk getAccessToken] userId] intValue]] : [array objectAtIndex:2];
        chatId = [array objectAtIndex:2];
        type = Dialog;
    }
    else
    {
        int tmpChatId = [[array objectAtIndex:2] intValue];
        
        if(tmpChatId > 2000000000) tmpChatId = tmpChatId - 2000000000;
        
        chatId = [NSNumber numberWithInt:tmpChatId];
        type = Room;
    }
    
    date = [[NSDate alloc] initWithTimeIntervalSince1970:[[array objectAtIndex:3] doubleValue]];
    subject = [array objectAtIndex:4];
    text = [array objectAtIndex:5];
    
    message = [[LVKMessage alloc] initWithDictionary:[NSDictionary dictionaryWithObjectsAndKeys:messageId, @"id", userId, @"user_id", [NSNumber numberWithBool:!isUnread], @"read_state", [NSNumber numberWithBool:isOutbox], @"out", chatId, @"chat_id", text, @"body", [NSNumber numberWithDouble:[date timeIntervalSince1970]], @"date", nil]];
    dialog = [[LVKDialog alloc] initWithPlainDictionary:[NSDictionary dictionaryWithObjectsAndKeys:chatId, @"chat_id", [NSNumber numberWithInt:type], @"type", subject, @"title", message, @"message", nil]];
}

@end
