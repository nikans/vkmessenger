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

- (void)setDurationWithSeconds:(int)_seconds {
    int hours   = floor(_seconds / 3600);
    int minutes = floor((_seconds - hours*3600) / 60);
    int seconds = _seconds - hours*3600 - minutes*60;

    self.durationLabel.text = [NSString stringWithFormat:@"%@%@%@:%@",
                               hours > 0 ? hours < 10 ? [NSString stringWithFormat:@"0%i", hours] : @(hours) : @"",
                               hours > 0 ? @":" : @"",
                               minutes < 10 && hours > 0 ? [NSString stringWithFormat:@"0%i", minutes] : @(minutes),
                               seconds < 10 ? [NSString stringWithFormat:@"0%i", seconds] : @(seconds)];
}

+ (CGSize)calculateContentSizeWithData:(LVKVideoAttachment *)_data maxWidth:(CGFloat)_maxWidth {
    return CGSizeMake(130+10, 97.5+10);
}

- (void)dealloc {
    self.image = nil;
    self.durationLabel = nil;
}

@end
