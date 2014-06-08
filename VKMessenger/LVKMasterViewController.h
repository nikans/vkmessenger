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
#import "LVKDialogsCollection.h"
#import "LVKUsersCollection.h"
#import <AudioToolbox/AudioToolbox.h>
#import "LVKLongPoll.h"

@class LVKDetailViewController;

@interface LVKMasterViewController : UITableViewController

@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) LVKDetailViewController *detailViewController;

@end
