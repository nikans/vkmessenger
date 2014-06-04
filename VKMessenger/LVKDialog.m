//
//  LVKDialog.m
//  VKMessenger
//
//  Created by Leonid Repin on 03.06.14.
//  Copyright (c) 2014 Levelab. All rights reserved.
//

#import "LVKDialog.h"

@implementation LVKDialog

@synthesize title, chatId, chatUserIds, type, lastMessage, user, users;

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
        chatUserIds = [dictionary valueForKeyPath:@"message.chat_active"];
        type = chatId == nil ? Dialog : Room;
        
        if(type == Dialog)
            chatId = [dictionary valueForKeyPath:@"message.user_id"];
        
        title = [dictionary valueForKeyPath:@"message.title"];
        lastMessage = [[LVKMessage alloc] initWithDictionary:[dictionary valueForKey:@"message"]];
    }
    
    return self;
}

-(id)initWithPlainDictionary:(NSDictionary *)dictionary
{
    self = [self init];
    
    if(self)
    {
        chatId = [dictionary valueForKeyPath:@"chat_id"];
        type = [[dictionary valueForKeyPath:@"type"] intValue];
        title = [dictionary valueForKeyPath:@"title"];
        lastMessage = [dictionary valueForKey:@"message"];
    }
    
    return self;
}

-(void)adoptUser:(LVKUser *)adoptedUser
{
    [self setUser:adoptedUser];
    [self setTitle:[adoptedUser fullName]];
}

-(void)adoptUsers:(NSArray *)adoptedUsers
{
    [self setUsers:adoptedUsers];
}

-(BOOL)isEqual:(id)object
{
    return [chatId isEqual:[object chatId]];
}

-(NSString *)chatIdKey
{
    switch (type) {
        case Dialog:
            return @"user_id";
            break;
            
        case Room:
            return @"chat_id";
            break;
            
        default:
            break;
    }
}

@end
