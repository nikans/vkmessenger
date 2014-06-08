//
//  LVKMessageBodyRepostItem.m
//  VKMessengerViews
//
//  Created by Eliah Nikans on 6/8/14.
//  Copyright (c) 2014 Levelab. All rights reserved.
//

#import "LVKDefaultMessageRepostBodyItem.h"
#import "NSString+StringSize.h"
#import "LVKRepostedMessage.h"


@implementation LVKDefaultMessageRepostBodyItem

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

+ (CGSize)calculateContentSizeWithData:(id<LVKMessagePartProtocol>)_data {
    CGSize textSize = [(NSString *)[(LVKRepostedMessage *)_data body] integralSizeWithFont:[UIFont systemFontOfSize:16] maxWidth:180 numberOfLines:INFINITY];
    CGSize contentSize = CGSizeMake(200, textSize.height + 58); // avatar height
    return contentSize;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
