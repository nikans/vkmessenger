//
//  LVKDialogsResponse.m
//  VKMessenger
//
//  Created by Leonid Repin on 03.06.14.
//  Copyright (c) 2014 Levelab. All rights reserved.
//

#import <VKSdk.h>
#import "LVKDialogsCollection.h"

@implementation LVKDialogsCollection

@synthesize count;
@synthesize dialogs;

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
        count = [NSNumber numberWithInt:array.count];
        NSMutableArray *_tmpDialogs = [[NSMutableArray alloc] init];
        
        for (NSDictionary *dialogDictionary in array)
        {
            [_tmpDialogs addObject:[[LVKDialog alloc] initWithDictionaryFromSearch:dialogDictionary]];
        }
        
        dialogs = [NSArray arrayWithArray:_tmpDialogs];
    }
    
    return self;
}

-(id)initWithDictionary:(NSDictionary *)dictionary
{
    self = [self init];
    
    if(self)
    {
        count = [dictionary valueForKey:@"count"];
        NSMutableArray *_tmpDialogs = [[NSMutableArray alloc] init];
        
        for (NSDictionary *dialogDictionary in [dictionary valueForKey:@"items"])
        {
            [_tmpDialogs addObject:[[LVKDialog alloc] initWithDictionary:dialogDictionary]];
        }
        
        dialogs = [NSArray arrayWithArray:_tmpDialogs];
    }
        
    return self;
}

-(NSArray *)getUserIds
{
    NSMutableArray *userIds = [[NSMutableArray alloc] init];
    [dialogs enumerateObjectsUsingBlock:^(LVKDialog *dialog, NSUInteger idx, BOOL *stop) {
        if(dialog.type == Room)
        {
            for (NSNumber *userId in [dialog chatUserIds])
            {
                [userIds addObject:userId];
            }
        }
        else if(dialog.type == Dialog)
        {
            [userIds addObject:[dialog chatId]];
        }
    }];
    [userIds addObject:[NSNumber numberWithInt:[[[VKSdk getAccessToken] userId] intValue]]];
    
    return [NSArray arrayWithArray:userIds];
}

-(void)adoptUserCollection:(LVKUsersCollection *)collection
{
    [dialogs enumerateObjectsUsingBlock:^(LVKDialog *dialog, NSUInteger idx, BOOL *stop) {
        if(dialog.type == Room)
        {
            NSMutableArray *currentUsers = [[NSMutableArray alloc] init];
            for (NSNumber *userId in [dialog chatUserIds])
            {
                [currentUsers addObject:[[collection usersIdx] objectForKey:userId]];
            }
            [dialog adoptUsers:currentUsers];
        }
        else if(dialog.type == Dialog)
        {
            LVKUser *currentUser = [[collection usersIdx] objectForKey:dialog.chatId];
            [dialog adoptUser:currentUser];
        }
        [dialog adoptLastMessageUsers:[collection users]];
    }];
}
@end
