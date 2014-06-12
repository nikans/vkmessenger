//
//  LVKUser.h
//  VKMessenger
//
//  Created by Leonid Repin on 04.06.14.
//  Copyright (c) 2014 Levelab. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LVKUser : NSObject

@property (strong, nonatomic) NSNumber *_id;
@property (strong, nonatomic) NSString *firstName;
@property (strong, nonatomic) NSString *lastName;
@property (strong, nonatomic) NSString *fullName;
@property (strong, nonatomic) NSString *photo_100;
@property (nonatomic) BOOL isCurrent;

-(id)initWithDictionary:(NSDictionary *)dictionary;

-(NSString *)getPhoto:(NSUInteger) size;

-(id)createDialog;

@end
