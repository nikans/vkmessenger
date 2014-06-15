//
//  LVKDefaultMessageVideoItem.h
//  VKMessenger
//
//  Created by Eliah Nikans on 6/9/14.
//  Copyright (c) 2014 Levelab. All rights reserved.
//

#import "LVKMessageItemProtocol.h"

@interface LVKDefaultMessageVideoItem : UICollectionViewCell <LVKMessageItemProtocol>

@property (weak, nonatomic) IBOutlet UIImageView *image;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *imageWidthConstraint;
@property (weak, nonatomic) IBOutlet UILabel *durationLabel;

- (void)setDurationWithSeconds:(int)_seconds;

@end
