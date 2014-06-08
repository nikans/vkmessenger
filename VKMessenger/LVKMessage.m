//
//  LVKMessage.m
//  VKMessenger
//
//  Created by Leonid Repin on 03.06.14.
//  Copyright (c) 2014 Levelab. All rights reserved.
//

#import "LVKMessage.h"

@implementation LVKMessage

@synthesize _id, body, chatId, userId, type, user, date, isUnread, isOutgoing, attachments, forwarded;

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
        _id = [dictionary valueForKey:@"id"];
        isUnread = [[dictionary valueForKey:@"read_state"] isEqualToNumber:[[NSNumber alloc] initWithInt:0]];
        isOutgoing = [[dictionary valueForKey:@"out"] isEqualToNumber:[[NSNumber alloc] initWithInt:1]];
        
        chatId = [dictionary valueForKey:@"chat_id"];
        
        type = chatId == nil ? Dialog : Room;
        
        if(type == Dialog)
            chatId = [dictionary valueForKeyPath:@"user_id"];
        
        userId = isOutgoing ? [[NSNumber alloc] initWithInt:0] : [dictionary valueForKey:@"user_id"];
        date = [NSDate dateWithTimeIntervalSince1970:[[dictionary valueForKey:@"date"] intValue]];
        body = [dictionary valueForKey:@"body"];
        
        NSMutableArray *tmpAttachments = [[NSMutableArray alloc] init];
        [[dictionary valueForKey:@"attachments"] enumerateObjectsUsingBlock:^(NSDictionary *attachment, NSUInteger idx, BOOL *stop) {
            [tmpAttachments addObject:[[LVKMessageAttachment alloc] initWithDictionary:attachment]];
        }];
        attachments = [NSArray arrayWithArray:tmpAttachments];
        
        NSMutableArray *tmpForwarded = [[NSMutableArray alloc] init];
        [[dictionary valueForKey:@"fwd_messages"] enumerateObjectsUsingBlock:^(NSDictionary *fwdMessage, NSUInteger idx, BOOL *stop) {
            [tmpForwarded addObject:[[LVKMessage alloc] initWithDictionary:fwdMessage]];
        }];
        forwarded = [NSArray arrayWithArray:tmpForwarded];
        
        if(forwarded.count > 0 && body.length == 0)
        {
            body = @"Пересланное сообщение";
        }
    }
    
    return self;
}

-(void)adoptUser:(LVKUser *)adoptedUser
{
    [self setUser:adoptedUser];
}

-(readState)getReadState
{
    if(!isUnread)
        return Read;
    else if(isOutgoing)
        return UnreadOutgoing;
    else
        return UnreadIncoming;
}

-(BOOL)isEqual:(id)object
{
    return [_id isEqual:[object _id]];
}
@end
