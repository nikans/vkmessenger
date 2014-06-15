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

@interface LVKDefaultDialogTableViewCell ()

@property (nonatomic) CGFloat titleConstraintDefaultConstant;
@property (nonatomic) CGFloat defaultMargin;
@property (nonatomic) int avatarInset;
@property (strong, nonatomic) NSString *messageDefaultText;

@end



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

- (void)awakeFromNib {
    self.avatarInset = 2;
    self.defaultMargin = 10;
    
    self.isRoom = NO;
    
    self.titleConstraintDefaultConstant = self.titleConstraint.constant;
    self.messageDefaultText = self.message.text;
}

- (void)layoutSubviews {
    self.onlineIndicator.hidden = YES;
    self.onlineIndicator.layer.cornerRadius = 3.f;
    self.onlineIndicator.layer.masksToBounds = YES;
    
    self.titleConstraint.constant = self.defaultMargin;
//    self.messageInsetConstraint.constant = 0;
    
    self.avatarsView.layer.cornerRadius = 2.f;
    self.avatarsView.layer.masksToBounds = YES;
    
    self.messageBackground.layer.cornerRadius = 2.f;
    self.messageBackground.layer.masksToBounds = YES;
    
    self.messageAvatar.layer.cornerRadius = 2.f;
    self.messageAvatar.layer.masksToBounds = YES;
    
    self.roomIndicator.hidden = YES;
    if (self.isRoom) {
        self.roomIndicator.hidden = NO;
        self.titleConstraint.constant = self.titleConstraintDefaultConstant;
    }
}

- (void)prepareForReuse {
    for (UIView *avatar in self.avatarsView.subviews) {
        [avatar removeFromSuperview];
    }
    self.message.text = self.messageDefaultText;
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
        self.messageInsetConstraint.constant = self.defaultMargin;
        self.messageBackground.backgroundColor = [AVHexColor colorWithHexString:@"#edf2f7"];
    }
}

- (void)ajustLayoutUserIsOnline:(BOOL)isOnline {
    if (isOnline)
        self.onlineIndicator.hidden = NO;
    else
        self.onlineIndicator.hidden = YES;
}

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
    CGSize avatarSize = [self sizeForAvatarInPlace:place];
    CGPoint avatarOrigin = [self originForAvatarInPlace:place];
    CGRect avatarFrame = CGRectMake(avatarOrigin.x, avatarOrigin.y, avatarSize.width, avatarSize.height);
    UIImageView *avatar = [[UIImageView alloc] initWithFrame:avatarFrame];
    [avatar setImageWithURL:url];

    return avatar;
}

- (CGSize)sizeForAvatarInPlace:(AvatarPlace)place {
    CGRect baseFrame = self.avatarsView.frame;
    
    switch (place) {
        case Single:
            return self.avatarsView.frame.size;
            break;
        case FirstHalf: case SecondHalf:
            return CGSizeMake(baseFrame.size.width / 2 - self.avatarInset / 2, baseFrame.size.height);
            break;
        case FirstQarter: case SecondQuarter: case ThirdQuarter: case ForthQuarter:
            return CGSizeMake(baseFrame.size.width / 2 - self.avatarInset / 2, baseFrame.size.height / 2 - self.avatarInset / 2);
            break;
        default:
            break;
    }
}

- (CGPoint)originForAvatarInPlace:(AvatarPlace)place {
    CGRect baseFrame = self.avatarsView.frame;
    baseFrame.origin.x = 0; baseFrame.origin.y = 0;
    
    switch (place) {
        case Single: case FirstHalf: case FirstQarter:
            return baseFrame.origin;
            break;
        case SecondHalf: case SecondQuarter:
            return CGPointMake(baseFrame.origin.x + baseFrame.size.width / 2 + self.avatarInset / 2, baseFrame.origin.y);
            break;
        case ThirdQuarter:
            return CGPointMake(baseFrame.origin.x, baseFrame.origin.y + baseFrame.size.height / 2 + self.avatarInset / 2);
            break;
        case ForthQuarter:
            return CGPointMake(baseFrame.origin.x + baseFrame.size.width / 2 + self.avatarInset / 2, baseFrame.origin.y + baseFrame.size.height / 2 + self.avatarInset / 2);
            break;
        default:
            break;
    }

}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    // Configure the view for the selected state
}

@end
