//
//  LVKUser.m
//  VKMessenger
//
//  Created by Leonid Repin on 04.06.14.
//  Copyright (c) 2014 Levelab. All rights reserved.
//

#import "LVKUser.h"

@implementation LVKUser

@synthesize _id, firstName, lastName, photo_200;

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
        photo_200 = [dictionary valueForKey:@"photo_200"];
    }
    
    return self;
}

@end
