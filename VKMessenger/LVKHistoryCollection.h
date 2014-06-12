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

@property (strong, nonatomic) NSNumber *count;
@property (strong, nonatomic) NSArray *messages;

-(id)initWithMessage:(LVKMessage *)message;

-(id)initWithDictionary:(NSDictionary *)dictionary;

-(void)adoptUserArray:(NSArray *)array;

-(NSArray *)getUserIds;

@end
