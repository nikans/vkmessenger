//
//  LVKMessage.h
//  VKMessenger
//
//  Created by Leonid Repin on 03.06.14.
//  Copyright (c) 2014 Levelab. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LVKMessagePartProtocol.h"
#import "LVKMessageAttachment.h"
#import "LVKModelEnums.h"
#import "LVKUser.h"

@interface LVKMessage : NSObject <LVKMessagePartProtocol>

@property (nonatomic) NSNumber *_id;
@property (nonatomic) NSString *body;
@property (nonatomic) NSNumber *chatId;
@property (nonatomic) NSNumber *userId;
@property (nonatomic) dialogType type;
@property (nonatomic) LVKUser *user;
@property (nonatomic) NSDate *date;
@property (nonatomic) BOOL isUnread;
@property (nonatomic) BOOL isOutgoing;
@property (nonatomic) NSArray *attachments;
@property (nonatomic) NSArray *forwarded;

-(id)initWithDictionary:(NSDictionary *)dictionary;
-(void)adoptAttachments:(NSArray *)_attachments;
-(void)adoptForwarded:(NSArray *)_forwarded;
-(void)adoptUserArray:(NSArray *)array;
-(NSArray *)getUserIds;
-(readState)getReadState;
-(NSArray *)getMessageParts;

@end
