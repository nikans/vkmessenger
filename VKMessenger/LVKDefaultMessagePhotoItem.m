//
//  LVKMessagePictureItem.m
//  VKMessengerViews
//
//  Created by Eliah Nikans on 6/4/14.
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
    self.photo.image = [UIImage imageNamed:@"camera"];
    self.photo.layer.cornerRadius = 10;
    self.photo.layer.masksToBounds = YES;
}

+ (CGSize)calculateContentSizeWithData:(LVKPhotoAttachment *)_data maxWidth:(int)_maxWidth {
    CGFloat scaleFactor = [_data.width floatValue] / [_data.height floatValue];
    CGFloat _maxHeight = 150.0f;
    CGFloat maxScaleFactor = (CGFloat)_maxWidth / _maxHeight;
    
    // TODO don't stretch
    if (scaleFactor > maxScaleFactor)
        return CGSizeMake(_maxWidth, [_data.height floatValue] * (_maxWidth / [_data.width floatValue]));
    return CGSizeMake([_data.width floatValue] * (_maxHeight / [_data.height floatValue]), _maxHeight);
}

@end
