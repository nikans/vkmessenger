//
//  LVKMasterViewController.h
//  VKMessenger
//
//  Created by Leonid Repin on 03.06.14.
//  Copyright (c) 2014 Levelab. All rights reserved.
//

#import <UIKit/UIKit.h>

@class LVKDetailViewController;

@interface LVKMasterViewController : UITableViewController

@property (strong, nonatomic) LVKDetailViewController *detailViewController;

@end
