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

-(void)layoutSubviews
{
    [super layoutSubviews];
    
//    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
//    layout.sectionInset = UIEdgeInsetsMake(10, 10, 9, 10);
//    layout.itemSize = CGSizeMake(320, 44);
//    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    [self.contentView layoutIfNeeded];
    
    CGFloat height = self.collectionView.collectionViewLayout.collectionViewContentSize.height;
    
    self.collectionViewHeightConstraint.constant = height;

    UIImage *bubble = [UIImage imageNamed:@"bubble_stroked"];
    CGPoint center = CGPointMake(bubble.size.width / 2.0f, bubble.size.height / 2.0f);
    UIEdgeInsets capInsets = UIEdgeInsetsMake(center.y, center.x, center.y, center.x);
    self.messageContainerBackgroundImage.image = [bubble resizableImageWithCapInsets:capInsets];

//    UIImage *bubble = [UIImage imageNamed:@"bubble_stroked"];
//    CGPoint center = CGPointMake(bubble.size.width / 2.0f, bubble.size.height / 2.0f);
//    UIEdgeInsets capInsets = UIEdgeInsetsMake(center.y, center.x, center.y, center.x);
////    UIColor *color = [UIColor colorWithRed:210.0/255.0 green:210.0/255.0 blue:215.0/255.0 alpha:1.0];
////    bubble = [self tintImage:bubble withColor:color];
////    UIImage *messageBubble = [bubble resizableImageWithCapInsets:UIEdgeInsetsMake(17, 27, 21, 17)];
//    
//    UIImageView *messageBubble = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.messageContainerView.frame.size.width, self.messageContainerView.frame.size.height)];
//    messageBubble.image = [bubble resizableImageWithCapInsets:capInsets];
//    [self.messageContainerView insertSubview:messageBubble atIndex:0];

//    self.collectionView.frame = self.contentView.bounds;
    
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
