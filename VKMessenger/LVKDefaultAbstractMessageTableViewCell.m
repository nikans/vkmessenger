//
//  LVKDefaultAbstractMessageTableViewCell.m
//  VKMessenger
//
//  Created by Eliah Nikans on 6/17/14.
//  Copyright (c) 2014 Levelab. All rights reserved.
//

#import "LVKDefaultAbstractMessageTableViewCell.h"
#import "LVKMessageItemProtocol.h"
#import "AVHexColor.h"

#define LVKDefaultCellBackgroundColorUnread  @"#e1e9f5"
#define LVKDefaultCellBackgroundColorFailed  @"#fbd3d3"

@implementation LVKDefaultAbstractMessageTableViewCell


#pragma mark - TableViewCell callbacks

- (void)layoutSubviews {
    [super layoutSubviews];
    
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
    // Making avatar cute and round
    self.avatarImage.layer.cornerRadius = 14;
    self.avatarImage.layer.masksToBounds = YES;
    
    
    // Adding bubble
    UIImage *bubble;
    UIEdgeInsets capInsets;
    
    if (self.isOutgoing)
        bubble = [UIImage imageNamed:@"default-bubbleOutgoing"];
    else
        bubble = [UIImage imageNamed:@"default-bubbleIncoming"];
    
    CGPoint center = CGPointMake(bubble.size.width / 2.0f, bubble.size.height / 2.0f);
    capInsets = UIEdgeInsetsMake(center.y, center.x, center.y, center.x);
    self.messageContainerBackgroundImage.image = [bubble resizableImageWithCapInsets:capInsets];
    
    
    // Status
    self.sendingActivityIndicator.hidden = YES;
    self.sentCheckImageView.hidden = YES;
    
    if (self.sandingState == Failed)
        self.backgroundColor = [AVHexColor colorWithHexString:LVKDefaultCellBackgroundColorFailed];
    else if (self.sandingState == Sending) {
        self.backgroundColor = [AVHexColor colorWithHexString:LVKDefaultCellBackgroundColorUnread];
        self.sendingActivityIndicator.hidden = NO;
    }
    else if (self.isUnread) {
        self.backgroundColor = [AVHexColor colorWithHexString:LVKDefaultCellBackgroundColorUnread];
    }
    else
        self.backgroundColor = [UIColor clearColor];
    
    
    // Tap action - go to message VC or resend
    if (self.sandingState == Failed) {
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self.bubbleDelegate
                                                                                     action:@selector(resendMessage:)];
        [self addGestureRecognizer:tapGesture];
    }
    else if(self.sandingState != Sending) {
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self.bubbleDelegate
                                                                                     action:@selector(pushToMessageVC:)];
        [self addGestureRecognizer:tapGesture];
    }

}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
}


#pragma mark - Init methods

- (void)setBubbleActionsDelegate:(id<LVKBubbleActionsDelegateProtocol>)delegate forMessageWithIndexPath:(NSIndexPath *)indexPath {
    self.bubbleDelegate = delegate;
    self.cellIndexPath = indexPath;
}



#pragma mark - Status callbacks

- (void)hasFailedToSentMessage {
    self.sendingActivityIndicator.hidden = YES;
    self.sentCheckImageView.hidden = YES;
    
    [UIView animateWithDuration:.5 animations:^{
        self.backgroundColor = [AVHexColor colorWithHexString:LVKDefaultCellBackgroundColorFailed];
    } completion:nil];
}

- (void)hasRetriedToSendMessage {
    self.sendingActivityIndicator.hidden = NO;
    self.sentCheckImageView.hidden = YES;
    
    [UIView animateWithDuration:.5 animations:^{
        self.backgroundColor = [AVHexColor colorWithHexString:LVKDefaultCellBackgroundColorUnread];
    } completion:nil];
}

- (void)hasSuccessfullySentMessage {
    self.sendingActivityIndicator.hidden = YES;
    self.sentCheckImageView.hidden = NO;
    self.backgroundColor = [AVHexColor colorWithHexString:LVKDefaultCellBackgroundColorUnread];
    
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self.bubbleDelegate
                                                                                 action:@selector(pushToMessageVC:)];
    [self addGestureRecognizer:tapGesture];
    
    [UIView animateWithDuration:2 animations:^{
        self.sentCheckImageView.alpha = 0;
    } completion:^(BOOL finished) {
        self.sentCheckImageView.hidden = YES;
        self.sentCheckImageView.alpha = 1;
    }];
}



#pragma mark - Lifecycle callbacks

- (void)awakeFromNib
{
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    return nil;
}

@end
