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

+ (CGSize)calculateContentSizeWithData:(LVKMessage *)_data maxWidth:(CGFloat)_maxWidth minWidth:(CGFloat)_minWidth {
    if (![_data respondsToSelector:@selector(body)])
        return CGSizeMake(0.01f, 0.01f);
    
    if ([_data.body length] == 0)
        return CGSizeMake(0.01f, 0.01f);
    
    CGSize textSize = [(NSString *)[(LVKMessage *)_data body] integralSizeWithFont:[UIFont systemFontOfSize:16] maxWidth:_maxWidth-10 numberOfLines:INFINITY];
    CGFloat cellWidth = textSize.width+10 < _maxWidth ? textSize.width+10 : _maxWidth;
    CGSize cellSize = CGSizeMake(cellWidth > _minWidth ? cellWidth : _minWidth, textSize.height);
    return cellSize;
}

- (void)dealloc {
    self.body = nil;
}

@end
