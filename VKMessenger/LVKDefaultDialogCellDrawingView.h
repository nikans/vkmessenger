//
//  LVKDefaultDialogCellDrawingView.h
//  VKMessenger
//
//  Created by Eliah Nikans on 6/18/14.
//  Copyright (c) 2014 Levelab. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LVKModelEnums.h"

#define LVKDefaultDialogColorUnread @"#edf2f7"

@interface LVKDefaultDialogCellDrawingView : UIView

@property (nonatomic) readState state;
@property (nonatomic) BOOL isRoom;

@end
