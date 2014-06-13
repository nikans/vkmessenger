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

- (void)ajustLayoutLastMessageIsUnread:(BOOL)isUnread {
    if (isUnread) {
        self.messageInsetConstraint.constant = 10;
        self.messageBackground.backgroundColor = [AVHexColor colorWithHexString:@"#edf2f7"];
    }
    else {
        self.messageInsetConstraint.constant = 0;
        self.messageBackground.backgroundColor = [UIColor clearColor];
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
    if ([avatarsURLArray isKindOfClass:[NSString class]]) {
        UIImageView *avatar = [self imageViewForAvatarAtPlace:Single withURL:(NSString *)avatarsURLArray];
        [self.avatarsView addSubview:avatar];
    }
    
    else if ([avatarsURLArray count] == 2) {
        UIImageView *avatar1 = [self imageViewForAvatarAtPlace:FirstHalf withURL:(NSString *)avatarsURLArray[0]];
        [self.avatarsView addSubview:avatar1];
        UIImageView *avatar2 = [self imageViewForAvatarAtPlace:SecondHalf withURL:(NSString *)avatarsURLArray[1]];
        [self.avatarsView addSubview:avatar2];
    }
    
    else if ([avatarsURLArray count] == 3) {
        UIImageView *avatar1 = [self imageViewForAvatarAtPlace:FirstHalf withURL:(NSString *)avatarsURLArray[0]];
        [self.avatarsView addSubview:avatar1];
        UIImageView *avatar2 = [self imageViewForAvatarAtPlace:SecondQuarter withURL:(NSString *)avatarsURLArray[1]];
        [self.avatarsView addSubview:avatar2];
        UIImageView *avatar3 = [self imageViewForAvatarAtPlace:ForthQuarter withURL:(NSString *)avatarsURLArray[2]];
        [self.avatarsView addSubview:avatar3];
    }
    
    else if ([avatarsURLArray count] == 4) {
        UIImageView *avatar1 = [self imageViewForAvatarAtPlace:FirstQarter withURL:(NSString *)avatarsURLArray[0]];
        [self.avatarsView addSubview:avatar1];
        UIImageView *avatar2 = [self imageViewForAvatarAtPlace:SecondQuarter withURL:(NSString *)avatarsURLArray[1]];
        [self.avatarsView addSubview:avatar2];
        UIImageView *avatar3 = [self imageViewForAvatarAtPlace:ThirdQuarter withURL:(NSString *)avatarsURLArray[2]];
        [self.avatarsView addSubview:avatar3];
        UIImageView *avatar4 = [self imageViewForAvatarAtPlace:ForthQuarter withURL:(NSString *)avatarsURLArray[3]];
        [self.avatarsView addSubview:avatar4];
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
