//
//  LVKDialogsResponse.h
//  VKMessenger
//
//  Created by Leonid Repin on 03.06.14.
//  Copyright (c) 2014 Levelab. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LVKDialog.h"
#import "LVKUsersCollection.h"

@interface LVKDialogsCollection : NSObject

@property (nonatomic) NSNumber *count;
@property (nonatomic) NSArray *dialogs;

-(id)initWithDictionary:(NSDictionary *)dictionary;

-(NSArray *)getUserIds;

-(void)adoptUserCollection:(LVKUsersCollection *)collection;

@end
