//
//  LVKDefaultDialogCellDrawingViewCompact.m
//  VKMessenger
//
//  Created by Eliah Nikans on 6/18/14.
//  Copyright (c) 2014 Levelab. All rights reserved.
//

#import "LVKDefaultDialogCellDrawingViewCompact.h"

@implementation LVKDefaultDialogCellDrawingViewCompact

- (void)drawForRoom:(BOOL)isRoom {
    if (isRoom) {
        [[UIImage imageNamed:@"usergroup"] drawInRect:CGRectMake(59, 11, 18, 11)];
    }
}

@end
