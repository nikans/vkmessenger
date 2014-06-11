//
//  LVKMessagesCollectionView.m
//  VKMessengerViews
//
//  Created by Eliah Nikans on 6/5/14.
//  Copyright (c) 2014 Levelab. All rights reserved.
//

#import "LVKDefaultMessagesCollectionView.h"

@implementation LVKDefaultMessagesCollectionView

- (void)awakeFromNib {
    [self registerNib:[UINib nibWithNibName:@"LVKDefaultMessageBodyItem" bundle:[NSBundle mainBundle]] forCellWithReuseIdentifier:@"DefaultBodyItem"];
    [self registerNib:[UINib nibWithNibName:@"LVKDefaultMessageRepostBodyItem" bundle:[NSBundle mainBundle]] forCellWithReuseIdentifier:@"DefaultRepostBodyItem"];
    [self registerNib:[UINib nibWithNibName:@"LVKDefaultMessagePhotoItem" bundle:[NSBundle mainBundle]] forCellWithReuseIdentifier:@"DefaultPhotoItem"];
    [self registerNib:[UINib nibWithNibName:@"LVKDefaultMessageVideoItem" bundle:[NSBundle mainBundle]] forCellWithReuseIdentifier:@"DefaultVideoItem"];
    [self registerNib:[UINib nibWithNibName:@"LVKDefaultMessageStickerItem" bundle:[NSBundle mainBundle]] forCellWithReuseIdentifier:@"DefaultStickerItem"];
}

@end
