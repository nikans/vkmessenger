//
//  LVKDefaultMessageStickerItem.m
//  VKMessenger
//
//  Created by Eliah Nikans on 6/9/14.
//  Copyright (c) 2014 Levelab. All rights reserved.
//

#import "LVKDefaultMessageStickerItem.h"
#import "LVKStickerAttachment.h"
#import <SDWebImage/UIImageView+WebCache.h>

@implementation LVKDefaultMessageStickerItem

- (id)initWithFrame:(CGRect)frame
{
    self = [[[NSBundle mainBundle] loadNibNamed:@"LVKDefaultMessageStickerItem" owner:self options:nil] firstObject];
    if (self) {
        self.frame = frame;
    }
    return self;
}

- (void)awakeFromNib {
    self.layer.cornerRadius = 10;
    self.layer.masksToBounds = YES;
    self.imageWidthConstraint.constant = self.frame.size.width;
}

+ (CGSize)calculateContentSizeWithData:(LVKStickerAttachment *)_data maxWidth:(CGFloat)_maxWidth minWidth:(CGFloat)_minWidth {
    return CGSizeMake(128, 128);
}

- (void)layoutData:(LVKStickerAttachment *)data {
    [self.image setImageWithURL:[data photo_128]];
}

- (void)dealloc {
    self.image = nil;
}

@end
