//
// Created by Leonid Repin on 09.06.14.
// Copyright (c) 2014 Levelab. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LVKMessageAttachment.h"

@interface LVKStickerAttachment : LVKMessageAttachment

@property (nonatomic) NSString *photo_64;
@property (nonatomic) NSString *photo_128;
@property (nonatomic) NSString *photo_256;
@property (nonatomic) NSNumber *height;
@property (nonatomic) NSNumber *width;

@end