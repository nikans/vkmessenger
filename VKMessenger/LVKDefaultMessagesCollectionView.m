//
//  LVKMessagesCollectionView.m
//  VKMessengerViews
//
//  Created by Eliah Nikans on 6/5/14.
//  Copyright (c) 2014 Levelab. All rights reserved.
//

#import "LVKDefaultMessagesCollectionView.h"

@implementation LVKDefaultMessagesCollectionView

@synthesize messageIndexPath;

- (id)initWithFrame:(CGRect)frame forMessageWithIndexPath:(NSIndexPath *)_messageIndexPath
{
    self = [super initWithFrame:frame];
    if (self) {
        self.messageIndexPath = _messageIndexPath;
        
    }
    return self;
}

- (void)awakeFromNib {
    [self registerNib:[UINib nibWithNibName:@"LVKDefaultMessageBodyItem"  bundle:[NSBundle mainBundle]] forCellWithReuseIdentifier:@"DefaultBodyItem"];
    [self registerNib:[UINib nibWithNibName:@"LVKDefaultMessagePhotoItem" bundle:[NSBundle mainBundle]] forCellWithReuseIdentifier:@"DefaultPhotoItem"];
    [self registerNib:[UINib nibWithNibName:@"LVKDefaultMessageRepostBodyItem"  bundle:[NSBundle mainBundle]] forCellWithReuseIdentifier:@"DefaultRepostBodyItem"];
}

@end
