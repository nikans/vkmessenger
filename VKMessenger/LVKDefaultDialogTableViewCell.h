//
//  LVKDefaultDialogTableViewCell.h
//  VKMessenger
//
//  Created by Eliah Nikans on 6/13/14.
//  Copyright (c) 2014 Levelab. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "LVKModelEnums.h"
#import "LVKDialogListControllerDelegate.h"
#import "LVKDefaultDialogCellDrawingView.h"

@interface LVKDefaultDialogTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *avatarsImageView;
@property (weak, nonatomic) IBOutlet UILabel *title;
@property (weak, nonatomic) IBOutlet UILabel *message;
@property (weak, nonatomic) IBOutlet UIImageView *messageAvatar;
@property (weak, nonatomic) IBOutlet UIView *messageBackground;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *messageInsetConstraint;
@property (weak, nonatomic) IBOutlet UILabel *date;
@property (weak, nonatomic) IBOutlet UIView *onlineIndicator;
//@property (weak, nonatomic) IBOutlet UIImageView *roomIndicator;
@property (weak, nonatomic) IBOutlet LVKDefaultDialogCellDrawingView *drawingView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *titleConstraint;

@property (weak, nonatomic) IBOutlet id<LVKDialogListControllerDelegate> controllerDelegate;

@property (nonatomic) BOOL isRoom;
@property (strong, nonatomic) NSString *identifier;
@property (nonatomic) readState state;

- (void)ajustLayoutForReadState:(readState)state;
- (void)ajustLayoutUserIsOnline:(BOOL)isOnline;
- (void)setAvatars:(NSArray *)avatarsURLArray;

@end
