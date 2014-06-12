//
// Created by Leonid Repin on 09.06.14.
// Copyright (c) 2014 Levelab. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LVKMessageAttachment.h"

@interface LVKVideoAttachment : LVKMessageAttachment

@property (strong, nonatomic) NSString *photo_130;
@property (strong, nonatomic) NSString *photo_320;
@property (strong, nonatomic) NSNumber *_id;
@property (strong, nonatomic) NSString *title;
@property (strong, nonatomic) NSNumber *duration;

@end