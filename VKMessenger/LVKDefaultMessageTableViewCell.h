//
//  LVKMessageTableViewCell.h
//  VKMessengerViews
//
//  Created by Eliah Nikans on 6/4/14.
//  Copyright (c) 2014 Levelab. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LVKDefaultMessagesCollectionView.h"

static NSString *CollectionViewCellIdentifier = @"BodyItem";

@interface LVKDefaultMessageTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *avatarImage;
@property (weak, nonatomic) IBOutlet UIView *messageContainerView;
@property (weak, nonatomic) IBOutlet UIImageView *messageContainerBackgroundImage;
@property (nonatomic, weak) IBOutlet LVKDefaultMessagesCollectionView *collectionView;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *collectionViewHeightConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *messageContainerViewWidthConstraint;
@property (nonatomic) int minCollectionItemWidth;


@property (nonatomic) BOOL isOutgoing;

- (void)setCollectionViewDelegates:(id<UICollectionViewDataSource, UICollectionViewDelegate>)dataSourceDelegate forMessageWithIndexPath:(NSIndexPath *)indexPath;

- (void)setMinimumWidthForMessageContainer;

@end
