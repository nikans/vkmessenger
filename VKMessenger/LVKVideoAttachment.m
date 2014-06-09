//
// Created by Leonid Repin on 09.06.14.
// Copyright (c) 2014 Levelab. All rights reserved.
//

#import "LVKVideoAttachment.h"


@implementation LVKVideoAttachment {

}

@synthesize type, photo_130, photo_320, _id, title, duration;

-(id)initWithDictionary:(NSDictionary *)dictionary andTypeString:(NSString *)typeString
{
    self = [super init];

    if(self)
    {
        type = typeString;
        photo_130 = [dictionary objectForKey:@"photo_130"];
        photo_320 = [dictionary objectForKey:@"photo_320"];
        _id = [dictionary objectForKey:@"id"];
        title = [dictionary objectForKey:@"title"];
        duration = [dictionary objectForKey:@"duration"];
    }

    return self;
}
@end