//
//  LVKDialogCollectionViewDelegate.m
//  VKMessenger
//
//  Created by Eliah Nikans on 6/10/14.
//  Copyright (c) 2014 Levelab. All rights reserved.
//

#import "LVKDialogCollectionViewDelegate.h"

#import "LVKDefaultMessageTableViewCell.h"
#import "LVKDefaultMessagesCollectionView.h"
#import "LVKMessagePartProtocol.h"
#import "LVKRepostedMessage.h"
#import "LVKPhotoAttachment.h"
#import "LVKAudioAttachment.h"
#import "LVKStickerAttachment.h"
#import "LVKVideoAttachment.h"
#import <UIImageView+WebCache.h>

@implementation LVKDialogCollectionViewDelegate

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
    
    
    //    switch (itemType) {
    //        case bodyItem:
    //            cell = (LVKMessageBodyItem *)[collectionView dequeueReusableCellWithReuseIdentifier:@"BodyItem" forIndexPath:indexPath];
    //            [cell setValue:cellData[@"body"] forKeyPath:@"body.text"];
    //            break;
    //
    //        case photoItem:
    //            cell = (LVKMessagePhotoItem *)[collectionView dequeueReusableCellWithReuseIdentifier:@"PhotoItem" forIndexPath:indexPath];
    //            [cell setValue:[UIImage imageNamed:@"camera"] forKeyPath:@"photo.image"];
    //            break;
    //
    //        case repostBodyItem:
    //            cell = (LVKMessageRepostBodyItem *)[collectionView dequeueReusableCellWithReuseIdentifier:@"RepostBodyItem" forIndexPath:indexPath];
    //            [cell setValue:[UIImage imageNamed:@"camera"] forKeyPath:@"avatar.image"];
    //            [cell setValue:cellData[@"body"] forKeyPath:@"body.text"];
    //            [cell setValue:cellData[@"date"] forKeyPath:@"date.text"];
    //            [cell setValue:cellData[@"userName"] forKeyPath:@"userName.text"];
    //            break;
    //
    //
    //        default:
    //            break;
    //    }
    
    return cell;
}

//- (DefaultMessageItemType)collectionView:(LVKDefaultMessagesCollectionView *)collectionView typeOfItemAtIndexPath:(NSIndexPath *)indexPath {
//    return [[[self collectionView:collectionView dataForItemAtIndexPath:indexPath] objectForKey:@"type"] intValue];
//}

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

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(0,0,0,0);
}

- (CGSize)collectionView:(LVKDefaultMessagesCollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    id<LVKMessagePartProtocol> cellData = [self collectionView:collectionView dataForItemAtIndexPath:indexPath];
    
    CGSize cellSize;
    CGFloat maxWidth;
    
    // TODO smth
    LVKMessage *message = self.data;
    if([message isOutgoing])
        maxWidth = 233.5;
    else
        maxWidth = 195.5;
    
    // Body
    if([cellData isKindOfClass:[LVKMessage class]])
        cellSize = [LVKDefaultMessageBodyItem calculateContentSizeWithData:(LVKMessage *)cellData maxWidth:maxWidth];
    
    // Repost
    else if([cellData isKindOfClass:[LVKRepostedMessage class]])
        cellSize = [LVKDefaultMessageRepostBodyItem calculateContentSizeWithData:(LVKMessage *)cellData maxWidth:maxWidth];
    
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
    
    
    //    if (collectionView.maximumItemWidth < cellSize.width) {
    //        collectionView.maximumItemWidth = cellSize.width;
    //    }
    //
    //    NSLog(@"act %f", cellSize.width);
    //    cellSize = [LVKDefaultMessageBodyItem calculateContentSizeWithData:cellData];
    
    //    switch (itemType) {
    //        case bodyItem:
    //            cellSize = [LVKMessageBodyItem calculateContentSizeWithData:cellData];
    //            break;
    //
    //        case photoItem:
    //            cellSize = [LVKMessagePhotoItem calculateContentSizeWithData:cellData];
    //            break;
    //
    //        case repostBodyItem:
    //            cellSize = [LVKMessageRepostBodyItem calculateContentSizeWithData:cellData];
    //            break;
    //            
    //        default:
    //            break;
    //    }
    return cellSize;
}


@end
