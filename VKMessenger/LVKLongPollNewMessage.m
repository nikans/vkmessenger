//
//  LVKLongPollNewMessage.m
//  VKMessenger
//
//  Created by Leonid Repin on 04.06.14.
//  Copyright (c) 2014 Levelab. All rights reserved.
//

#import "LVKLongPollNewMessage.h"

@implementation LVKLongPollNewMessage

@synthesize messageId, flags, type, chatId, userId, date, text;

-(void)mapArrayToProperties:(NSArray *)array
{
    messageId = [array objectAtIndex:0];
    flags = [array objectAtIndex:1];
    
    BOOL isOutbox = [flags intValue] & MESSAGE_OUTBOX;
    
    userId = [(NSDictionary *)[array objectAtIndex:6] objectForKey:@"from"];
        
    if(userId == nil)
    {
        userId = isOutbox ? [[NSNumber alloc] initWithInt:0] : [array objectAtIndex:2];
        chatId = [array objectAtIndex:2];
        type = Dialog;
    }
    else
    {
        chatId = [array objectAtIndex:2];
        type = Room;
    }
    
    date = [[NSDate alloc] initWithTimeIntervalSince1970:[[array objectAtIndex:3] intValue]];
    text = [array objectAtIndex:5];
    
    NSLog(@"%u %@ %@", type, userId, chatId);
}

@end
