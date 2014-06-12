//
//  LVKMasterViewController.h
//  VKMessenger
//
//  Created by Leonid Repin on 03.06.14.
//  Copyright (c) 2014 Levelab. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <VKSdk.h>
#import <CCBottomRefreshControl/UIScrollView+BottomRefreshControl.h>
#import <UIImageView+WebCache.h>
#import "UIViewController+NetworkNotifications.h"
#import "LVKDialogsCollection.h"
#import "LVKUsersCollection.h"
#import <AudioToolbox/AudioToolbox.h>
#import "LVKLongPoll.h"

@class LVKDialogViewController;

@interface LVKDialogListViewController : UITableViewController

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) LVKDialogViewController *detailViewController;

@end
