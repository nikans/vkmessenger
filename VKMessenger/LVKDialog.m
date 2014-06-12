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
        chatId = [dictionary valueForKey:@"chat_id"];
        type = [[dictionary valueForKey:@"type"] intValue];
        title = [dictionary valueForKey:@"title"];
        lastMessage = [dictionary valueForKey:@"message"];
    }
    
    return self;
}

-(id)initWithDictionaryFromSearch:(NSDictionary *)dictionary
{
    self = [self init];
    
    if(self)
    {
        chatId = [dictionary valueForKey:@"id"];
        chatUserIds = [dictionary valueForKey:@"users"];
        
        NSString *tmpType = [dictionary valueForKey:@"type"];
        
        if([tmpType isEqualToString:@"chat"])
            type = Room;
        else if([tmpType isEqualToString:@"profile"])
            type = Dialog;
        
        title = [dictionary valueForKeyPath:@"title"];
        lastMessage = [[LVKMessage alloc] initWithDictionary:[dictionary valueForKey:@"message"]];
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

-(readState)getReadState
{
    return [lastMessage getReadState];
}

-(id)getChatPicture
{
    if(type == Dialog)
        return [user getPhoto:50];
    else if(type == Room)
    {
        NSIndexSet *indexes = [NSIndexSet indexSetWithIndexesInRange:NSMakeRange(0, users.count > 4 ? 4 : users.count)];
        NSMutableArray *picturesArray = [[NSMutableArray alloc] init];
        
        [[[users filteredArrayUsingPredicate:[NSPredicate predicateWithBlock:^BOOL(LVKUser *chatUser, NSDictionary *bindings) {
            return [chatUser getPhoto:50] != nil;
        }]] objectsAtIndexes:indexes] enumerateObjectsUsingBlock:^(LVKUser *chatUser, NSUInteger idx, BOOL *stop) {
            [picturesArray addObject:[chatUser getPhoto:50]];
        }];
        
        return picturesArray;
    }
    else
        return @"";
}

@end
