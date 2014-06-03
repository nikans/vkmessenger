//
//  LVKUserResponse.m
//  VKMessenger
//
//  Created by Leonid Repin on 04.06.14.
//  Copyright (c) 2014 Levelab. All rights reserved.
//

#import "LVKUsersCollection.h"

@implementation LVKUsersCollection

@synthesize users, usersIdx;

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
@end
