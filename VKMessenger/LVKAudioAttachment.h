//
//  LVKAudioAttachment.h
//  VKMessenger
//
//  Created by Leonid Repin on 05.06.14.
//  Copyright (c) 2014 Levelab. All rights reserved.
//

#import "LVKMessageAttachment.h"

@interface LVKAudioAttachment : LVKMessageAttachment

@property (strong, nonatomic) NSString *url;
@property (strong, nonatomic) NSString *artist;
@property (strong, nonatomic) NSString *title;
@property (strong, nonatomic) NSNumber *duration;

@end
