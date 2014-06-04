//
//  LVKAudioAttachment.h
//  VKMessenger
//
//  Created by Leonid Repin on 05.06.14.
//  Copyright (c) 2014 Levelab. All rights reserved.
//

#import "LVKMessageAttachment.h"

@interface LVKAudioAttachment : LVKMessageAttachment

@property (nonatomic) NSString *url;
@property (nonatomic) NSString *artist;
@property (nonatomic) NSString *title;
@property (nonatomic) NSNumber *duration;

@end
