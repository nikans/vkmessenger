//
//  LVKUserResponse.m
//  VKMessenger
//
//  Created by Leonid Repin on 04.06.14.
//  Copyright (c) 2014 Levelab. All rights reserved.
//

#import "LVKUsersCollection.h"

@implementation LVKUsersCollection

@synthesize count, users, usersIdx;

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
        NSMutableArray *_tmpUsers = [[NSMutableArray alloc] init];
        NSMutableDictionary *_tmpUsersIdx = [[NSMutableDictionary alloc] init];
        
        LVKUser *currentUserObject = nil;
        
        for (NSDictionary *userDictionary in array)
        {
            currentUserObject = [[LVKUser alloc] initWithDictionary:userDictionary];
            [_tmpUsers addObject:currentUserObject];
            [_tmpUsersIdx setObject:currentUserObject forKey:[currentUserObject _id]];
        }
        
        users = [NSArray arrayWithArray:_tmpUsers];
        usersIdx = [NSDictionary dictionaryWithDictionary:_tmpUsersIdx];
    }
    
    return self;
}

-(id)initWithUserArray:(NSArray *)array
{
    self = [self init];
    
    if(self)
    {
        NSMutableArray *_tmpUsers = [[NSMutableArray alloc] init];
        NSMutableDictionary *_tmpUsersIdx = [[NSMutableDictionary alloc] init];
        
        for (LVKUser *user in array)
        {
            [_tmpUsers addObject:user];
            [_tmpUsersIdx setObject:user forKey:[user isCurrent] ? @"current" : [user _id]];
        }
        
        users = [NSArray arrayWithArray:_tmpUsers];
        usersIdx = [NSDictionary dictionaryWithDictionary:_tmpUsersIdx];
    }
    
    return self;
}

-(id)initWithDictionary:(NSDictionary *)dictionary
{
    self = [self init];
    
    if(self)
    {
        count = [dictionary objectForKey:@"count"];
        
        NSMutableArray *_tmpUsers = [[NSMutableArray alloc] init];
        NSMutableDictionary *_tmpUsersIdx = [[NSMutableDictionary alloc] init];
        
        LVKUser *currentUserObject = nil;
        
        for (NSDictionary *userDictionary in [dictionary objectForKey:@"items"])
        {
            currentUserObject = [[LVKUser alloc] initWithDictionary:userDictionary];
            [_tmpUsers addObject:currentUserObject];
            [_tmpUsersIdx setObject:currentUserObject forKey:[currentUserObject _id]];
        }
        
        users = [NSArray arrayWithArray:_tmpUsers];
        usersIdx = [NSDictionary dictionaryWithDictionary:_tmpUsersIdx];
    }
    
    return self;
}
@end
