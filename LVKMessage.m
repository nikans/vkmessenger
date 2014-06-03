//
//  LVKMessage.m
//  VKMessenger
//
//  Created by Leonid Repin on 03.06.14.
//  Copyright (c) 2014 Levelab. All rights reserved.
//

#import "LVKMessage.h"

@implementation LVKMessage

@synthesize _id, body, chatId, userId, date, readState, out;

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
        _id = [dictionary valueForKeyPath:@"id"];
        chatId = [dictionary valueForKeyPath:@"chat_id"];
        readState = [[dictionary valueForKeyPath:@"readState"] isEqualToNumber:[[NSNumber alloc] initWithInt:1]];
        out = [[dictionary valueForKeyPath:@"out"] isEqualToNumber:[[NSNumber alloc] initWithInt:1]];
        body = [dictionary valueForKeyPath:@"body"];
        userId = [dictionary valueForKeyPath:@"user_id"];
    }
    
    return self;
}
@end
