//
//  LVKLongPollResetMessageFlags.m
//  VKMessenger
//
//  Created by Leonid Repin on 06.06.14.
//  Copyright (c) 2014 Levelab. All rights reserved.
//

#import "LVKLongPollResetMessageFlags.h"

@implementation LVKLongPollResetMessageFlags

@synthesize messageId, mask, isUnread, chatId;

-(NSArray *)prepareNotifications
{
    return [NSArray arrayWithObject:[NSNotification notificationWithName:@"resetMessageFlags" object:self]];
}

-(void)mapArrayToProperties:(NSArray *)array
{
    messageId = [array objectAtIndex:0];
    mask = [array objectAtIndex:1];
    
    isUnread = [mask intValue] & MESSAGE_UNREAD;
    
    if([array objectAtIndex:2] != nil)
    {
        int tmpChatId = [[array objectAtIndex:2] intValue];
        
        if(tmpChatId > 2000000000) tmpChatId = tmpChatId - 2000000000;
        
        chatId = [NSNumber numberWithInt:tmpChatId];
    }
}

@end
