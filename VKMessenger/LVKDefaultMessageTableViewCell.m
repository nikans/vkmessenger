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

@implementation LVKDefaultMessageTableViewCell

@synthesize collectionViewDelegate;

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
    self.collectionViewWidthConstraint.constant = self.collectionViewMaxWidth;
    self.collectionViewHeightConstraint.constant = 0;
    
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
    
    [self.contentView layoutIfNeeded];
    
    // Status
    if (self.isUnread)
        self.backgroundColor = [AVHexColor colorWithHexString:@"#e1e9f5"];
    else
        self.backgroundColor = [UIColor clearColor];
    
    // Sending adversary's avatar to hell
    if (!self.isRoom && !self.isOutgoing) {
        self.avatarImage.hidden = YES;
        self.incomingMessageContainerConstraint.constant = 4;
    }
    
    // Tap action - go to message VC
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self.bubbleDelegate
                                                                                 action:@selector(pushToMessageVC:)];
    [self addGestureRecognizer:tapGesture];
    
    
    // Width & height

    self.collectionViewHeightConstraint.constant = self.collectionView.collectionViewLayout.collectionViewContentSize.height;
    
    NSInteger numberOfCells = [self.collectionView numberOfItemsInSection:0];
    UICollectionViewLayout *layout = self.collectionView.collectionViewLayout;
    CGFloat maxWidth = 0.0f;
    CGFloat height = 0.0f;
    for (NSInteger i = 0; i < numberOfCells; i++) {
        UICollectionViewLayoutAttributes *layoutAttributes = [layout layoutAttributesForItemAtIndexPath:[NSIndexPath indexPathForItem:i inSection:0]];
        CGRect cellFrame = layoutAttributes.frame;
        height += cellFrame.size.height;
        if (cellFrame.size.width > maxWidth) {
            maxWidth = cellFrame.size.width;
        }
//        [self.collectionView layoutSubviews];
    }
    
    for (NSInteger i = 0; i < numberOfCells; i++) {
        UICollectionViewCell *cell = [self.collectionView cellForItemAtIndexPath:[NSIndexPath indexPathForItem:i inSection:0]];
        if ([cell respondsToSelector:@selector(layoutIfNeededForCalculatedWidth:)]) {
            [(id<LVKMessageItemProtocol>)cell layoutIfNeededForCalculatedWidth:maxWidth];
        }
    }
    
    self.collectionViewHeightConstraint.constant = height + ([self.collectionView numberOfItemsInSection:0]-1)*5; // TODO
    self.collectionViewWidthConstraint.constant = maxWidth+0.5 < self.collectionViewMaxWidth ? maxWidth+0.5 : self.collectionViewMaxWidth;
}

-(void)setCollectionViewDelegates:(id<UICollectionViewDataSource, UICollectionViewDelegate>)dataSourceDelegate forMessageWithIndexPath:(NSIndexPath *)indexPath
{
    self.collectionViewDelegate = (LVKDialogCollectionViewDelegate *)dataSourceDelegate;
    self.collectionView.maxWidth = self.collectionViewMaxWidth;
    self.collectionView.dataSource = self.collectionViewDelegate;
    self.collectionView.delegate   = self.collectionViewDelegate;
    
    self.collectionView.messageIndexPath = indexPath;
    
    [self.collectionView reloadData];
}

- (void)setBubbleActionsDelegate:(id<LVKBubbleActionsDelegate>)delegate forMessageWithIndexPath:(NSIndexPath *)indexPath {
    self.bubbleDelegate = delegate;
    self.cellIndexPath = indexPath;
}

- (void)awakeFromNib
{
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
