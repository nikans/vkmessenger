//
//  LVKLongPollUpdatesCollection.m
//  VKMessenger
//
//  Created by Leonid Repin on 04.06.14.
//  Copyright (c) 2014 Levelab. All rights reserved.
//

#import "LVKLongPollUpdatesCollection.h"

@implementation LVKLongPollUpdatesCollection

@synthesize updates;

-(id)init
{
    self = [super init];
    
    return self;
}

-(id)initWithArray:(NSArray *)array
{
    self = [self init];
    
    if(self)
    {
        NSMutableArray *_tmpUpdates = [[NSMutableArray alloc] init];
        
        for (NSArray *updateArray in array)
        {
            [_tmpUpdates addObject:[[LVKLongPollUpdate alloc] initWithArray:updateArray]];
        }
        
        updates = [NSArray arrayWithArray:_tmpUpdates];
    }
    
    return self;
}
@end
