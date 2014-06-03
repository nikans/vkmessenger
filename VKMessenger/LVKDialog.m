//
//  LVKDialog.m
//  VKMessenger
//
//  Created by Leonid Repin on 03.06.14.
//  Copyright (c) 2014 Levelab. All rights reserved.
//

#import "LVKDialog.h"

@implementation LVKDialog

@synthesize _id, body, title, chatId, userId, type, date, readState, out;

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
        _id = [dictionary valueForKeyPath:@"message.id"];
        chatId = [dictionary valueForKeyPath:@"message.chat_id"];
        type = chatId == nil ? Dialog : Room;
        readState = [[dictionary valueForKeyPath:@"message.readState"] isEqualToNumber:[[NSNumber alloc] initWithInt:1]];
        out = [[dictionary valueForKeyPath:@"message.out"] isEqualToNumber:[[NSNumber alloc] initWithInt:1]];
        body = [dictionary valueForKeyPath:@"message.body"];
        userId = [dictionary valueForKeyPath:@"message.user_id"];
        title = [dictionary valueForKeyPath:@"message.title"];
    }
    
    return self;
}

@end
