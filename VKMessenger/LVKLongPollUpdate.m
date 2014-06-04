//
//  LVKLongPollUpdate.m
//  VKMessenger
//
//  Created by Leonid Repin on 04.06.14.
//  Copyright (c) 2014 Levelab. All rights reserved.
//

#import "LVKLongPollUpdate.h"
#import "LVKLongPollNewMessage.h"

@implementation LVKLongPollUpdate

-(id)init
{
    self = [super init];
    
    return self;
}

-(id)initWithArray:(NSArray *)array
{
    int eventCode = [[array firstObject] intValue];
    NSMutableArray *tmpArray = [NSMutableArray arrayWithArray:array];
    [tmpArray removeObjectsInRange:NSMakeRange(0, 1)];
    
    switch (eventCode) {
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

-(void)mapArrayToProperties:(NSArray *)array
{
    
}
@end
