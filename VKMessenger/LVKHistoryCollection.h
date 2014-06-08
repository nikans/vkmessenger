//
//  LVKHistoryResponse.h
//  VKMessenger
//
//  Created by Leonid Repin on 03.06.14.
//  Copyright (c) 2014 Levelab. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LVKMessage.h"

@interface LVKHistoryCollection : NSObject

@property (nonatomic) NSNumber *count;
@property (nonatomic) NSArray *messages;

-(id)initWithMessage:(LVKMessage *)message;

-(id)initWithDictionary:(NSDictionary *)dictionary;

-(void)adoptUserArray:(NSArray *)array;

@end
