//
//  LVKDialogDeleteAlertDelegate.m
//  VKMessenger
//
//  Created by Leonid Repin on 13.06.14.
//  Copyright (c) 2014 Levelab. All rights reserved.
//

#import "LVKDialogDeleteAlertDelegate.h"

@implementation LVKDialogDeleteAlertDelegate

@synthesize deleteDialogRequest, resultBlock, errorBlock;

- (id)init
{
    self = [super init];
    
    return self;
}

- (id)initWithRequest:(VKRequest *)_deleteDialogRequest resultBlock:(void (^)(VKResponse *))completeBlock
           errorBlock:(void (^)(NSError *))_errorBlock
{
    self = [self init];
    
    if(self)
    {
        deleteDialogRequest = _deleteDialogRequest;
        resultBlock = completeBlock;
        errorBlock = _errorBlock;
    }
    
    return self;
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(buttonIndex == 1)
    {
        [deleteDialogRequest executeWithResultBlock:resultBlock errorBlock:errorBlock];
    }
}

@end
