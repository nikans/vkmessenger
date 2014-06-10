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

@interface LVKDialogViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, UISplitViewControllerDelegate, UITextViewDelegate, NSLayoutManagerDelegate>

@property (strong, nonatomic) LVKDialog *dialog;

@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) IBOutlet UITextView *textView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *textViewHeightConstraint;

-(IBAction) sendMessage:(id)sender;

@end
