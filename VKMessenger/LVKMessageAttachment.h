//
//  LVKMessageAttachment.h
//  VKMessenger
//
//  Created by Leonid Repin on 05.06.14.
//  Copyright (c) 2014 Levelab. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LVKMessageAttachment : NSObject

@property (nonatomic) NSString *type;

-(id)initWithDictionary:(NSDictionary *)dictionary;

-(id)initWithDictionary:(NSDictionary *)dictionary andTypeString:(NSString *)typeString;

@end
