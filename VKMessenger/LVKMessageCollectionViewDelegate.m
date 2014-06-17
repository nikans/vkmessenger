//
//  LVKDialogCollectionViewDelegate.m
//  VKMessenger
//
//  Created by Eliah Nikans on 6/10/14.
//  Copyright (c) 2014 Levelab. All rights reserved.
//

#import "LVKMessageCollectionViewDelegate.h"

#import "LVKDefaultCollectionViewMessageTableViewCell.h"
#import "LVKDefaultMessagesCollectionView.h"
#import "LVKMessagePartProtocol.h"
#import "LVKMessageItemProtocol.h"
#import "LVKRepostedMessage.h"
#import "LVKPhotoAttachment.h"
#import "LVKAudioAttachment.h"
#import "LVKStickerAttachment.h"
#import "LVKVideoAttachment.h"
#import "LVKDocumentAttachment.h"
#import "LVKWallAttachment.h"
#import <UIImageView+WebCache.h>

@implementation LVKMessageCollectionViewDelegate

@synthesize data;

- (id)initWithData:(LVKMessage *)_data {
    self = [super init];
    if (self) {
        self.data = _data;
    }
    return self;
}



#pragma mark - UICollectionView Datasource

// TODO
- (NSInteger)collectionView:(LVKDefaultMessagesCollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return [self.data getMessageParts].count;
}

- (UICollectionViewCell *)collectionView:(LVKDefaultMessagesCollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    id<LVKMessagePartProtocol> cellData = [self collectionView:collectionView dataForItemAtIndexPath:indexPath];
    UICollectionViewCell <LVKMessageItemProtocol> *cell;
   
    // Full-width Body
    // TODO: FIX THAT
    if([cellData isKindOfClass:[LVKMessage class]] && collectionView.isFullWidth)
        cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"DefaultFullBodyItem" forIndexPath:indexPath];
    
    NSString *reuseIdentifier = [self reuseIdentifierForCellInCollectionView:collectionView basedOnDataPartClass:[cellData class]];
    
    // Repost
    if([cellData isKindOfClass:[LVKRepostedMessage class]])
        cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"DefaultRepostBodyItem" forIndexPath:indexPath];
    
    else if(reuseIdentifier != nil)
        cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
    
    // Body (probably empty)
    else
        cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"DefaultBodyItem" forIndexPath:indexPath];
    
    [cell layoutData:cellData];
    return cell;
}

- (id<LVKMessagePartProtocol>)collectionView:(LVKDefaultMessagesCollectionView *)collectionView dataForItemAtIndexPath:(NSIndexPath *)indexPath {
    return [[self.data getMessageParts] objectAtIndex:indexPath.row];
}



#pragma mark - UICollectionViewDelegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    // TODO: Select Item
}
- (void)collectionView:(UICollectionView *)collectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath {
    // TODO: Deselect item
}



#pragma mark – UICollectionViewDelegateFlowLayout

- (UIEdgeInsets)collectionView:(LVKDefaultMessagesCollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    if (collectionView.isFullWidth)
        return UIEdgeInsetsMake(10,5,10,5);
    return UIEdgeInsetsMake(0,0,0,0);
}

- (CGSize)collectionView:(LVKDefaultMessagesCollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    id<LVKMessagePartProtocol> cellData = [self collectionView:collectionView dataForItemAtIndexPath:indexPath];
    
    CGSize cellSize;
    CGFloat maxWidth = collectionView.isFullWidth ? 309.5 : collectionView.maxWidth - 2;
    CGFloat minWidth = collectionView.minWidth;
    
    Class itemClass = [LVKMessageCollectionViewDelegate classForViewItemBasedOnDataPartClass:[cellData class]];
    
    // Full-width Body
    // TODO: FIX THAT
    if ([cellData isKindOfClass:[LVKMessage class]] && collectionView.isFullWidth)
        cellSize = [LVKDefaultMessageFullBodyItem calculateContentSizeWithData:(LVKMessage *)cellData maxWidth:maxWidth minWidth:minWidth];
    
    else if (itemClass != nil)
        cellSize = [itemClass calculateContentSizeWithData:cellData maxWidth:maxWidth minWidth:minWidth];
    
    // Body (probably empty)
    else
        cellSize = [LVKDefaultMessageBodyItem calculateContentSizeWithData:[[LVKMessage alloc] init] maxWidth:maxWidth minWidth:minWidth];
    
    if (cellSize.width > maxWidth)
        cellSize = CGSizeMake(maxWidth, cellSize.height);
 
    return cellSize;
}

// TODO use it here
+ (Class)classForViewItemBasedOnDataPartClass:(Class)dataPartClass {
    if (dataPartClass == [LVKRepostedMessage class])
        return [LVKDefaultMessageRepostBodyItem class];
    if (dataPartClass == [LVKMessage class])
        return [LVKDefaultMessageBodyItem class];
    if (dataPartClass == [LVKPhotoAttachment class])
        return [LVKDefaultMessagePhotoItem class];
    if (dataPartClass == [LVKStickerAttachment class])
        return [LVKDefaultMessageStickerItem class];
    if (dataPartClass == [LVKVideoAttachment class])
        return [LVKDefaultMessageVideoItem class];
    if (dataPartClass == [LVKDocumentAttachment class])
        return [LVKDefaultMessagePostItem class];
    if (dataPartClass == [LVKWallAttachment class])
        return [LVKDefaultMessagePostItem class];
    return nil;
}

- (NSString *)reuseIdentifierForCellInCollectionView:(LVKDefaultMessagesCollectionView *)collectionView basedOnDataPartClass:(Class)dataPartClass {
    if (dataPartClass == [LVKRepostedMessage class])
        return @"DefaultRepostBodyItem";
    if (dataPartClass == [LVKMessage class])
        return @"DefaultBodyItem";
    if (dataPartClass == [LVKPhotoAttachment class])
        return @"DefaultPhotoItem";
    if (dataPartClass == [LVKStickerAttachment class])
        return @"DefaultStickerItem";
    if (dataPartClass == [LVKVideoAttachment class])
        return @"DefaultVideoItem";
    if (dataPartClass == [LVKDocumentAttachment class])
        return @"DefaultPostItem";
    if (dataPartClass == [LVKWallAttachment class])
        return @"DefaultPostItem";
    return nil;
}


#pragma mark - Lifecycle callbacks

- (void)dealloc {
    self.data = nil;
}


@end
