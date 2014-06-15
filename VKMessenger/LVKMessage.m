//
//  LVKMessage.m
//  VKMessenger
//
//  Created by Leonid Repin on 03.06.14.
//  Copyright (c) 2014 Levelab. All rights reserved.
//

#import <VKSdk.h>
#import "LVKMessage.h"
#import "LVKRepostedMessage.h"

@implementation LVKMessage

@synthesize _id, state, body, chatId, userId, type, user, date, isUnread, isOutgoing, attachments, forwarded;

-(id)init
{
    self = [super init];
    
    if(self)
    {
        state = Default;
    }
    
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
        
        userId = isOutgoing ? [NSNumber numberWithInt:[[[VKSdk getAccessToken] userId] intValue]] : [dictionary valueForKey:@"user_id"];
        date = [NSDate dateWithTimeIntervalSince1970:[[dictionary valueForKey:@"date"] intValue]];
        body = [dictionary valueForKey:@"body"];
        
        [self adoptAttachments:[dictionary valueForKey:@"attachments"]];
        
        [self adoptForwarded:[dictionary valueForKey:@"fwd_messages"]];
        
        if(forwarded.count > 0 && body.length == 0)
        {
            body = @"";
        }
    }
    
    return self;
}

-(void)adoptAttachments:(NSArray *)_attachments
{
    NSMutableArray *tmpAttachments = [[NSMutableArray alloc] init];
    [_attachments enumerateObjectsUsingBlock:^(NSDictionary *attachment, NSUInteger idx, BOOL *stop) {
        [tmpAttachments addObject:[[LVKMessageAttachment alloc] initWithDictionary:attachment]];
    }];
    attachments = [NSArray arrayWithArray:tmpAttachments];
}

-(void)adoptForwarded:(NSArray *)_forwarded
{
    NSMutableArray *tmpForwarded = [[NSMutableArray alloc] init];
    [_forwarded enumerateObjectsUsingBlock:^(NSDictionary *fwdMessage, NSUInteger idx, BOOL *stop) {
        [tmpForwarded addObject:[[LVKRepostedMessage alloc] initWithDictionary:fwdMessage]];
    }];
    forwarded = [NSArray arrayWithArray:tmpForwarded];
}

-(void)adoptUserArray:(NSArray *)array
{
    for (LVKUser *user in array) {
        if([userId isEqualToNumber:[user _id]])
        {
            [self setUser:user];
        }
    }
    [forwarded enumerateObjectsUsingBlock:^(LVKRepostedMessage *repostedMessage, NSUInteger idx, BOOL *stop) {
        [repostedMessage adoptUserArray:array];
    }];
    
}

-(NSArray *)getUserIds
{
    NSMutableArray *userIds = [NSMutableArray arrayWithObject:userId];
    [forwarded enumerateObjectsUsingBlock:^(LVKRepostedMessage *repostedMessage, NSUInteger idx, BOOL *stop) {
        [userIds addObjectsFromArray:[repostedMessage getUserIds]];
    }];
    
    return [NSArray arrayWithArray:userIds];
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

-(NSArray *)getMessageParts
{
    NSMutableArray *parts = body.length > 0 ? [NSMutableArray arrayWithObject:self] : [[NSMutableArray alloc] init];

    [parts addObjectsFromArray:attachments];
    [parts addObjectsFromArray:forwarded];

    return [NSArray arrayWithArray:parts];
}

-(BOOL)isEqual:(id)object
{
    return [_id isEqual:[object _id]];
}
@end
