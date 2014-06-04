//
//  LVKAudioAttachment.m
//  VKMessenger
//
//  Created by Leonid Repin on 05.06.14.
//  Copyright (c) 2014 Levelab. All rights reserved.
//

#import "LVKAudioAttachment.h"

@implementation LVKAudioAttachment

@synthesize type, artist, title, url, duration;

-(id)initWithDictionary:(NSDictionary *)dictionary andTypeString:(NSString *)typeString
{
    self = [super init];
    
    if(self)
    {
        type = typeString;
        artist = [dictionary objectForKey:@"artist"];
        title = [dictionary objectForKey:@"title"];
        url = [dictionary objectForKey:@"duration"];
    }
    
    return self;
}

@end
