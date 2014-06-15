//
//  LVKDefaultMessageVideoItem.h
//  VKMessenger
//
//  Created by Eliah Nikans on 6/9/14.
//  Copyright (c) 2014 Levelab. All rights reserved.
//

#import "LVKMessageItemProtocol.h"

typedef enum {
    Wall,
    Document,
    Message
} PostType;

@interface LVKDefaultMessagePostItem : UICollectionViewCell <LVKMessageItemProtocol>

@property (nonatomic) PostType type;
@property (weak, nonatomic) IBOutlet UIImageView *icon;
@property (weak, nonatomic) IBOutlet UILabel *title;
@property (weak, nonatomic) IBOutlet UILabel *subtitle;

@end
