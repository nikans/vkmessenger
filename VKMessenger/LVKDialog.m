//
//  LVKDialog.m
//  VKMessenger
//
//  Created by Leonid Repin on 03.06.14.
//  Copyright (c) 2014 Levelab. All rights reserved.
//

#import "LVKDialog.h"

@implementation LVKDialog

@synthesize title, chatId, userId, type, lastMessage;

-(id)init
{
    self = [super init];
    
    return self;
}

-(id)initWithDictionary:(NSDictionary *)dictionary
{
    self = [self init];
    
    if(self)
    {
        chatId = [dictionary valueForKeyPath:@"message.chat_id"];
        type = chatId == nil ? Dialog : Room;
        userId = [dictionary valueForKeyPath:@"message.user_id"];
        title = [dictionary valueForKeyPath:@"message.title"];
        lastMessage = [[LVKMessage alloc] initWithDictionary:[dictionary valueForKey:@"message"]];
    }
    
    return self;
}

@end
