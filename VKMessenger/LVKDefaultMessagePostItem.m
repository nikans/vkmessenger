//
//  LVKDefaultMessageVideoItem.m
//  VKMessenger
//
//  Created by Eliah Nikans on 6/9/14.
//  Copyright (c) 2014 Levelab. All rights reserved.
//

#import "LVKDefaultMessagePostItem.h"
#import "LVKWallAttachment.h"
#import "LVKDocumentAttachment.h"

@implementation LVKDefaultMessagePostItem

- (id)initWithFrame:(CGRect)frame
{
    self = [[[NSBundle mainBundle] loadNibNamed:@"LVKDefaultMessagePostItem" owner:self options:nil] firstObject];
    if (self) {
        self.frame = frame;
    }
    return self;
}

- (void)awakeFromNib {
//    self.layer.cornerRadius = 10;
//    self.layer.masksToBounds = YES;
//    self.imageWidthConstraint.constant = self.frame.size.width-10;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    if (self.type == Document)
        self.icon.image = [UIImage imageNamed:@"document"];
    else
        self.icon.image = [UIImage imageNamed:@"wallPost"];
}

- (void)layoutData:(id<LVKMessagePartProtocol>)data {
    if ([data isKindOfClass:[LVKWallAttachment class]]) {
        self.type = Wall;
        self.title.text = [(LVKWallAttachment *)data text];
        self.subtitle.text = @"Wall post"; //TODO: localize!
    }
    else if ([data isKindOfClass:[LVKDocumentAttachment class]]) {
        self.type = Document;
    }
}

+ (CGSize)calculateContentSizeWithData:(id)_data maxWidth:(CGFloat)_maxWidth minWidth:(CGFloat)_minWidth {
    return CGSizeMake(_maxWidth, 50);
}

//- (void)layoutIfNeededForCalculatedWidth:(CGFloat)_width alignRight:(BOOL)_alignRight {
//    CGRect frame = self.frame;
//    frame.size.width = _width;
//    if (_alignRight) frame.origin.x = 0;
//    self.frame = frame;
//}

@end
