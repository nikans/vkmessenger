//
//  LVKMasterViewController.h
//  VKMessenger
//
//  Created by Leonid Repin on 03.06.14.
//  Copyright (c) 2014 Levelab. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LVKDialogListControllerDelegate.h"
@class LVKDialogViewController;

@interface LVKDialogListViewController : UITableViewController <UISearchBarDelegate, LVKDialogListControllerDelegate>

@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;
@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) LVKDialogViewController *detailViewController;

@property (nonatomic) BOOL isSearching;
@property (nonatomic) BOOL isCompactView;

@property (strong, nonatomic) NSMutableDictionary *avatarsCache;

@end
