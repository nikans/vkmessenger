//
//  LVKDefaultAbstractMessageTableViewCell.h
//  VKMessenger
//
//  Created by Eliah Nikans on 6/17/14.
//  Copyright (c) 2014 Levelab. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LVKModelEnums.h"
#import "LVKBubbleActionsDelegateProtocol.h"

@interface LVKDefaultAbstractMessageTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *avatarImage;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;

@property (weak, nonatomic) IBOutlet UIView *messageContainerView;
@property (weak, nonatomic) IBOutlet UIImageView *messageContainerBackgroundImage;

@property (weak, nonatomic) id<LVKBubbleActionsDelegateProtocol> bubbleDelegate;
@property (strong, nonatomic) NSIndexPath *cellIndexPath;

@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *sendingActivityIndicator;
@property (weak, nonatomic) IBOutlet UIImageView *sentCheckImageView;

@property (nonatomic) CGFloat messageItemsViewMaxWidth;

@property (nonatomic) sendingState sandingState;
@property (nonatomic) BOOL isOutgoing;
@property (nonatomic) BOOL isRoom;
@property (nonatomic) BOOL isUnread;

- (void)setBubbleActionsDelegate:(id<LVKBubbleActionsDelegateProtocol>)delegate forMessageWithIndexPath:(NSIndexPath *)indexPath;

- (void)hasFailedToSentMessage;
- (void)hasRetriedToSendMessage;
- (void)hasSuccessfullySentMessage;

@end
