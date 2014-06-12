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

@property (strong, nonatomic) NSNumber *count;
@property (strong, nonatomic) NSArray *dialogs;

-(id)initWithArray:(NSArray *)array;

-(id)initWithDictionary:(NSDictionary *)dictionary;

-(NSArray *)getUserIds;

-(void)adoptUserCollection:(LVKUsersCollection *)collection;

@end
