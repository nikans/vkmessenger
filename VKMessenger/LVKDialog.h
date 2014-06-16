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
#import "LVKModelEnums.h"

@interface LVKDialog : NSObject

@property (strong, nonatomic) NSString *title;
@property (strong, nonatomic) NSNumber *chatId;
@property (strong, nonatomic) NSArray *chatUserIds;
@property (nonatomic) dialogType type;
@property (strong, nonatomic) LVKMessage *lastMessage;
@property (strong, nonatomic) LVKUser *user;
@property (strong, nonatomic) NSArray *users;

- (id)initWithDictionary:(NSDictionary *)dictionary;
- (id)initWithPlainDictionary:(NSDictionary *)dictionary;
- (id)initWithDictionaryFromSearch:(NSDictionary *)dictionary;
- (void)adoptUser:(LVKUser *)adoptedUser;
- (void)adoptUsers:(NSArray *)adoptedUsers;
- (void)adoptLastMessageUsers:(NSArray *)adoptedUsers;
- (NSString *)chatIdKey;
- (readState)getReadState;
- (id)getChatPicture;
- (id)getChatPictureOfSize:(NSUInteger)size;

@end
