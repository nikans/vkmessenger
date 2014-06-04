//
//  LVKMessage.m
//  VKMessenger
//
//  Created by Leonid Repin on 03.06.14.
//  Copyright (c) 2014 Levelab. All rights reserved.
//

#import "LVKMessage.h"

@implementation LVKMessage

@synthesize _id, body, chatId, userId, date, readState, out, attachments, forwarded;

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
        chatId = [dictionary valueForKey:@"chat_id"];
        readState = [[dictionary valueForKey:@"read_state"] isEqualToNumber:[[NSNumber alloc] initWithInt:1]];
        out = [[dictionary valueForKey:@"out"] isEqualToNumber:[[NSNumber alloc] initWithInt:1]];
        date = [NSDate dateWithTimeIntervalSince1970:[[dictionary valueForKey:@"date"] intValue]];
        body = [dictionary valueForKey:@"body"];
        userId = [dictionary valueForKey:@"user_id"];
        
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

-(BOOL)isEqual:(id)object
{
    return [_id isEqual:[object _id]];
}
@end
