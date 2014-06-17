//
//  LVKDefaultSinglePartMessageTableViewCell.h
//  VKMessenger
//
//  Created by Eliah Nikans on 6/17/14.
//  Copyright (c) 2014 Levelab. All rights reserved.
//

#import "LVKDefaultAbstractMessageTableViewCell.h"
#import "LVKMessageItemProtocol.h"

@interface LVKDefaultSingleItemMessageTableViewCell : LVKDefaultAbstractMessageTableViewCell

@property (strong, nonatomic) NSMutableArray *messageItems;
@property (nonatomic) CGFloat messageItemsContainerWidth;

- (void)addItemView:(UIView <LVKMessageItemProtocol> *)item withSize:(CGSize)size;

@end
