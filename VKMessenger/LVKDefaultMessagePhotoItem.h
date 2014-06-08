//
//  LVKMessagePictureItem.h
//  VKMessengerViews
//
//  Created by Eliah Nikans on 6/4/14.
//  Copyright (c) 2014 Levelab. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LVKMessageItemProtocol.h"

@interface LVKDefaultMessagePhotoItem : UICollectionViewCell <LVKMessageItemProtocol>

@property (weak, nonatomic) IBOutlet UIImageView *photo;

@end
