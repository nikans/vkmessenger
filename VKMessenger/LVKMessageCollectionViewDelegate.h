//
//  LVKDialogCollectionViewDelegate.h
//  VKMessenger
//
//  Created by Eliah Nikans on 6/10/14.
//  Copyright (c) 2014 Levelab. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LVKMessage.h"

#import "LVKDefaultMessageBodyItem.h"
#import "LVKDefaultMessageRepostBodyItem.h"
#import "LVKDefaultMessagePhotoItem.h"
#import "LVKDefaultMessageStickerItem.h"
#import "LVKDefaultMessageVideoItem.h"
#import "LVKDefaultMessageFullBodyItem.h"

@interface LVKMessageCollectionViewDelegate : NSObject <UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout>

@property (strong, nonatomic) LVKMessage *data;

- (id)initWithData:(LVKMessage *)_data;
+ (Class)classForViewItemBasedOnDataPartClass:(Class)dataPartClass;

@end
