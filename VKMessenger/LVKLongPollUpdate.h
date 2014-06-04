//
//  LVKLongPollUpdate.h
//  VKMessenger
//
//  Created by Leonid Repin on 04.06.14.
//  Copyright (c) 2014 Levelab. All rights reserved.
//

#import <Foundation/Foundation.h>

#define MESSAGE_OUTBOX (2)
#define MESSAGE_CHAT (16)

@interface LVKLongPollUpdate : NSObject

-(id)initWithArray:(NSArray *)array;

-(void)mapArrayToProperties:(NSArray *)array;

@end
