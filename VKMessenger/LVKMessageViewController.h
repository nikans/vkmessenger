//
//  LVKMessageViewController.h
//  VKMessenger
//
//  Created by Leonid Repin on 05.06.14.
//  Copyright (c) 2014 Levelab. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <VKSdk.h>
#import <UIImageView+WebCache.h>

@class LVKDefaultMessagesCollectionView;
@class LVKMessage;
@class LVKMessageCollectionViewDelegate;

@interface LVKMessageViewController : UIViewController

@property (strong, nonatomic) LVKMessage *message;
@property (weak, nonatomic) IBOutlet LVKDefaultMessagesCollectionView *collectionView;
@property (strong, nonatomic) LVKMessageCollectionViewDelegate *collectionViewDelegate;

@end
