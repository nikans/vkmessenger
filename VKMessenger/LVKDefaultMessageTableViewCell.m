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
    
//    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
//    layout.sectionInset = UIEdgeInsetsMake(10, 10, 9, 10);
//    layout.itemSize = CGSizeMake(320, 44);
//    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    
    // Setting height
    [self.contentView layoutIfNeeded];
    CGFloat height = self.collectionView.collectionViewLayout.collectionViewContentSize.height;
    self.collectionViewHeightConstraint.constant = height;

    
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
}

-(void)setCollectionViewDelegates:(id<UICollectionViewDataSource, UICollectionViewDelegate>)dataSourceDelegate forMessageWithIndexPath:(NSIndexPath *)indexPath
{
    self.collectionView.dataSource = dataSourceDelegate;
    self.collectionView.delegate   = dataSourceDelegate;
    
    self.collectionView.messageIndexPath = indexPath;
    
    
    [self.collectionView reloadData];
}


- (void)setMinimumWidthForMessageContainer {
//    self.messageContainerViewWidthConstraint.constant = self.collectionView.maximumItemWidth+10;
//    NSLog(@"%f", self.collectionView.contentSize.width);
//    self.collectionView.contentSize = CGSizeMake(100, self.collectionView.contentSize.height);
//    [self.collectionView layoutSubviews];
    //    LVKDefaultMessageTableViewCell *messageCell = (LVKDefaultMessageTableViewCell *)[self.tableView cellForRowAtIndexPath:collectionView.messageIndexPath];
    //    if (messageCell.minCollectionItemWidth > cellSize.width + 10) {
    //        messageCell.minCollectionItemWidth = cellSize.width + 10;
    //    }
    
    //    if (messageCell.messageContainerViewWidthConstraint.constant > cellSize.width + 10) {
    //        messageCell.messageContainerViewWidthConstraint.constant = cellSize.width + 10;
    //    }

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
