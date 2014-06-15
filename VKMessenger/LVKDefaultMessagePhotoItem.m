//
//  LVKDefaultMessagePhotoItem.m
//  VKMessenger
//
//  Created by Eliah Nikans on 6/9/14.
//  Copyright (c) 2014 Levelab. All rights reserved.
//

#import "LVKDefaultMessagePhotoItem.h"
#import "LVKPhotoAttachment.h"

@implementation LVKDefaultMessagePhotoItem

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

+ (CGSize)calculateContentSizeWithData:(LVKPhotoAttachment *)_data maxWidth:(CGFloat)_maxWidth {
    CGFloat scaleFactor = [_data.width floatValue] / [_data.height floatValue];
    CGFloat _maxHeight = 150.0f;
    CGFloat maxScaleFactor = (CGFloat)_maxWidth / _maxHeight;
    
    // TODO don't stretch
    if (scaleFactor > maxScaleFactor)
        return CGSizeMake(_maxWidth, [_data.height floatValue] * (_maxWidth / [_data.width floatValue]));
    return CGSizeMake([_data.width floatValue] * (_maxHeight / [_data.height floatValue]), _maxHeight);
}

- (void)dealloc {
    self.image = nil;
}


- (void)layoutIfNeededForCalculatedWidth:(CGFloat)_width alignRight:(BOOL)_alignRight {
    CGRect frame = self.frame;
    frame.size.width = _width;
    if (_alignRight) frame.origin.x = 0;
    self.frame = frame;
}

@end
