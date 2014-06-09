//
// Created by Leonid Repin on 09.06.14.
// Copyright (c) 2014 Levelab. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LVKMessageAttachment.h"

@interface LVKDocumentAttachment : LVKMessageAttachment

@property (nonatomic) NSNumber *_id;
@property (nonatomic) NSNumber *size;
@property (nonatomic) NSString *url;

@end