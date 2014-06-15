//
//  LVKDefaultMessageVideoItem.m
//  VKMessenger
//
//  Created by Eliah Nikans on 6/9/14.
//  Copyright (c) 2014 Levelab. All rights reserved.
//

#import "LVKDefaultMessagePostItem.h"

@implementation LVKDefaultMessagePostItem

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
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
