//
//  LVKDialog.h
//  VKMessenger
//
//  Created by Leonid Repin on 03.06.14.
//  Copyright (c) 2014 Levelab. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LVKMessage.h"
#import "LVKUser.h"

typedef enum DialogTypes {
    Room,
    Dialog
} dialogType;

@interface LVKDialog : NSObject

@property (nonatomic) NSString *title;
@property (nonatomic) NSNumber *chatId;
@property (nonatomic) NSArray *chatUserIds;
@property (nonatomic) dialogType type;
@property (nonatomic) LVKMessage *lastMessage;
@property (nonatomic) LVKUser *user;
@property (nonatomic) NSArray *users;

-(id)initWithDictionary:(NSDictionary *)dictionary;
-(id)initWithPlainDictionary:(NSDictionary *)dictionary;
-(void)adoptUser:(LVKUser *)adoptedUser;
-(void)adoptUsers:(NSArray *)adoptedUsers;
-(NSString *)chatIdKey;

@end
