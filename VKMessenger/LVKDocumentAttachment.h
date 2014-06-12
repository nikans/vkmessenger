//
// Created by Leonid Repin on 09.06.14.
// Copyright (c) 2014 Levelab. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LVKMessageAttachment.h"

@interface LVKDocumentAttachment : LVKMessageAttachment

@property (strong, nonatomic) NSNumber *_id;
@property (strong, nonatomic) NSNumber *size;
@property (strong, nonatomic) NSString *url;

@end