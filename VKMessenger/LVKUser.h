//
//  LVKUser.h
//  VKMessenger
//
//  Created by Leonid Repin on 04.06.14.
//  Copyright (c) 2014 Levelab. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LVKUser : NSObject

@property (nonatomic) NSNumber *_id;
@property (nonatomic) NSString *firstName;
@property (nonatomic) NSString *lastName;
@property (nonatomic) NSString *fullName;
@property (nonatomic) NSString *photo_100;
@property (nonatomic) BOOL isCurrent;

-(id)initWithDictionary:(NSDictionary *)dictionary;

-(NSString *)getPhoto:(NSUInteger) size;

-(id)createDialog;

@end