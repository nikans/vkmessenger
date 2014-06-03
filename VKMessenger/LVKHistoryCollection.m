//
//  LVKHistoryResponse.m
//  VKMessenger
//
//  Created by Leonid Repin on 03.06.14.
//  Copyright (c) 2014 Levelab. All rights reserved.
//

#import "LVKHistoryCollection.h"

@implementation LVKHistoryCollection
@synthesize count;
@synthesize messages;

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
        count = [dictionary valueForKey:@"count"];
        NSMutableArray *_tmpMessages = [[NSMutableArray alloc] init];
        
        for (NSDictionary *messageDictionary in [dictionary valueForKey:@"items"])
        {
            [_tmpMessages addObject:[[LVKMessage alloc] initWithDictionary:messageDictionary]];
        }
        
        messages = [NSArray arrayWithArray:[[_tmpMessages reverseObjectEnumerator] allObjects]];
    }
    
    return self;
}
@end
