//
//  LVKMessageTableViewCell.m
//  VKMessengerViews
//
//  Created by Eliah Nikans on 6/4/14.
//  Copyright (c) 2014 Levelab. All rights reserved.
//

#import "LVKDefaultMessageTableViewCell.h"
#import "LVKDefaultMessageBodyItem.h"

@implementation LVKDefaultMessageTableViewCell

@synthesize minCollectionItemWidth;

-(void)layoutSubviews
{
    [super layoutSubviews];
    
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
    
    // Setting height
    [self.contentView layoutIfNeeded];
    CGFloat height = self.collectionView.collectionViewLayout.collectionViewContentSize.height;
    self.collectionViewHeightConstraint.constant = height;
    
    // Width
    NSInteger numberOfCells = [self.collectionView numberOfItemsInSection:0];
    UICollectionViewLayout *layout = self.collectionView.collectionViewLayout;
    CGFloat maxWidth = 0.0f;
    for (NSInteger i = 0; i < numberOfCells; i++) {
        UICollectionViewLayoutAttributes *layoutAttributes = [layout layoutAttributesForItemAtIndexPath:[NSIndexPath indexPathForItem:i inSection:0]];
        CGRect cellFrame = layoutAttributes.frame;
        if (cellFrame.size.width > maxWidth) {
            maxWidth = cellFrame.size.width;
            self.messageContainerViewWidthConstraint.constant = maxWidth+16.0f;
        }
//        [self.collectionView layoutSubviews];
    }
}

-(void)setCollectionViewDelegates:(id<UICollectionViewDataSource, UICollectionViewDelegate>)dataSourceDelegate forMessageWithIndexPath:(NSIndexPath *)indexPath
{
    self.collectionView.dataSource = dataSourceDelegate;
    self.collectionView.delegate   = dataSourceDelegate;
    
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
