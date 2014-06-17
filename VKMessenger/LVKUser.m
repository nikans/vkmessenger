//
//  LVKUser.m
//  VKMessenger
//
//  Created by Leonid Repin on 04.06.14.
//  Copyright (c) 2014 Levelab. All rights reserved.
//

#import "LVKUser.h"
#import "LVKDialog.h"

@implementation LVKUser

@synthesize _id, firstName, lastName, fullName, photo_50, photo_100, photo_200, photo_400, isCurrent;

-(id)init
{
    self = [super init];
    
    return self;
}

+(NSMutableDictionary *)users
{
    static NSMutableDictionary *_users = nil;
    
    if(_users == nil)
    {
        _users = [[NSMutableDictionary alloc] init];
    }
    
    return _users;
}

+(LVKUser *)getUserById:(NSNumber *)userId
{
    LVKUser *user = [[LVKUser users] objectForKey:userId];
    
    if(user == nil)
    {
        user = [LVKUser alloc];
        [[LVKUser users] setObject:user forKey:userId];
    }
    
    return user;
}

-(id)initWithDictionary:(NSDictionary *)dictionary
{
    self = [LVKUser getUserById:[dictionary valueForKey:@"id"]];
    
    if(self)
    {
        _id = [dictionary valueForKey:@"id"];
        firstName = [dictionary valueForKey:@"first_name"];
        lastName = [dictionary valueForKey:@"last_name"];
        fullName = [NSString stringWithFormat:@"%@ %@", firstName, lastName];
        photo_50 = [dictionary valueForKey:@"photo_50"];
        photo_100 = [dictionary valueForKey:@"photo_100"];
        photo_200 = [dictionary valueForKey:@"photo_200"];
        photo_400 = [dictionary valueForKey:@"photo_400_orig"];
    }
    
    return self;
}

-(NSString *)getPhoto:(NSUInteger) size
{
    if(size <= 50)
    {
        if(photo_50 != nil)
            return photo_50;
        else
            return @"";
    }
    else if(size <= 100)
    {
        if(photo_100 != nil)
            return photo_100;
        else
            return [self getPhoto:50];
    }
    else if(size <= 200)
    {
        if(photo_200 != nil)
            return photo_200;
        else
            return [self getPhoto:100];
    }
    else if(size <= 400)
    {
        if(photo_400 != nil)
            return photo_400;
        else
            return [self getPhoto:200];
    }
    else
    {
        return [self getPhoto:400];
    }
}

-(id)createDialog
{
    LVKDialog *dialog = [[LVKDialog alloc] initWithPlainDictionary:[NSDictionary dictionaryWithObjectsAndKeys:_id, @"chat_id", [NSNumber numberWithInt:Dialog], @"type", fullName, @"title", nil]];
    
    [dialog adoptUser:self];
    
    return dialog;
}

@end
