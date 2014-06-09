//
//  LVKMessageTableViewCell.m
//  VKMessengerViews
//
//  Created by Eliah Nikans on 6/4/14.
//  Copyright (c) 2014 Levelab. All rights reserved.
//

#import "LVKDefaultMessageTableViewCell.h"
#import "LVKMessageItemProtocol.h"

@implementation LVKDefaultMessageTableViewCell

@synthesize minCollectionItemWidth, collectionViewDelegate;

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    self.messageContainerViewWidthConstraint.constant = 234;
    self.collectionViewHeightConstraint.constant = 0;
    
    // Making avatar cute and round
    self.avatarImage.layer.cornerRadius = 14;
    self.avatarImage.layer.masksToBounds = YES;
    
    //Adding bubble
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
    self.messageContainerViewWidthConstraint.constant = maxWidth+0.5;
}

-(void)setCollectionViewDelegates:(id<UICollectionViewDataSource, UICollectionViewDelegate>)dataSourceDelegate forMessageWithIndexPath:(NSIndexPath *)indexPath
{
    self.collectionViewDelegate = (LVKDialogCollectionViewDelegate *)dataSourceDelegate;
    
    self.collectionView.dataSource = self.collectionViewDelegate;
    self.collectionView.delegate   = self.collectionViewDelegate;
    
    self.collectionView.messageIndexPath = indexPath;
    
    [self.collectionView reloadData];
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
