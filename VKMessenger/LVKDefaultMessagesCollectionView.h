//
//  LVKMessagesCollectionView.h
//  VKMessengerViews
//
//  Created by Eliah Nikans on 6/5/14.
//  Copyright (c) 2014 Levelab. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "LVKDefaultMessageBodyItem.h"
#import "LVKDefaultMessagePhotoItem.h"
#import "LVKDefaultMessageRepostBodyItem.h"

@interface LVKDefaultMessagesCollectionView : UICollectionView

@property (strong, nonatomic) NSIndexPath *messageIndexPath;
@property (nonatomic) BOOL isOutgoing;
@property (nonatomic) BOOL isRoom;
@property (nonatomic) CGFloat maxWidth;

@end
