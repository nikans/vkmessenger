//
//  LVKLongPollUpdatesCollection.h
//  VKMessenger
//
//  Created by Leonid Repin on 04.06.14.
//  Copyright (c) 2014 Levelab. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LVKLongPollUpdate.h"

@interface LVKLongPollUpdatesCollection : NSObject

@property (nonatomic) NSArray *updates;

-(id)initWithArray:(NSArray *)array;

-(void)postNotifications;

@end
