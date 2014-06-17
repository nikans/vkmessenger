//
//  LVKMessageTableViewCell.m
//  VKMessengerViews
//
//  Created by Eliah Nikans on 6/4/14.
//  Copyright (c) 2014 Levelab. All rights reserved.
//

#import "LVKDefaultCollectionViewMessageTableViewCell.h"

@implementation LVKDefaultCollectionViewMessageTableViewCell

@synthesize collectionViewDelegate;


#pragma mark - TableViewCell callbacks

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    self.collectionViewWidthConstraint.constant = self.messageItemsViewMaxWidth;
//    self.collectionViewHeightConstraint.constant = 0;
    
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
//        if (numberOfCells > 1) {
//            NSLog(@"%f - %@", maxWidth, self.timeLabel.text);
//        }
    }
    
    self.collectionView.minWidth = maxWidth;
    if (numberOfCells > 1)
        [self.collectionView reloadData];
    
//    if (numberOfCells > 0) {
//        for (NSInteger i = 0; i < numberOfCells; i++) {
//            UICollectionViewCell *cell = [self.collectionView cellForItemAtIndexPath:[NSIndexPath indexPathForItem:i inSection:0]];
//            if ([cell respondsToSelector:@selector(layoutIfNeededForCalculatedWidth:alignRight:)]) {
//                [(id<LVKMessageItemProtocol>)cell layoutIfNeededForCalculatedWidth:maxWidth alignRight:self.isOutgoing];
//            }
//        }
//    }
    
//    self.collectionViewHeightConstraint.constant = height + ([self.collectionView numberOfItemsInSection:0]-1)*5; // TODO
    self.collectionViewWidthConstraint.constant = maxWidth+1 < self.messageItemsViewMaxWidth ? maxWidth+1 : self.messageItemsViewMaxWidth;
}



#pragma mark - Init methods

-(void)setCollectionViewDelegates:(id<UICollectionViewDataSource, UICollectionViewDelegate>)dataSourceDelegate forMessageWithIndexPath:(NSIndexPath *)indexPath
{
    self.collectionViewDelegate = (LVKMessageCollectionViewDelegate *)dataSourceDelegate;
    self.collectionView.maxWidth   = self.messageItemsViewMaxWidth;
    self.collectionView.dataSource = self.collectionViewDelegate;
    self.collectionView.delegate   = self.collectionViewDelegate;
    
//    self.collectionView.messageIndexPath = indexPath;
    
    [self.collectionView reloadData];
}



#pragma mark - Lifecycle callbacks

- (void)awakeFromNib
{
    // Initialization code
}

- (void)prepareForReuse {
    self.collectionViewDelegate = nil;
    self.messageItemsViewMaxWidth = 0;
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
