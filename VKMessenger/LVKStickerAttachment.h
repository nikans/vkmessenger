//
// Created by Leonid Repin on 09.06.14.
// Copyright (c) 2014 Levelab. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LVKMessageAttachment.h"

@interface LVKStickerAttachment : LVKMessageAttachment

@property (strong, nonatomic) NSString *photo_64;
@property (strong, nonatomic) NSString *photo_128;
@property (strong, nonatomic) NSString *photo_256;
@property (strong, nonatomic) NSNumber *height;
@property (strong, nonatomic) NSNumber *width;

@end