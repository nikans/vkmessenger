//
//  LVKMessageBodyRepostItem.h
//  VKMessengerViews
//
//  Created by Eliah Nikans on 6/8/14.
//  Copyright (c) 2014 Levelab. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LVKMessageItemProtocol.h"

@interface LVKDefaultMessageRepostBodyItem : UICollectionViewCell <LVKMessageItemProtocol>

@property (weak, nonatomic) IBOutlet UIImageView *avatar;
@property (weak, nonatomic) IBOutlet UILabel *userName;
@property (weak, nonatomic) IBOutlet UILabel *date;
@property (weak, nonatomic) IBOutlet UILabel *body;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (weak, nonatomic) IBOutlet UIView *separatorView;

@end
