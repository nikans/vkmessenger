//
//  LVKDialogsResponse.m
//  VKMessenger
//
//  Created by Leonid Repin on 03.06.14.
//  Copyright (c) 2014 Levelab. All rights reserved.
//

#import "LVKDialogsCollection.h"

@implementation LVKDialogsCollection

@synthesize count;
@synthesize dialogs;

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
    [[dialogs filteredArrayUsingPredicate:[NSPredicate predicateWithBlock:^BOOL(LVKDialog *dialog, NSDictionary *bindings) {
        if(dialog.type == Room)
            return NO;
        return YES;
    }]] enumerateObjectsUsingBlock:^(LVKDialog *dialog, NSUInteger idx, BOOL *stop) {
        [userIds addObject:[dialog userId]];
    }];
    
    return [NSArray arrayWithArray:userIds];
}

-(void)adoptUserCollection:(LVKUsersCollection *)collection
{
    [[dialogs filteredArrayUsingPredicate:[NSPredicate predicateWithBlock:^BOOL(LVKDialog *dialog, NSDictionary *bindings) {
        if(dialog.type == Room)
            return NO;
        return YES;
    }]] enumerateObjectsUsingBlock:^(LVKDialog *dialog, NSUInteger idx, BOOL *stop) {
        LVKUser *currentUser = [[collection usersIdx] objectForKey:dialog.userId];
        [dialog setTitle:[NSString stringWithFormat:@"%@ %@", currentUser.firstName, currentUser.lastName]];
    }];
}
@end
