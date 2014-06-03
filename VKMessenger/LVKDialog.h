//
//  LVKDialog.h
//  VKMessenger
//
//  Created by Leonid Repin on 03.06.14.
//  Copyright (c) 2014 Levelab. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum DialogTypes {
    Room,
    Dialog
} dialogType;

@interface LVKDialog : NSObject

@property (nonatomic) NSNumber *_id;
@property (nonatomic) NSString *body;
@property (nonatomic) NSString *title;
@property (nonatomic) NSNumber *chatId;
@property (nonatomic) NSNumber *userId;
@property (nonatomic) NSDate *date;
@property (nonatomic) dialogType type;
@property (nonatomic) BOOL readState;
@property (nonatomic) BOOL out;

-(id)initWithDictionary:(NSDictionary *)dictionary;

@end
