//
//  LVKUserResponse.h
//  VKMessenger
//
//  Created by Leonid Repin on 04.06.14.
//  Copyright (c) 2014 Levelab. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LVKUser.h"

@interface LVKUsersCollection : NSObject

@property (nonatomic) NSNumber *count;
@property (nonatomic) NSArray *users;
@property (nonatomic) NSDictionary *usersIdx;

-(id)initWithArray:(NSArray *)array;
-(id)initWithDictionary:(NSDictionary *)dictionary;

@end
