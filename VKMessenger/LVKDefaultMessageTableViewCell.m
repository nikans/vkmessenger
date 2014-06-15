//
//  LVKMessageTableViewCell.m
//  VKMessengerViews
//
//  Created by Eliah Nikans on 6/4/14.
//  Copyright (c) 2014 Levelab. All rights reserved.
//

#import "LVKDefaultMessageTableViewCell.h"
#import "LVKMessageItemProtocol.h"
#import "AVHexColor.h"

#define LVKDefaultCellBackgroundColorUnread  @"#e1e9f5"
#define LVKDefaultCellBackgroundColorFailed  @"#fbd3d3"

@implementation LVKDefaultMessageTableViewCell

@synthesize collectionViewDelegate;


#pragma mark - TableViewCell callbacks

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
    self.collectionViewWidthConstraint.constant = self.collectionViewMaxWidth;
//    self.collectionViewHeightConstraint.constant = 0;
    
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
    
    // Sending adversary's avatar to hell
    if (!self.isRoom && !self.isOutgoing) {
        self.avatarImage.hidden = YES;
        self.incomingMessageContainerConstraint.constant = 4;
    }
    
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
    
    
    // Width & height
    [self.contentView layoutIfNeeded];

//    self.collectionViewHeightConstraint.constant = self.collectionView.collectionViewLayout.collectionViewContentSize.height;
    
    NSInteger numberOfCells = [self.collectionView numberOfItemsInSection:0];
    UICollectionViewLayout *layout = self.collectionView.collectionViewLayout;
    CGFloat maxWidth = 0.0f;
//    CGFloat height = 0.0f;
    for (NSInteger i = 0; i < numberOfCells; i++) {
        UICollectionViewLayoutAttributes *layoutAttributes = [layout layoutAttributesForItemAtIndexPath:[NSIndexPath indexPathForItem:i inSection:0]];
        CGRect cellFrame = layoutAttributes.frame;
//        height += cellFrame.size.height;
        if (cellFrame.size.width > maxWidth) {
            maxWidth = cellFrame.size.width;
        }
//        [self.collectionView layoutSubviews];
    }
    
    if (numberOfCells > 0) {
        for (NSInteger i = 0; i < numberOfCells; i++) {
            UICollectionViewCell *cell = [self.collectionView cellForItemAtIndexPath:[NSIndexPath indexPathForItem:i inSection:0]];
            if ([cell respondsToSelector:@selector(layoutIfNeededForCalculatedWidth:alignRight:)]) {
                [(id<LVKMessageItemProtocol>)cell layoutIfNeededForCalculatedWidth:maxWidth alignRight:self.isOutgoing];
            }
        }
    }
    
//    self.collectionViewHeightConstraint.constant = height + ([self.collectionView numberOfItemsInSection:0]-1)*5; // TODO
    self.collectionViewWidthConstraint.constant = maxWidth+1 < self.collectionViewMaxWidth ? maxWidth+1 : self.collectionViewMaxWidth;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}



#pragma mark - Init methods

-(void)setCollectionViewDelegates:(id<UICollectionViewDataSource, UICollectionViewDelegate>)dataSourceDelegate forMessageWithIndexPath:(NSIndexPath *)indexPath
{
    self.collectionViewDelegate = (LVKMessageCollectionViewDelegate *)dataSourceDelegate;
    self.collectionView.maxWidth = self.collectionViewMaxWidth;
    self.collectionView.dataSource = self.collectionViewDelegate;
    self.collectionView.delegate   = self.collectionViewDelegate;
    
//    self.collectionView.messageIndexPath = indexPath;
    
    [self.collectionView reloadData];
}

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
    // Initialization code
}

- (void)prepareForReuse {
    self.collectionViewDelegate = nil;
}

- (void)dealloc {
    self.avatarImage = nil;
    self.timeLabel = nil;
    self.messageContainerView = nil;
    self.messageContainerBackgroundImage = nil;
    self.bubbleDelegate = nil;
    self.cellIndexPath = nil;
    self.collectionView = nil;
    self.collectionViewDelegate = nil;
    self.sendingActivityIndicator = nil;
    self.sentCheckImageView = nil;
}

@end
