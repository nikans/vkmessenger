//
//  LVKDefaultMessageStickerItem.m
//  VKMessenger
//
//  Created by Eliah Nikans on 6/9/14.
//  Copyright (c) 2014 Levelab. All rights reserved.
//

#import "LVKDefaultMessageStickerItem.h"
#import "LVKStickerAttachment.h"

@implementation LVKDefaultMessageStickerItem

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)awakeFromNib {
    self.layer.cornerRadius = 10;
    self.layer.masksToBounds = YES;
    self.imageWidthConstraint.constant = self.frame.size.width;
}

+ (CGSize)calculateContentSizeWithData:(LVKStickerAttachment *)_data maxWidth:(CGFloat)_maxWidth {
    return CGSizeMake(128, 128);
}


@end