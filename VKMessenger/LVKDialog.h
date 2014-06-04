//
//  LVKDialog.h
//  VKMessenger
//
//  Created by Leonid Repin on 03.06.14.
//  Copyright (c) 2014 Levelab. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LVKMessage.h"

typedef enum DialogTypes {
    Room,
    Dialog
} dialogType;

@interface LVKDialog : NSObject

@property (nonatomic) NSString *title;
@property (nonatomic) NSNumber *chatId;
@property (nonatomic) NSNumber *userId;
@property (nonatomic) dialogType type;
@property (nonatomic) LVKMessage *lastMessage;

-(id)initWithDictionary:(NSDictionary *)dictionary;

@end
