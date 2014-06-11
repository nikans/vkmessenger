//
//  LVKMessageBodyRepostItem.m
//  VKMessengerViews
//
//  Created by Eliah Nikans on 6/8/14.
//  Copyright (c) 2014 Levelab. All rights reserved.
//

#import "LVKDefaultMessageFullBodyItem.h"
#import "NSString+StringSize.h"
#import "LVKMessage.h"


@implementation LVKDefaultMessageFullBodyItem

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

+ (CGSize)calculateContentSizeWithData:(LVKMessage *)_data maxWidth:(CGFloat)_maxWidth {
    if ([_data.body length] == 0)
        return CGSizeMake(_maxWidth, 40);
    
    CGSize textSize = [(NSString *)[_data body] integralSizeWithFont:[UIFont systemFontOfSize:16] maxWidth:_maxWidth-10 numberOfLines:INFINITY];
    CGSize contentSize = CGSizeMake(_maxWidth, textSize.height + 47);
    return contentSize;
}

@end
