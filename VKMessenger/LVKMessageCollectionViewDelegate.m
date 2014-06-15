//
//  LVKDialogCollectionViewDelegate.m
//  VKMessenger
//
//  Created by Eliah Nikans on 6/10/14.
//  Copyright (c) 2014 Levelab. All rights reserved.
//

#import "LVKMessageCollectionViewDelegate.h"

#import "LVKDefaultMessageTableViewCell.h"
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
    
    // Repost
    if([cellData isKindOfClass:[LVKRepostedMessage class]])
    {
        LVKDefaultMessageRepostBodyItem *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"DefaultRepostBodyItem" forIndexPath:indexPath];
        
        cell.body.text = [(LVKRepostedMessage *)cellData body];
        cell.date.text = [NSDateFormatter localizedStringFromDate:[(LVKRepostedMessage *)cellData date]
                                                        dateStyle:NSDateFormatterNoStyle
                                                        timeStyle:NSDateFormatterShortStyle];
        cell.userName.text = [(LVKRepostedMessage *)cellData user].fullName;
        [cell.avatar setImageWithURL:[(LVKRepostedMessage *)cellData user].photo_100];
        return cell;
    }
    
    // Full-width Body
    else if([cellData isKindOfClass:[LVKMessage class]] && collectionView.isFullWidth)
    {
        LVKDefaultMessageFullBodyItem *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"DefaultFullBodyItem" forIndexPath:indexPath];
        
        cell.body.text = [(LVKMessage *)cellData body];
        cell.date.text = [NSDateFormatter localizedStringFromDate:[(LVKMessage *)cellData date]
                                                        dateStyle:NSDateFormatterNoStyle
                                                        timeStyle:NSDateFormatterShortStyle];
        cell.userName.text = [(LVKMessage *)cellData user].fullName;
        [cell.avatar setImageWithURL:[(LVKMessage *)cellData user].photo_100];
        return cell;
    }
    
    // Body
    else if([cellData isKindOfClass:[LVKMessage class]])
    {
        LVKDefaultMessageBodyItem *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"DefaultBodyItem" forIndexPath:indexPath];
        cell.body.text = [(LVKMessage *)cellData body];
        return cell;
    }
    
    // Photo
    else if([cellData isKindOfClass:[LVKPhotoAttachment class]])
    {
        LVKDefaultMessagePhotoItem *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"DefaultPhotoItem" forIndexPath:indexPath];
        [cell.image setImageWithURL:[(LVKPhotoAttachment *)cellData photo_604]];
        return cell;
    }
    
    // Video
    else if([cellData isKindOfClass:[LVKVideoAttachment class]])
    {
        LVKDefaultMessageVideoItem *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"DefaultVideoItem" forIndexPath:indexPath];
        [cell.image setImageWithURL:[(LVKVideoAttachment *)cellData photo_130]];
        [cell setDurationWithSeconds:[[(LVKVideoAttachment *)cellData duration] intValue]];
        
        return cell;
    }
    
    // Sticker
    else if([cellData isKindOfClass:[LVKStickerAttachment class]])
    {
        LVKDefaultMessageStickerItem *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"DefaultStickerItem" forIndexPath:indexPath];
        [cell.image setImageWithURL:[(LVKStickerAttachment *)cellData photo_128]];
        return cell;
    }
    
    // Document
    else if([cellData isKindOfClass:[LVKDocumentAttachment class]])
    {
        LVKDefaultMessagePostItem *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"DefaultPostItem" forIndexPath:indexPath];
        cell.type = Document;
//        cell.title.text = [(LVKDocumentAttachment *)cellData ];
//        cell.subtitle.text =
    }
    
    // Wall post
    else if([cellData isKindOfClass:[LVKWallAttachment class]])
    {
        LVKDefaultMessagePostItem *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"DefaultPostItem" forIndexPath:indexPath];
        cell.type = Wall;
        cell.title.text = [(LVKWallAttachment *)cellData text];
        cell.subtitle.text = @"Wall post"; //TODO: localize!
    }
    
    // Body (probably empty)
    LVKDefaultMessageBodyItem *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"DefaultBodyItem" forIndexPath:indexPath];
    cell.body.text = @"";
    return cell;
}

// TODO
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
    
    // Repost
    if([cellData isKindOfClass:[LVKRepostedMessage class]])
        cellSize = [LVKDefaultMessageRepostBodyItem calculateContentSizeWithData:(LVKMessage *)cellData maxWidth:maxWidth minWidth:minWidth];
    
    // Full-width body
    else if([cellData isKindOfClass:[LVKMessage class]] && collectionView.isFullWidth)
        cellSize = [LVKDefaultMessageFullBodyItem calculateContentSizeWithData:(LVKMessage *)cellData maxWidth:maxWidth minWidth:minWidth];
    
    // Body
    else if([cellData isKindOfClass:[LVKMessage class]])
        cellSize = [LVKDefaultMessageBodyItem calculateContentSizeWithData:(LVKMessage *)cellData maxWidth:maxWidth minWidth:minWidth];
    
    // Photo
    else if([cellData isKindOfClass:[LVKPhotoAttachment class]])
        cellSize = [LVKDefaultMessagePhotoItem calculateContentSizeWithData:(LVKPhotoAttachment *)cellData maxWidth:maxWidth minWidth:minWidth];
    
    // Sticker
    else if([cellData isKindOfClass:[LVKStickerAttachment class]])
        cellSize = [LVKDefaultMessageStickerItem calculateContentSizeWithData:(LVKStickerAttachment *)cellData maxWidth:maxWidth minWidth:minWidth];
    
    // Video
    else if([cellData isKindOfClass:[LVKVideoAttachment class]])
        cellSize = [LVKDefaultMessageVideoItem calculateContentSizeWithData:(LVKVideoAttachment *)cellData maxWidth:maxWidth minWidth:minWidth];
    
    // Document
    else if([cellData isKindOfClass:[LVKDocumentAttachment class]])
        cellSize = [LVKDefaultMessagePostItem calculateContentSizeWithData:(LVKDocumentAttachment *)cellData maxWidth:maxWidth minWidth:minWidth];
    
    // Wall post
    else if([cellData isKindOfClass:[LVKWallAttachment class]])
        cellSize = [LVKDefaultMessagePostItem calculateContentSizeWithData:(LVKWallAttachment *)cellData maxWidth:maxWidth minWidth:minWidth];
    
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
    return [LVKDefaultMessageBodyItem class];
}



#pragma mark - Lifecycle callbacks

- (void)dealloc {
    self.data = nil;
}


@end
