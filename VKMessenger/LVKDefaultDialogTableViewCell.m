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
#import <QuartzCore/QuartzCore.h>
#import "UIImage+Extensions.h"
#import <UIKit/UIGraphics.h>
#import <UIImage+Resizing.h>

@interface LVKDefaultDialogTableViewCell ()

@property (nonatomic) CGFloat titleConstraintDefaultConstant;
@property (nonatomic) CGFloat defaultMargin;
@property (strong, nonatomic) NSString *messageDefaultText;

@property (nonatomic) int avatarInset;
@property (strong, nonatomic) NSMutableArray *avatarsArray;
@property (nonatomic) NSMutableArray *avatarsToDraw;

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
    
    self.avatarsToDraw = [NSMutableArray array];
    
    self.isRoom = NO;
    
    self.titleConstraintDefaultConstant = self.titleConstraint.constant;
    self.messageDefaultText = self.message.text;
    
    self.onlineIndicator.layer.cornerRadius = 3.f;
    self.onlineIndicator.clipsToBounds = YES;
    
    self.avatarsImageView.layer.cornerRadius = 2.f;
    self.avatarsImageView.clipsToBounds = YES;
    
    self.messageBackground.layer.cornerRadius = 2.f;
    self.messageBackground.clipsToBounds = YES;
    
    self.messageAvatar.layer.cornerRadius = 2.f;
    self.messageAvatar.clipsToBounds = YES;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    self.titleConstraint.constant = self.defaultMargin;

//    self.messageInsetConstraint.constant = 0;

    if (self.isRoom) {
        self.roomIndicator.hidden = NO;
        self.titleConstraint.constant = self.titleConstraintDefaultConstant;
    }
}

- (void)prepareForReuse {
    self.onlineIndicator.hidden = YES;
    self.roomIndicator.hidden = YES;
    
    self.avatarsImageView.image = nil;
    self.messageAvatar.image = nil;
    self.message.text = self.messageDefaultText;
    [self.avatarsToDraw removeAllObjects];
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

- (void)setAvatars:(id)avatarsURLArray {
    NSArray *urlArray;
    if ([avatarsURLArray isKindOfClass:[NSString class]])
//        urlArray = @[avatarsURLArray];
        [self.avatarsImageView setImageWithURL:avatarsURLArray];
    else {
        if ([avatarsURLArray count] > 4)
            urlArray = [avatarsURLArray subarrayWithRange:NSMakeRange(0, 4)];
        else
            urlArray = avatarsURLArray;
        
        [self loadAvatarImagesWithURLArray:urlArray];
    }
}

- (void)loadAvatarImagesWithURLArray:(NSArray *)urlArray {
    
    for (int i=0; i<[urlArray count]; i++) {
        NSURL *url = [NSURL URLWithString:urlArray[i]];
        
        [SDWebImageDownloader.sharedDownloader
         downloadImageWithURL:url
         options:0
         progress:^(NSInteger receivedSize, NSInteger expectedSize) {}
         completed:^(UIImage *image, NSData *data, NSError *error, BOOL finished)
         {
             if (image && finished)
             {
                 [self addImageToFinalAvatarImage:image targetQuantity:[urlArray count]];
             }
         }];
    }
}

- (NSArray *)avatarPlacesForAvatarsArray:(NSArray *)avatars {
    if ([avatars count] == 1)
        return @[@(Single)];
    else if ([avatars count] == 2)
        return @[@(FirstHalf), @(SecondHalf)];
    else if ([avatars count] == 3)
        return @[@(FirstHalf), @(SecondQuarter), @(ForthQuarter)];
    else
        return @[@(FirstQarter), @(SecondQuarter), @(ThirdQuarter), @(ForthQuarter)];
}

- (CGRect)avatarRectForPlace:(AvatarPlace)place {
    CGSize avatarSize = [self sizeForAvatarInPlace:place];
    CGPoint avatarOrigin = [self originForAvatarInPlace:place];
    return CGRectMake(avatarOrigin.x, avatarOrigin.y, avatarSize.width, avatarSize.height);
}

- (void)addImageToFinalAvatarImage:(UIImage *)partialImage targetQuantity:(NSUInteger)targetQuantity {
    
    [self.avatarsToDraw addObject:partialImage];
        
    if ([self.avatarsToDraw count] == targetQuantity) {
        [self drawFinalImage];
        
    }
}

- (void)drawFinalImage {
    
    UIGraphicsBeginImageContext(self.avatarsImageView.frame.size);
    
    NSArray *avatarsPlaces = [self avatarPlacesForAvatarsArray:self.avatarsToDraw];
    
    for (int i=0; i<[self.avatarsToDraw count] && i<4; i++) {
        UIImage *partialImage = self.avatarsToDraw[i];
        CGRect avatarRect = [self avatarRectForPlace:[(NSNumber *)avatarsPlaces[i] intValue]];

        partialImage = [partialImage scaleToSize:avatarRect.size usingMode:NYXResizeModeAspectFill];
        partialImage = [partialImage cropToSize:avatarRect.size usingMode:NYXCropModeCenter];
        partialImage = [partialImage makeRoundCornersWithRadius:2.f];
//        [[UIBezierPath bezierPathWithRoundedRect:avatarRect cornerRadius:2.0] addClip];
        
        [partialImage drawInRect:avatarRect];
    }

    UIImage *finalImage = UIGraphicsGetImageFromCurrentImageContext();
    self.avatarsImageView.image = finalImage;
    [self.controllerDelegate setImage:finalImage forIdentifier:self.identifier];
    
    UIGraphicsEndImageContext();

    [self.avatarsToDraw removeAllObjects];
}

- (CGSize)sizeForAvatarInPlace:(AvatarPlace)place {
    CGRect baseFrame = self.avatarsImageView.frame;
    
    switch (place) {
        case Single:
            return baseFrame.size;
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
    CGRect baseFrame = self.avatarsImageView.frame;
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
