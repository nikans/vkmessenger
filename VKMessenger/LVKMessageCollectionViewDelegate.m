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
    
    UICollectionViewCell *cell;
    
    // Repost
    if([cellData isKindOfClass:[LVKRepostedMessage class]])
    {
        cell = (LVKDefaultMessageRepostBodyItem *)[collectionView dequeueReusableCellWithReuseIdentifier:@"DefaultRepostBodyItem" forIndexPath:indexPath];
        [cell setValue:[(LVKRepostedMessage *)cellData body] forKeyPath:@"body.text"];
        [cell setValue:[NSDateFormatter localizedStringFromDate:
                        [(LVKRepostedMessage *)cellData date] dateStyle:NSDateFormatterNoStyle timeStyle:NSDateFormatterShortStyle] forKeyPath:@"date.text"];
        [cell setValue:[[(LVKRepostedMessage *)cellData user] fullName] forKeyPath:@"userName.text"];
        [[(LVKDefaultMessageRepostBodyItem *)cell avatar] setImageWithURL:[[(LVKRepostedMessage *)cellData user] photo_100]];
    }
    
    // Full-width Body
    else if([cellData isKindOfClass:[LVKMessage class]] && collectionView.isFullWidth) {
        cell = (LVKDefaultMessageFullBodyItem *)[collectionView dequeueReusableCellWithReuseIdentifier:@"DefaultFullBodyItem" forIndexPath:indexPath];
        [cell setValue:[(LVKMessage *)cellData body] forKeyPath:@"body.text"];
        [cell setValue:[NSDateFormatter localizedStringFromDate:
                        [(LVKMessage *)cellData date] dateStyle:NSDateFormatterNoStyle timeStyle:NSDateFormatterShortStyle] forKeyPath:@"date.text"];
        [cell setValue:[[(LVKMessage *)cellData user] fullName] forKeyPath:@"userName.text"];
        [[(LVKDefaultMessageRepostBodyItem *)cell avatar] setImageWithURL:[[(LVKMessage *)cellData user] photo_100]];
    }
    
    // Body
    else if([cellData isKindOfClass:[LVKMessage class]])
    {
        cell = (LVKDefaultMessageBodyItem *)[collectionView dequeueReusableCellWithReuseIdentifier:@"DefaultBodyItem" forIndexPath:indexPath];
        [cell setValue:[(LVKMessage *)cellData body] forKeyPath:@"body.text"];
    }
    
    // Photo
    else if([cellData isKindOfClass:[LVKPhotoAttachment class]])
    {
        cell = (LVKDefaultMessagePhotoItem *)[collectionView dequeueReusableCellWithReuseIdentifier:@"DefaultPhotoItem" forIndexPath:indexPath];
        [[(LVKDefaultMessagePhotoItem *)cell image] setImageWithURL:[(LVKPhotoAttachment *)cellData photo_604]];
    }
    
    // Video
    else if([cellData isKindOfClass:[LVKVideoAttachment class]])
    {
        cell = (LVKDefaultMessageVideoItem *)[collectionView dequeueReusableCellWithReuseIdentifier:@"DefaultVideoItem" forIndexPath:indexPath];
        [[(LVKDefaultMessageVideoItem *)cell image] setImageWithURL:[(LVKVideoAttachment *)cellData photo_130]];
        [[(LVKDefaultMessageVideoItem *)cell durationLabel] setText:[NSString stringWithFormat:@"%@", [(LVKVideoAttachment *)cellData duration]]];
    }
    
    // Sticker
    else if([cellData isKindOfClass:[LVKStickerAttachment class]])
    {
        cell = (LVKDefaultMessageStickerItem *)[collectionView dequeueReusableCellWithReuseIdentifier:@"DefaultStickerItem" forIndexPath:indexPath];
        [[(LVKDefaultMessageStickerItem *)cell image] setImageWithURL:[(LVKStickerAttachment *)cellData photo_128]];
    }
    
    
    // Body (probably empty)
    else
    {
        cell = (LVKDefaultMessageBodyItem *)[collectionView dequeueReusableCellWithReuseIdentifier:@"DefaultBodyItem" forIndexPath:indexPath];
        [cell setValue:@"" forKeyPath:@"body.text"];
    }
    
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
    CGFloat maxWidth = collectionView.isFullWidth ? 309.5 : collectionView.maxWidth - 0.5;
    
    // Repost
    if([cellData isKindOfClass:[LVKRepostedMessage class]])
        cellSize = [LVKDefaultMessageRepostBodyItem calculateContentSizeWithData:(LVKMessage *)cellData maxWidth:maxWidth];
    
    // Full-width body
    else if([cellData isKindOfClass:[LVKMessage class]] && collectionView.isFullWidth)
        cellSize = [LVKDefaultMessageFullBodyItem calculateContentSizeWithData:(LVKMessage *)cellData maxWidth:maxWidth];
    
    // Body
    else if([cellData isKindOfClass:[LVKMessage class]])
        cellSize = [LVKDefaultMessageBodyItem calculateContentSizeWithData:(LVKMessage *)cellData maxWidth:maxWidth];
    
    // Photo
    else if([cellData isKindOfClass:[LVKPhotoAttachment class]])
        cellSize = [LVKDefaultMessagePhotoItem calculateContentSizeWithData:(LVKPhotoAttachment *)cellData maxWidth:maxWidth];
    
    // Sticker
    else if([cellData isKindOfClass:[LVKStickerAttachment class]])
        cellSize = [LVKDefaultMessageStickerItem calculateContentSizeWithData:(LVKStickerAttachment *)cellData maxWidth:maxWidth];
    
    // Video
    else if([cellData isKindOfClass:[LVKVideoAttachment class]])
        cellSize = [LVKDefaultMessageVideoItem calculateContentSizeWithData:(LVKVideoAttachment *)cellData maxWidth:maxWidth];
    
    
    // Body (probably empty)
    else
        cellSize = [LVKDefaultMessageBodyItem calculateContentSizeWithData:[[LVKMessage alloc] init] maxWidth:maxWidth];
    
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
