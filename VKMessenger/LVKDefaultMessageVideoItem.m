//
//  LVKDefaultMessageVideoItem.m
//  VKMessenger
//
//  Created by Eliah Nikans on 6/9/14.
//  Copyright (c) 2014 Levelab. All rights reserved.
//

#import "LVKDefaultMessageVideoItem.h"
#import "LVKVideoAttachment.h"

@implementation LVKDefaultMessageVideoItem

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
    self.imageWidthConstraint.constant = self.frame.size.width-10;
}

+ (CGSize)calculateContentSizeWithData:(LVKVideoAttachment *)_data maxWidth:(CGFloat)_maxWidth {
    return CGSizeMake(130+10, 97.5+10);
}

- (void)dealloc {
    self.image = nil;
    self.durationLabel = nil;
}

@end
