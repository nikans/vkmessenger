//
//  LVKDialogDeleteAlertDelegate.h
//  VKMessenger
//
//  Created by Leonid Repin on 13.06.14.
//  Copyright (c) 2014 Levelab. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <VKSdk.h>

@interface LVKDialogDeleteAlertDelegate : NSObject <UIAlertViewDelegate>

@property (strong, nonatomic) VKRequest *deleteDialogRequest;
@property (strong, nonatomic) void (^resultBlock) (VKResponse *response);
@property (strong, nonatomic) void (^errorBlock) (NSError *error);

- (id)initWithRequest:(VKRequest *)_deleteDialogRequest resultBlock:(void (^)(VKResponse *))completeBlock
           errorBlock:(void (^)(NSError *))_errorBlock;

@end
