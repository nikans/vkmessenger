//
//  LVKDefaultDialogCellDrawingView.m
//  VKMessenger
//
//  Created by Eliah Nikans on 6/18/14.
//  Copyright (c) 2014 Levelab. All rights reserved.
//

#import "LVKDefaultDialogCellDrawingView.h"
#import "AVHexColor.h"

@implementation LVKDefaultDialogCellDrawingView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.frame = frame;
    }
    return self;
}


//- (void)redrawWithOptions:(NSDictionary *)options {
//    self.options = options;
//}

- (void)drawRect:(CGRect)rect
{
    [self drawForRoom:self.isRoom];
    [self drawForReadState:self.state];
}

- (void)drawForReadState:(readState)state {
    if (self.state == Read) {
        self.backgroundColor = [UIColor whiteColor];
    }
    else if (self.state == UnreadIncoming) {
        self.backgroundColor = [AVHexColor colorWithHexString:LVKDefaultDialogColorUnread];
    }
    else if (self.state == UnreadOutgoing) {
        self.backgroundColor = [AVHexColor colorWithHexString:LVKDefaultDialogColorUnread];
    }
}

- (void)drawForRoom:(BOOL)isRoom {
    if (isRoom) {
        [[UIImage imageNamed:@"usergroup"] drawInRect:CGRectMake(75, 11, 18, 11)];
    }
}




@end
