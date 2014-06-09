//
//  LVKNetworkRetryAlertDelegate.m
//  VKMessenger
//
//  Created by Leonid Repin on 09.06.14.
//  Copyright (c) 2014 Levelab. All rights reserved.
//

#import "LVKNetworkRetryAlertDelegate.h"
#import <VKSdk.h>

@interface LVKNetworkRetryAlertDelegate ()

@property (strong, nonatomic) id request;

@end

@implementation LVKNetworkRetryAlertDelegate

@synthesize request;

- (id)init
{
    self = [super init];
    
    return self;
}

- (id)initWithRequest:(id)_request
{
    self = [self init];
    
    if(self)
    {
        request = _request;
    }
    
    return self;
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(buttonIndex == 1)
    {
        [(VKRequest *)request repeat];
    }
}

@end
