//
//  LVKDefaultDialogTableViewCell.m
//  VKMessenger
//
//  Created by Eliah Nikans on 6/13/14.
//  Copyright (c) 2014 Levelab. All rights reserved.
//

#import "LVKDefaultDialogTableViewCell.h"
#import <AVHexColor.h>
#import <UIImageView+WebCache.h>

@implementation LVKDefaultDialogTableViewCell

typedef enum {
    Single,
    FirstHalf,
    SecondHalf,
    FirstQarter,
    SecondQuarter,
    ThirdQuarter,
    ForthQuarter
} AvatarPlace;

- (void)awakeFromNib
{
    // Initialization code
    self.onlineIndicator.hidden = YES;
    self.onlineIndicator.layer.cornerRadius = 3.f;
    self.onlineIndicator.layer.masksToBounds = YES;
    
    self.titleConstraint.constant = 10;
    self.messageInsetConstraint.constant = 0;
    
    self.avatarsView.layer.cornerRadius = 2.f;
    self.avatarsView.layer.masksToBounds = YES;
    
    self.messageBackground.layer.cornerRadius = 2.f;
    self.messageBackground.layer.masksToBounds = YES;
    
    self.roomIndicator.hidden = YES;
    
    self.avatarInset = 2;
}

- (void)ajustLayoutForReadState:(readState)state {
    if (state == Read) {
        self.messageInsetConstraint.constant = 0;
        self.messageBackground.backgroundColor = [UIColor clearColor];
        self.backgroundColor = [UIColor clearColor];
    }
    else if (state == UnreadIncoming) {
        self.backgroundColor = [AVHexColor colorWithHexString:@"#edf2f7"];
        self.messageInsetConstraint.constant = 0;
    }
    else if (state == UnreadOutgoing) {
        self.messageInsetConstraint.constant = 10;
        self.messageBackground.backgroundColor = [AVHexColor colorWithHexString:@"#edf2f7"];
    }
}

- (void)ajustLayoutUserIsOnline:(BOOL)isOnline {
    if (isOnline)
        self.onlineIndicator.hidden = NO;
    else
        self.onlineIndicator.hidden = YES;
}

// TODO: refactor
- (void)setAvatars:(NSArray *)avatarsURLArray {
    if ([avatarsURLArray isKindOfClass:[NSString class]]) 
        [self addAvatars:@[avatarsURLArray] withPlaces:@[@(Single)]];
    else if ([avatarsURLArray count] == 2)
        [self addAvatars:avatarsURLArray withPlaces:@[@(FirstHalf), @(SecondHalf)]];
    else if ([avatarsURLArray count] == 3)
        [self addAvatars:avatarsURLArray withPlaces:@[@(FirstHalf), @(SecondQuarter), @(ForthQuarter)]];
    else
        [self addAvatars:avatarsURLArray withPlaces:@[@(FirstQarter), @(SecondQuarter), @(ThirdQuarter), @(ForthQuarter)]];
}

- (void)addAvatars:(NSArray *)avatars withPlaces:(NSArray *)places {
    for (int i=0; i<[places count]; i++) {
        NSNumber *place = places[i];
        UIImageView *avatar = [self imageViewForAvatarAtPlace:[place intValue] withURL:(NSString *)avatars[i]];
        avatar.layer.cornerRadius = 2.f;
        avatar.layer.masksToBounds = YES;
        avatar.contentMode = UIViewContentModeScaleAspectFill;
        [self.avatarsView addSubview:avatar];
    }
}

- (UIImageView *)imageViewForAvatarAtPlace:(AvatarPlace)place withURL:(NSURL *)url {
    CGRect baseFrame = self.avatarsView.frame;
    baseFrame.origin.x = 0; baseFrame.origin.y = 0;
    UIImageView *avatar;
    
    switch (place) {
        case Single:
            avatar = [[UIImageView alloc] initWithFrame:baseFrame];
            [avatar setImageWithURL:url];
            return avatar;
            break;
        case FirstHalf:
            avatar = [[UIImageView alloc] initWithFrame:CGRectMake(baseFrame.origin.x, baseFrame.origin.y, [self avatarMetricDividedByHalf:baseFrame.size.width], baseFrame.size.height)];
            [avatar setImageWithURL:url];
            return avatar;
            break;
        case SecondHalf:
            avatar = [[UIImageView alloc] initWithFrame:CGRectMake([self avatarOrigin:baseFrame.origin.x addedByHalfMetric:baseFrame.size.width], baseFrame.origin.y, [self avatarMetricDividedByHalf:baseFrame.size.width], baseFrame.size.height)];
            [avatar setImageWithURL:url];
            return avatar;
            break;
        case FirstQarter:
            avatar = [[UIImageView alloc] initWithFrame:CGRectMake(baseFrame.origin.x, baseFrame.origin.y, [self avatarMetricDividedByHalf:baseFrame.size.width], [self avatarMetricDividedByHalf:baseFrame.size.height])];
            [avatar setImageWithURL:url];
            return avatar;
            break;
        case SecondQuarter:
            avatar = [[UIImageView alloc] initWithFrame:CGRectMake([self avatarOrigin:baseFrame.origin.x addedByHalfMetric:baseFrame.size.width], baseFrame.origin.y, [self avatarMetricDividedByHalf:baseFrame.size.width], [self avatarMetricDividedByHalf:baseFrame.size.height])];
            [avatar setImageWithURL:url];
            return avatar;
            break;
        case ThirdQuarter:
            avatar = [[UIImageView alloc] initWithFrame:CGRectMake(baseFrame.origin.x, [self avatarOrigin:baseFrame.origin.y addedByHalfMetric:baseFrame.size.height], [self avatarMetricDividedByHalf:baseFrame.size.width], [self avatarMetricDividedByHalf:baseFrame.size.height])];
            [avatar setImageWithURL:url];
            return avatar;
            break;
        case ForthQuarter:
            avatar = [[UIImageView alloc] initWithFrame:CGRectMake([self avatarOrigin:baseFrame.origin.x addedByHalfMetric:baseFrame.size.width], [self avatarOrigin:baseFrame.origin.y addedByHalfMetric:baseFrame.size.height], [self avatarMetricDividedByHalf:baseFrame.size.width], [self avatarMetricDividedByHalf:baseFrame.size.height])];
            [avatar setImageWithURL:url];
            return avatar;
            break;
            
        default:
            break;
    }
    
    return nil;
}

- (CGFloat)avatarMetricDividedByHalf:(CGFloat)metric {
    return metric / 2 - self.avatarInset / 2;
}
- (CGFloat)avatarOrigin:(CGFloat)origin addedByHalfMetric:(CGFloat)metric {
    return origin + metric / 2 + self.avatarInset / 2;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    // Configure the view for the selected state
}

@end
