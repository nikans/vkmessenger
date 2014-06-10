//
//  LVKMessageTableViewCell.h
//  VKMessengerViews
//
//  Created by Eliah Nikans on 6/4/14.
//  Copyright (c) 2014 Levelab. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LVKDefaultMessagesCollectionView.h"

#import "LVKDefaultMessageBodyItem.h"
#import "LVKDefaultMessageRepostBodyItem.h"
#import "LVKDefaultMessagePhotoItem.h"
#import "LVKDefaultMessageStickerItem.h"
#import "LVKDefaultMessageVideoItem.h"

#import "LVKBubbleActionsDelegate.h"
#import "LVKDialogCollectionViewDelegate.h"

static NSString *CollectionViewCellIdentifier = @"BodyItem";

@interface LVKDefaultMessageTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *avatarImage;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;

@property (weak, nonatomic) IBOutlet UIView *messageContainerView;
@property (weak, nonatomic) IBOutlet UIImageView *messageContainerBackgroundImage;

@property (weak, nonatomic) id<LVKBubbleActionsDelegate> bubbleDelegate;
@property (strong, nonatomic) NSIndexPath *cellIndexPath;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *incomingMessageContainerConstraint;
@property (nonatomic, weak) IBOutlet LVKDefaultMessagesCollectionView *collectionView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *collectionViewHeightConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *collectionViewWidthConstraint;
@property (nonatomic) CGFloat collectionViewMaxWidth;

@property (strong, nonatomic) LVKDialogCollectionViewDelegate *collectionViewDelegate;

@property (nonatomic) BOOL isOutgoing;
@property (nonatomic) BOOL isRoom;
@property (nonatomic) BOOL isUnread;

- (void)setCollectionViewDelegates:(id<UICollectionViewDataSource, UICollectionViewDelegate>)dataSourceDelegate forMessageWithIndexPath:(NSIndexPath *)indexPath;
- (void)setBubbleActionsDelegate:(id<LVKBubbleActionsDelegate>)delegate forMessageWithIndexPath:(NSIndexPath *)indexPath;

@end
