//
//  LVKLongPollUpdate.m
//  VKMessenger
//
//  Created by Leonid Repin on 04.06.14.
//  Copyright (c) 2014 Levelab. All rights reserved.
//

#import "LVKLongPoll.h"

@implementation LVKLongPollUpdate

-(id)init
{
    self = [super init];
    
    return self;
}

-(id)initWithArray:(NSArray *)array
{
    int eventCode = [[array firstObject] intValue];
    NSLog(@"%@ %d", array, eventCode);
    NSMutableArray *tmpArray = [NSMutableArray arrayWithArray:array];
    [tmpArray removeObjectsInRange:NSMakeRange(0, 1)];
    
    switch (eventCode) {
        case 1:
            self = [[LVKLongPollSetMessageFlags alloc] init];
            break;
            
        case 3:
            self = [[LVKLongPollResetMessageFlags alloc] init];
            break;
            
        case 4:
            self = [[LVKLongPollNewMessage alloc] init];
            break;
            
        default:
            self = [self init];
            break;
    }
    
    if(self)
    {
        [self mapArrayToProperties:[NSArray arrayWithArray:tmpArray]];
    }
    
    return self;
}

-(NSArray *)prepareNotifications
{
    return [[NSArray alloc] init];
}

-(void)mapArrayToProperties:(NSArray *)array
{
    
}
@end
