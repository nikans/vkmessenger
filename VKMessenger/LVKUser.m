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

@synthesize _id, firstName, lastName, fullName, photo_100, isCurrent;

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
        _id = [dictionary valueForKey:@"id"];
        firstName = [dictionary valueForKey:@"first_name"];
        lastName = [dictionary valueForKey:@"last_name"];
        fullName = [NSString stringWithFormat:@"%@ %@", firstName, lastName];
        photo_100 = [dictionary valueForKey:@"photo_100"];
    }
    
    return self;
}

-(NSString *)getPhoto:(NSUInteger) size
{
    return photo_100;
}

-(id)createDialog
{
    LVKDialog *dialog = [[LVKDialog alloc] initWithPlainDictionary:[NSDictionary dictionaryWithObjectsAndKeys:_id, @"chat_id", [NSNumber numberWithInt:Dialog], @"type", fullName, @"title", nil]];
    
    [dialog adoptUser:self];
    
    return dialog;
}

@end
