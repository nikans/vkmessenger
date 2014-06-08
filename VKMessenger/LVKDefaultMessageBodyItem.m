//
//  LVKMessageBodyItem.m
//  VKMessengerViews
//
//  Created by Eliah Nikans on 6/4/14.
//  Copyright (c) 2014 Levelab. All rights reserved.
//

#import "LVKDefaultMessageBodyItem.h"
#import "NSString+StringSize.h"
#import "LVKMessage.h"

@implementation LVKDefaultMessageBodyItem

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

+ (CGSize)calculateContentSizeWithData:(id<LVKMessagePartProtocol>)_data {
    CGSize textSize = [(NSString *)[(LVKMessage *)_data body] integralSizeWithFont:[UIFont systemFontOfSize:13] maxWidth:200 numberOfLines:INFINITY];
    return textSize;
}

@end
