//
// Created by Leonid Repin on 09.06.14.
// Copyright (c) 2014 Levelab. All rights reserved.
//

#import "LVKStickerAttachment.h"


@implementation LVKStickerAttachment {

}

@synthesize type, width, height, photo_64, photo_128, photo_256;

-(id)initWithDictionary:(NSDictionary *)dictionary andTypeString:(NSString *)typeString
{
    self = [super init];

    if(self)
    {
        type = typeString;
        height = [dictionary objectForKey:@"height"];
        width = [dictionary objectForKey:@"width"];
        photo_64 = [dictionary objectForKey:@"photo_64"];
        photo_128 = [dictionary objectForKey:@"photo_128"];
        photo_256 = [dictionary objectForKey:@"photo_256"];
    }

    return self;
}

@end