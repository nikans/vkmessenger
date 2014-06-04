//
//  LVKLongPollNewMessage.m
//  VKMessenger
//
//  Created by Leonid Repin on 04.06.14.
//  Copyright (c) 2014 Levelab. All rights reserved.
//

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
    
    userId = [(NSDictionary *)[array objectAtIndex:6] objectForKey:@"from"];
        
    if(userId == nil)
    {
        userId = isOutbox ? [[NSNumber alloc] initWithInt:0] : [array objectAtIndex:2];
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
    
    date = [[NSDate alloc] initWithTimeIntervalSince1970:[[array objectAtIndex:3] intValue]];
    subject = [array objectAtIndex:4];
    text = [array objectAtIndex:5];
    
    message = [[LVKMessage alloc] initWithDictionary:[NSDictionary dictionaryWithObjectsAndKeys:messageId, @"id", userId, [NSNumber numberWithBool:isUnread], @"read_state", @"userId", chatId, @"chatId", text, @"body", nil]];
    dialog = [[LVKDialog alloc] initWithPlainDictionary:[NSDictionary dictionaryWithObjectsAndKeys:chatId, @"chat_id", [NSNumber numberWithInt:type], @"type", subject, @"title", message, @"message", nil]];
}

@end
