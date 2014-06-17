//
//  LVKMessageTableViewCell.h
//  VKMessengerViews
//
//  Created by Eliah Nikans on 6/4/14.
//  Copyright (c) 2014 Levelab. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "LVKDefaultAbstractMessageTableViewCell.h"
#import "LVKDefaultMessagesCollectionView.h"
#import "LVKMessageCollectionViewDelegate.h"

@interface LVKDefaultCollectionViewMessageTableViewCell : LVKDefaultAbstractMessageTableViewCell

@property (weak, nonatomic) IBOutlet LVKDefaultMessagesCollectionView *collectionView;
//@property (weak, nonatomic) IBOutlet NSLayoutConstraint *collectionViewHeightConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *collectionViewWidthConstraint;

@property (strong, nonatomic) LVKMessageCollectionViewDelegate *collectionViewDelegate;

// TODO add delegate 4 cell
- (void)setCollectionViewDelegates:(id<UICollectionViewDataSource, UICollectionViewDelegate>)dataSourceDelegate forMessageWithIndexPath:(NSIndexPath *)indexPath;

@end
