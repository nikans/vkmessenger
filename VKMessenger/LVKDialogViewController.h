//
//  LVKDetailViewController.h
//  VKMessenger
//
//  Created by Leonid Repin on 03.06.14.
//  Copyright (c) 2014 Levelab. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <VKSdk.h>
#import <UIImageView+WebCache.h>
#import <CCBottomRefreshControl/UIScrollView+BottomRefreshControl.h>
#import "UIViewController+NetworkNotifications.h"
#import "LVKHistoryCollection.h"
#import "LVKDialog.h"
#import "LVKLongPoll.h"
#import "LVKBubbleActionsDelegateProtocol.h"


@interface LVKDialogViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, UISplitViewControllerDelegate, UITextViewDelegate, LVKBubbleActionsDelegateProtocol>

@property (strong, nonatomic) LVKDialog *dialog;

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UITextView *textView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *textViewHeightConstraint;
@property (weak, nonatomic) IBOutlet UIView *textViewContainer;
@property (weak, nonatomic) IBOutlet UIButton *sendButton;

-(IBAction) sendMessage:(id)sender;

- (void)hasSuccessfullySentMessageAtIndexPath:(NSIndexPath *)indexPath;

@end
