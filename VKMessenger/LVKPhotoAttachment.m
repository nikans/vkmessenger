//
//  LVKPhotoAttachment.m
//  VKMessenger
//
//  Created by Leonid Repin on 05.06.14.
//  Copyright (c) 2014 Levelab. All rights reserved.
//

#import "LVKPhotoAttachment.h"

@implementation LVKPhotoAttachment

@synthesize type, photo_604, height, width, text;

-(id)initWithDictionary:(NSDictionary *)dictionary andTypeString:(NSString *)typeString
{
    self = [super init];
    
    if(self)
    {
        type = typeString;
        photo_604 = [dictionary objectForKey:@"photo_604"];
        height = [dictionary objectForKey:@"height"];
        width = [dictionary objectForKey:@"width"];
        text = [dictionary objectForKey:@"text"];
    }
    
    return self;
}

@end
