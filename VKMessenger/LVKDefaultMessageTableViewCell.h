//
//  LVKMessageTableViewCell.h
//  VKMessengerViews
//
//  Created by Eliah Nikans on 6/4/14.
//  Copyright (c) 2014 Levelab. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LVKDefaultMessagesCollectionView.h"

#import "LVKModelEnums.h"

#import "LVKBubbleActionsDelegateProtocol.h"
#import "LVKMessageCollectionViewDelegate.h"

static NSString *CollectionViewCellIdentifier = @"BodyItem";

@interface LVKDefaultMessageTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *avatarImage;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;

@property (weak, nonatomic) IBOutlet UIView *messageContainerView;
@property (weak, nonatomic) IBOutlet UIImageView *messageContainerBackgroundImage;

@property (weak, nonatomic) id<LVKBubbleActionsDelegateProtocol> bubbleDelegate;
@property (strong, nonatomic) NSIndexPath *cellIndexPath;

@property (weak, nonatomic) IBOutlet LVKDefaultMessagesCollectionView *collectionView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *collectionViewHeightConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *collectionViewWidthConstraint;
@property (nonatomic) CGFloat collectionViewMaxWidth;

@property (strong, nonatomic) LVKMessageCollectionViewDelegate *collectionViewDelegate;

@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *sendingActivityIndicator;
@property (weak, nonatomic) IBOutlet UIImageView *sentCheckImageView;

@property (nonatomic) sendingState sandingState;
@property (nonatomic) BOOL isOutgoing;
@property (nonatomic) BOOL isRoom;
@property (nonatomic) BOOL isUnread;

// TODO add delegate 4 cell
- (void)setCollectionViewDelegates:(id<UICollectionViewDataSource, UICollectionViewDelegate>)dataSourceDelegate forMessageWithIndexPath:(NSIndexPath *)indexPath;
- (void)setBubbleActionsDelegate:(id<LVKBubbleActionsDelegateProtocol>)delegate forMessageWithIndexPath:(NSIndexPath *)indexPath;

- (void)hasFailedToSentMessage;
- (void)hasRetriedToSendMessage;
- (void)hasSuccessfullySentMessage;

@end
