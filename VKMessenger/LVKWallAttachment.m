//
// Created by Leonid Repin on 09.06.14.
// Copyright (c) 2014 Levelab. All rights reserved.
//

#import "LVKWallAttachment.h"


@implementation LVKWallAttachment {

}

@synthesize type, _id, text;

-(id)initWithDictionary:(NSDictionary *)dictionary andTypeString:(NSString *)typeString
{
    self = [super init];

    if(self)
    {
        type = typeString;
        _id = [dictionary objectForKey:@"id"];
        text = [dictionary objectForKey:@"text"];
    }

    return self;
}
@end