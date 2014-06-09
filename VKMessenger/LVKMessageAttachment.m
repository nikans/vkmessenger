//
//  LVKMessageAttachment.m
//  VKMessenger
//
//  Created by Leonid Repin on 05.06.14.
//  Copyright (c) 2014 Levelab. All rights reserved.
//

#import "LVKMessageAttachment.h"
#import "LVKAudioAttachment.h"
#import "LVKPhotoAttachment.h"
#import "LVKStickerAttachment.h"
#import "LVKWallAttachment.h"
#import "LVKVideoAttachment.h"
#import "LVKDocumentAttachment.h"

@implementation LVKMessageAttachment

-(id)init
{
    self = [super init];
    
    return self;
}

-(id)initWithDictionary:(NSDictionary *)dictionary
{
    NSString *tmpType = [dictionary objectForKey:@"type"];
    
    if([tmpType isEqualToString:@"audio"])
    {
        self = [[LVKAudioAttachment alloc] initWithDictionary:[dictionary objectForKey:tmpType] andTypeString:tmpType];
    }
    else if([tmpType isEqualToString:@"photo"])
    {
        self = [[LVKPhotoAttachment alloc] initWithDictionary:[dictionary objectForKey:tmpType] andTypeString:tmpType];
    }
    else if([tmpType isEqualToString:@"sticker"])
    {
        self = [[LVKStickerAttachment alloc] initWithDictionary:[dictionary objectForKey:tmpType] andTypeString:tmpType];
    }
    else if([tmpType isEqualToString:@"video"])
    {
        self = [[LVKVideoAttachment alloc] initWithDictionary:[dictionary objectForKey:tmpType] andTypeString:tmpType];
    }
    else if([tmpType isEqualToString:@"wall"])
    {
        self = [[LVKWallAttachment alloc] initWithDictionary:[dictionary objectForKey:tmpType] andTypeString:tmpType];
    }
    else if([tmpType isEqualToString:@"doc"])
    {
        self = [[LVKDocumentAttachment alloc] initWithDictionary:[dictionary objectForKey:tmpType] andTypeString:tmpType];
    }
    else
    {
        self = [self init];
    }
    
    return self;
}

-(id)initWithDictionary:(NSDictionary *)dictionary andTypeString:(NSString *)typeString
{
    return [self initWithDictionary:dictionary];
}

@end
