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

+ (CGSize)calculateContentSizeWithData:(LVKMessage *)_data maxWidth:(CGFloat)_maxWidth {
    if ([_data.body length] == 0)
        return CGSizeMake(1.f, 1.f);
    
    CGSize textSize = [(NSString *)[(LVKMessage *)_data body] integralSizeWithFont:[UIFont systemFontOfSize:16] maxWidth:_maxWidth-10 numberOfLines:INFINITY];
    CGSize cellSize = CGSizeMake(textSize.width+10 < _maxWidth ? textSize.width+10 : _maxWidth, textSize.height);
    return cellSize;
}

@end
