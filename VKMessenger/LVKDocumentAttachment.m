//
// Created by Leonid Repin on 09.06.14.
// Copyright (c) 2014 Levelab. All rights reserved.
//

#import "LVKDocumentAttachment.h"


@implementation LVKDocumentAttachment {

}

@synthesize type, _id, size, url;

-(id)initWithDictionary:(NSDictionary *)dictionary andTypeString:(NSString *)typeString
{
    self = [super init];

    if(self)
    {
        type = typeString;
        _id = [dictionary objectForKey:@"id"];
        size = [dictionary objectForKey:@"size"];
        url = [dictionary objectForKey:@"url"];
    }

    return self;
}
@end