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

@property (strong, nonatomic) NSNumber *_id;
@property (nonatomic) sendingState state;
@property (strong, nonatomic) NSString *body;
@property (strong, nonatomic) NSNumber *chatId;
@property (strong, nonatomic) NSNumber *userId;
@property (nonatomic) dialogType type;
@property (strong, nonatomic) LVKUser *user;
@property (strong, nonatomic) NSDate *date;
@property (nonatomic) BOOL isUnread;
@property (nonatomic) BOOL isOutgoing;
@property (strong, nonatomic) NSArray *attachments;
@property (strong, nonatomic) NSArray *forwarded;

-(id)initWithDictionary:(NSDictionary *)dictionary;
-(void)adoptAttachments:(NSArray *)_attachments;
-(void)adoptForwarded:(NSArray *)_forwarded;
-(void)adoptUserArray:(NSArray *)array;
-(NSArray *)getUserIds;
-(readState)getReadState;
-(NSArray *)getMessageParts;

@end
