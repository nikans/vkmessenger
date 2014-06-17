//
//  LVKDefaultSinglePartMessageTableViewCell.m
//  VKMessenger
//
//  Created by Eliah Nikans on 6/17/14.
//  Copyright (c) 2014 Levelab. All rights reserved.
//

#import "LVKDefaultSingleItemMessageTableViewCell.h"

@implementation LVKDefaultSingleItemMessageTableViewCell

#pragma mark - TableViewCell callbacks

- (void)layoutSubviews {
    [super layoutSubviews];
    
    for (UIView *subviewItem in self.messageItems) {
        subviewItem.translatesAutoresizingMaskIntoConstraints = NO;
        [self.messageContainerView addSubview:subviewItem];
        
        [subviewItem addConstraint:
         [NSLayoutConstraint constraintWithItem:subviewItem attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:self.messageItemsContainerWidth]];
        
        [self.messageContainerView addConstraint:
         [NSLayoutConstraint constraintWithItem:subviewItem attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.messageContainerView attribute:NSLayoutAttributeTop multiplier:1.0 constant:5.0]];
        
        [self.messageContainerView addConstraint:
         [NSLayoutConstraint constraintWithItem:subviewItem attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self.messageContainerView attribute:NSLayoutAttributeLeading multiplier:1.0 constant:self.isOutgoing ? 5.0 : 11.0]];
        
        [self.messageContainerView addConstraint:
         [NSLayoutConstraint constraintWithItem:subviewItem  attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.messageContainerView attribute:NSLayoutAttributeBottom multiplier:1.0 constant:-5.0]];
        
        [self.messageContainerView addConstraint:
         [NSLayoutConstraint constraintWithItem:subviewItem attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:self.messageContainerView attribute:NSLayoutAttributeTrailing multiplier:1.0 constant:self.isOutgoing ? -11.0 : -5.0]];
    }
    [self setNeedsUpdateConstraints];
    
//    self.messageItemsContainerWidthConstraint.constant = self.messageItemsContainerWidth;
//    self.messagePartContainerWidthConstraint.constant = maxWidth+1 < self.messagePartsViewMaxWidth ? maxWidth+1 : self.messagePartsViewMaxWidth;
}

- (void)addItemView:(UIView <LVKMessageItemProtocol> *)item withSize:(CGSize)size {
    
    self.messageItemsContainerWidth = size.width;
    [self.messageItems addObject:item];
}

- (void)setMessageItemsContainerWidth:(CGFloat)messageItemsContainerWidth {
    _messageItemsContainerWidth = messageItemsContainerWidth == 0 ? 0 :
    messageItemsContainerWidth > self.messageItemsViewMaxWidth ? self.messageItemsViewMaxWidth :
    messageItemsContainerWidth > _messageItemsContainerWidth ? messageItemsContainerWidth : _messageItemsContainerWidth;
}

//- (void)updateConstraints
//{
//    [super updateConstraints];
//    
//    if ([self.messageItemsContainer.subviews count] > 0) {
//        UIView *subviewItem = self.messageItemsContainer.subviews[0];
//    
//            }
//}


#pragma mark - Lifecycle callbacks

- (void)awakeFromNib
{
    self.messageItems = [NSMutableArray array];
}

- (void)prepareForReuse {
    for (UIView *subview in self.messageContainerView.subviews) {
        if ([subview isKindOfClass:[UIImageView class]]) continue;
        [subview removeFromSuperview];
    }
    self.messageItemsContainerWidth = 0;
    [self.messageItems removeAllObjects];
}

//- (void)dealloc {
//    self.avatarImage = nil;
//    self.timeLabel = nil;
//    self.messageContainerView = nil;
//    self.messageContainerBackgroundImage = nil;
//    self.bubbleDelegate = nil;
//    self.cellIndexPath = nil;
//    self.sendingActivityIndicator = nil;
//    self.sentCheckImageView = nil;
//}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
